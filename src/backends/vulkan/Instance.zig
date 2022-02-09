const std = @import("std");

const Allocator = std.mem.Allocator;

const vk = @import("./vk.zig");
const constants = @import("./constants.zig");
const webgpu = @import("../../webgpu.zig");
const module = @import("../../utilities/module.zig");

const Adapter = @import("./Adapter.zig");

const Instance = @This();

pub const BaseDispatch = vk.BaseWrapper(.{
    .createInstance = true,
    .getInstanceProcAddr = true,
});

pub const InstanceDispatch = vk.InstanceWrapper(.{
    .destroyInstance = true,
    .enumeratePhysicalDevices = true,
    .getPhysicalDeviceProperties = true,
    .getPhysicalDeviceProperties2 = true,
    .getPhysicalDeviceFeatures = true,
    .enumerateDeviceExtensionProperties = true,
});

const vtable = webgpu.Instance.VTable{
    .destroy_fn = destroy,
    .create_surface_fn = createSurface,
    .request_adapter_fn = requestAdapter,
};

super: webgpu.Instance,

allocator: Allocator,
module: *anyopaque,
get_instance_proc_addr: vk.PfnGetInstanceProcAddr,

vkb: BaseDispatch,

handle: vk.Instance,
vki: InstanceDispatch,

low_power_adapter: ?*Adapter,
high_performance_adapter: ?*Adapter,

pub fn create(descriptor: webgpu.InstanceDescriptor) webgpu.Instance.CreateError!*webgpu.Instance {
    var instance = try descriptor.allocator.create(Instance);
    errdefer descriptor.allocator.destroy(instance);

    instance.super.__vtable = &vtable;

    instance.allocator = descriptor.allocator;

    instance.module = module.load(instance.allocator, constants.LIBVULKAN_NAME) orelse return error.Failed;
    errdefer module.free(instance.module);

    instance.get_instance_proc_addr = @ptrCast(vk.PfnGetInstanceProcAddr,
        module.getProcAddress(instance.module, "vkGetInstanceProcAddr") orelse return error.Failed
    );

    instance.vkb = BaseDispatch.load(instance.get_instance_proc_addr) catch return error.Failed;

    const application_info = vk.ApplicationInfo{
        .p_application_name = null,
        .application_version = 0,
        .p_engine_name = "webgpu",
        .engine_version = vk.makeApiVersion(0, 1, 0, 0),
        .api_version = vk.API_VERSION_1_2,
    };

    const create_info = vk.InstanceCreateInfo{
        .flags = vk.InstanceCreateFlags.fromInt(0),
        .p_application_info = &application_info,
        .enabled_extension_count = 0,
        .pp_enabled_extension_names = undefined,
        .enabled_layer_count = 0,
        .pp_enabled_layer_names = undefined,
    };

    instance.handle = instance.vkb.createInstance(&create_info, null) catch return error.Failed;
    instance.vki = InstanceDispatch.load(instance.handle, instance.get_instance_proc_addr) catch return error.Failed;
    errdefer instance.vki.destroyInstance(instance.handle, null);

    instance.low_power_adapter = null;
    instance.high_performance_adapter = null;

    return &instance.super;
}

fn destroy(super: *webgpu.Instance) void {
    var instance = @fieldParentPtr(Instance, "super", super);

    if (instance.low_power_adapter) |adapter| {
        adapter.destroy();
    }

    if (instance.high_performance_adapter) |adapter| {
        adapter.destroy();
    }

    module.free(instance.module);

    instance.allocator.destroy(instance);
}

fn createSurface(super: *webgpu.Instance, descriptor: webgpu.SurfaceDescriptor) webgpu.Instance.CreateSurfaceError!*webgpu.Surface {
    var instance = @fieldParentPtr(Instance, "super", super);
    _ = descriptor;
    _ = instance;
    return error.Failed;
}

fn requestAdapter(super: *webgpu.Instance, options: webgpu.RequestAdapterOptions) webgpu.Instance.RequestAdapterError!*webgpu.Adapter {
    var instance = @fieldParentPtr(Instance, "super", super);

    var adapter = switch (options.power_preference) {
        .low_power => &instance.low_power_adapter,
        .high_performance => &instance.high_performance_adapter,
    };

    if (adapter.*) |cached| {
        return &cached.super;
    }

    adapter.* = try Adapter.create(instance, try pickPhysicalDevice(instance, options));

    return &adapter.*.?.super;
}

fn pickPhysicalDevice(instance: *Instance, options: webgpu.RequestAdapterOptions) !vk.PhysicalDevice {
    var physical_devices_len: u32 = undefined;
    if ((instance.vki.enumeratePhysicalDevices(instance.handle, &physical_devices_len, null) catch return error.Failed) != .success) {
        return error.Unknown;
    }

    var physical_devices = try instance.allocator.alloc(vk.PhysicalDevice, physical_devices_len);
    defer instance.allocator.free(physical_devices);

    if ((instance.vki.enumeratePhysicalDevices(instance.handle, &physical_devices_len, physical_devices.ptr) catch return error.Failed) != .success) {
        return error.Unknown;
    }

    var best_physical_device: ?vk.PhysicalDevice = null;
    var best_score: usize = 0;

    for (physical_devices) |physical_device| {
        if (try scorePhysicalDevice(instance, physical_device, options)) |score| {
            if (score > best_score) {
                best_physical_device = physical_device;
                best_score = score;
            }
        }
    }

    return best_physical_device orelse error.Unavailable;
}

fn scorePhysicalDevice(instance: *Instance, physical_device: vk.PhysicalDevice, options: webgpu.RequestAdapterOptions) !?usize {
    const properties = instance.vki.getPhysicalDeviceProperties(physical_device);

    var score: usize = 0;

    switch (options.power_preference) {
        .low_power => {
            switch (properties.device_type) {
                .integrated_gpu => {
                    score += 1000;
                },
                .discrete_gpu => {
                    score += 100;
                },
                else => {},
            }
        },
        .high_performance => {
            switch (properties.device_type) {
                .discrete_gpu => {
                    score += 1000;
                },
                .integrated_gpu => {
                    score += 100;
                },
                else => {
                    if (!options.force_fallback_adapter) {
                        return null;
                    }
                },
            }
        },
    }

    return score;
}
