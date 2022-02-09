const std = @import("std");

const Allocator = std.mem.Allocator;

const webgpu = @import("../../../webgpu.zig");
const vulkan = @import("../vulkan.zig");
const vk = @import("../vk.zig");
const queue_families = @import("../queue_families.zig");

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

instance: *vulkan.Instance,

allocator: Allocator,

handle: vk.Device,

families: queue_families.QueueFamilies,

vkd: DeviceDispatch,

queue: *vulkan.Queue,

pub fn create(adapter: *vulkan.Adapter, descriptor: webgpu.DeviceDescriptor) !*Device {
    _ = descriptor;

    var device = try adapter.instance.allocator.create(Device);
    errdefer adapter.instance.allocator.destroy(device);

    device.super.__vtable = &vtable;

    device.allocator = adapter.instance.allocator;

    device.instance = adapter.instance;

    device.families = adapter.families;

    const queue_priorities: f32 = 1;

    const queue_create_info = vk.DeviceQueueCreateInfo{
        .flags = vk.DeviceQueueCreateFlags{},
        .queue_family_index = adapter.families.graphics.?,
        .queue_count = 1,
        .p_queue_priorities = @ptrCast([*]const f32, &queue_priorities),
    };

    const features = vk.PhysicalDeviceFeatures{};

    const create_info = vk.DeviceCreateInfo{
        .flags = vk.DeviceCreateFlags{},
        .queue_create_info_count = 1,
        .p_queue_create_infos = @ptrCast([*]const vk.DeviceQueueCreateInfo, &queue_create_info),
        .enabled_layer_count = 0,
        .pp_enabled_layer_names = undefined,
        .enabled_extension_count = 0,
        .pp_enabled_extension_names = undefined,
        .p_enabled_features = &features,
    };

    device.handle = adapter.instance.vki.createDevice(adapter.handle, &create_info, null)
        catch return error.Failed;
    device.vkd = DeviceDispatch.load(device.handle, adapter.instance.vki.dispatch.vkGetDeviceProcAddr)
        catch return error.Failed;
    errdefer device.vkd.destroyDevice(device.handle, null);

    device.queue = vulkan.Queue.create(device, adapter.families.graphics.?, 0)
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
