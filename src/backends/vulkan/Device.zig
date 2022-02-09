const std = @import("std");

const Allocator = std.mem.Allocator;

const vk = @import("./vk.zig");
const backend = @import("./vulkan.zig");
const constants = @import("./constants.zig");
const webgpu = @import("../../webgpu.zig");

const Instance = @import("./Instance.zig");
const Buffer = @import("./Buffer.zig");

const Device = @This();

const DeviceDispatch = vk.DeviceWrapper(.{
    .destroyDevice = true,
    .createBuffer = true,
    .destroyBuffer = true,
});

pub const vtable = webgpu.Adapter.VTable{
    .deinit_fn = deinit,
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

instance: *Instance,
allocator: Allocator,
handle: vk.Device,
vkd: DeviceDispatch,

pub inline fn cast(device: webgpu.Device) *Device {
    return @ptrCast(*Device, @alignCast(@alignOf(Device), device.ptr));
}

pub fn init(instance: *Instance, device: vk.Device) webgpu.Device {
    var ptr = try instance.allocator.create(Device);
    errdefer instance.allocator.destroy(ptr);

    ptr.instance = instance;
    ptr.allocator = instance.allocator;
    ptr.handle = device;
    ptr.vkd = DeviceDispatch.load(device, instance.get_instance_proc_addr) catch return error.Failed;

    return webgpu.Device{.vtable = &vtable, .ptr = ptr};
}

pub fn deinit(device: webgpu.Device) void {
    var ptr = cast(device);

    ptr.instance.allocator.destroy(ptr);
}

pub fn createBuffer(device: webgpu.Device, descriptor: webgpu.BufferDescriptor) webgpu.Device.CreateBufferError!webgpu.Buffer {
    var ptr = cast(device);

    var queue_family = 0;

    const create_info = vk.BufferCreateInfo{
        .flags = .{},
        .size = descriptor.size,
        .usage = toBufferUsageFlags(descriptor.usage),
        .shader_mode = .exclusive,
        .queue_family_index_count = 1,
        .p_queue_family_indices = &queue_family,
    };

    const handle = ptr.vkd.createBuffer(ptr.handle, &create_info, null)
        catch return error.Failed;
    errdefer ptr.vkd.destroyBuffer(ptr.handle, handle, null);

    return Buffer.init(ptr, handle);
}

inline fn toBufferUsageFlags(usage: webgpu.BufferUsage) vk.BufferUsageFlags {
    return .{
        .transfer_src_bit = usage.copy_src,
        .transfer_dst_bit = usage.copy_dst,
        .uniform_buffer_bit = usage.uniform,
        .storage_buffer_bit = usage.storage,
        .index_buffer_bit = usage.index,
        .vertex_buffer_bit = usage.vertex,
        .indirect_buffer_bit = usage.indirect,
    };
}
