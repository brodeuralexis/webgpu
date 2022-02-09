const std = @import("std");

const webgpu = @import("../../../webgpu.zig");
const vulkan = @import("../vulkan.zig");
const vk = @import("../vk.zig");

const Buffer = @This();

pub const vtable = webgpu.Buffer.VTable{
    .destroy_fn = destroy,
    .get_const_mapped_range_fn = undefined,
    .get_mapped_range_fn = undefined,
    .map_async_fn = undefined,
    .unmap_fn = undefined,
};

super: webgpu.Buffer,

handle: vk.Buffer,

pub fn create(device: *vulkan.Device, descriptor: webgpu.BufferDescriptor) webgpu.Device.CreateBufferError!*Buffer {
    var buffer = try device.allocator.create(Buffer);
    errdefer device.allocator.destroy(buffer);

    buffer.super = .{
        .__vtable = &vtable,
        .device = &device.super,
    };

    const create_info = vk.BufferCreateInfo{
        .flags = .{},
        .size = descriptor.size,
        .usage = toBufferUsageFlags(descriptor.usage),
        .sharing_mode = .exclusive,
        .queue_family_index_count = 1,
        .p_queue_family_indices = @ptrCast([*]const u32, &device.queue_families.graphics.?),
    };

    buffer.handle = device.vkd.createBuffer(device.handle, &create_info, null)
        catch return error.Failed;
    errdefer device.vkd.destroyBuffer(device.handle, buffer.handle, null);

    return buffer;
}

fn destroy(super: *webgpu.Buffer) void {
    var buffer = @fieldParentPtr(Buffer, "super", super);
    var device = @fieldParentPtr(vulkan.Device, "super", super.device);

    device.vkd.destroyBuffer(device.handle, buffer.handle, null);
    device.allocator.destroy(buffer);
}

fn getConstMappedRange(super: *webgpu.Buffer, offset: usize, size: usize) webgpu.Buffer.GetConstMappedRangeError![]align(16) const u8 {
    _ = super;
    _ = offset;
    _ = size;

    unreachable;
}

fn getMappedRange(super: *webgpu.Buffer, offset: usize, size: usize) webgpu.Buffer.GetMappedRangeError![]align(16) u8 {
    _ = super;
    _ = offset;
    _ = size;

    unreachable;
}

fn mapAsync(super: *webgpu.Buffer, mode: webgpu.MapMode, offset: usize, size: usize) webgpu.Buffer.MapAsyncError!void {
    _ = super;
    _ = mode;
    _ = offset;
    _ = size;
}

fn unmap(super: *webgpu.Buffer) webgpu.Buffer.UnmapError!void {
    _ = super;
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
