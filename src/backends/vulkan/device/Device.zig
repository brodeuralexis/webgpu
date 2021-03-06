const std = @import("std");

const Allocator = std.mem.Allocator;

const webgpu = @import("../../../webgpu.zig");
const vulkan = @import("../vulkan.zig");
const vk = @import("../vk.zig");
const QueueFamilies = @import("../QueueFamilies.zig");
const log = @import("../log.zig");

const Device = @This();

const DeviceDispatch = vk.DeviceWrapper(.{
    .destroyDevice = true,
    .getDeviceQueue = true,
    .createBuffer = true,
    .destroyBuffer = true,
});

pub const vtable = webgpu.Device.VTable{
    .destroy_fn = destroy,
    .create_buffer_fn = createBuffer,
    .create_texture_fn = undefined,
    .create_sampler_fn = undefined,
    .create_bind_group_layout_fn = undefined,
    .create_pipeline_layout_fn = undefined,
    .create_bind_group_fn = undefined,
    .create_shader_module_fn = undefined,
    .create_compute_pipeline_fn = undefined,
    .create_render_pipeline_fn = undefined,
    .create_command_encoder_fn = undefined,
    .create_render_bundle_encoder_fn = undefined,
};

super: webgpu.Device,

allocator: Allocator,

handle: vk.Device,

queue_families: QueueFamilies,

vkd: DeviceDispatch,

queue: *vulkan.Queue,

pub fn create(adapter: *vulkan.Adapter, descriptor: webgpu.DeviceDescriptor) !*Device {
    var instance = @fieldParentPtr(vulkan.Instance, "super", adapter.super.instance);

    _ = descriptor;

    var device = try instance.allocator.create(Device);
    errdefer instance.allocator.destroy(device);

    device.super = .{
        .__vtable = &vtable,
        .instance = &instance.super,
        .adapter = &adapter.super,
        .queue = undefined,
        .features = .{},
        .limits = .{},
    };

    device.allocator = instance.allocator;

    device.queue_families = adapter.queue_families;

    if (!(try device.checkDeviceLayersSupport())) {
        return error.MissingDeviceLayers;
    }

    if (!(try device.checkDeviceExtensionsSupport())) {
        return error.MissingDeviceExtensions;
    }

    const queue_priorities: f32 = 1;

    const queue_create_info = vk.DeviceQueueCreateInfo{
        .flags = vk.DeviceQueueCreateFlags{},
        .queue_family_index = device.queue_families.graphics.?,
        .queue_count = 1,
        .p_queue_priorities = @ptrCast([*]const f32, &queue_priorities),
    };

    const features = vk.PhysicalDeviceFeatures{};

    const create_info = vk.DeviceCreateInfo{
        .flags = vk.DeviceCreateFlags{},
        .queue_create_info_count = 1,
        .p_queue_create_infos = @ptrCast([*]const vk.DeviceQueueCreateInfo, &queue_create_info),
        .enabled_layer_count = vulkan.DEVICE_LAYERS.len,
        .pp_enabled_layer_names = @ptrCast([*]const [*:0]const u8, &vulkan.DEVICE_LAYERS),
        .enabled_extension_count = vulkan.DEVICE_EXTENSIONS.len,
        .pp_enabled_extension_names = @ptrCast([*]const [*:0]const u8, &vulkan.DEVICE_EXTENSIONS),
        .p_enabled_features = &features,
    };

    device.handle = instance.vki.createDevice(adapter.handle, &create_info, null)
        catch return error.Failed;
    device.vkd = DeviceDispatch.load(device.handle, instance.vki.dispatch.vkGetDeviceProcAddr)
        catch return error.Failed;
    errdefer device.vkd.destroyDevice(device.handle, null);

    device.queue = vulkan.Queue.create(device, adapter.queue_families.graphics.?, 0)
        catch return error.Failed;
    errdefer device.queue.destroy(device);

    device.super.queue = &device.queue.super;

    return device;
}

fn destroy(super: *webgpu.Device) void {
    var device = @fieldParentPtr(Device, "super", super);

    device.queue.destroy(device);
    device.allocator.destroy(device);
}

fn createBuffer(super: *webgpu.Device, descriptor: webgpu.BufferDescriptor) webgpu.Device.CreateBufferError!*webgpu.Buffer {
    var device = @fieldParentPtr(Device, "super", super);

    var buffer = try vulkan.Buffer.create(device, descriptor);

    return &buffer.super;
}

fn checkDeviceLayersSupport(device: *Device) !bool {
    var instance = @fieldParentPtr(vulkan.Instance, "super", device.super.instance);
    var adapter = @fieldParentPtr(vulkan.Adapter, "super", device.super.adapter);

    var layers_len: u32 = undefined;
    if ((try instance.vki.enumerateDeviceLayerProperties(adapter.handle, &layers_len, null)) != .success) {
        return error.Failed;
    }

    var layers = try instance.allocator.alloc(vk.LayerProperties, layers_len);
    defer instance.allocator.free(layers);
    if ((try instance.vki.enumerateDeviceLayerProperties(adapter.handle, &layers_len, layers.ptr)) != .success) {
        return error.Failed;
    }

    for (vulkan.DEVICE_LAYERS) |validation_layer| {
        const validation_layer_name = std.mem.sliceTo(validation_layer, 0);
        var found = false;

        for (layers) |layer| {
            if (std.mem.eql(u8, validation_layer_name, std.mem.sliceTo(&layer.layer_name, 0))) {
                found = true;
                break;
            }
        }

        if (!found) {
            log.err("Missing required device layer: {s}", .{ validation_layer_name });
            return false;
        } else {
            log.debug("Found required device layer: {s}", .{ validation_layer_name });
        }
    }

    return true;
}

fn checkDeviceExtensionsSupport(device: *Device) !bool {
    var instance = @fieldParentPtr(vulkan.Instance, "super", device.super.instance);
    var adapter = @fieldParentPtr(vulkan.Adapter, "super", device.super.adapter);

    var extensions_len: u32 = undefined;
    if ((try instance.vki.enumerateDeviceExtensionProperties(adapter.handle, null, &extensions_len, null)) != .success) {
        return error.Failed;
    }

    var extensions = try instance.allocator.alloc(vk.ExtensionProperties, extensions_len);
    defer instance.allocator.free(extensions);
    if ((try instance.vki.enumerateDeviceExtensionProperties(adapter.handle, null, &extensions_len, extensions.ptr)) != .success) {
        return error.Failed;
    }

    for (vulkan.DEVICE_EXTENSIONS) |surface_extension| {
        const surface_extension_name = std.mem.sliceTo(surface_extension, 0);

        var found = false;

        for (extensions) |extension| {
            if (std.mem.eql(u8, surface_extension_name, std.mem.sliceTo(&extension.extension_name, 0))) {
                found = true;
                break;
            }
        }

        if (!found) {
            log.err("Missing required device extension: {s}", .{ surface_extension_name });
            return false;
        } else {
            log.debug("Found required device extension: {s}", .{ surface_extension_name });
        }
    }

    return true;
}
