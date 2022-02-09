const std = @import("std");

const webgpu = @import("../../../webgpu.zig");
const vulkan = @import("../vulkan.zig");
const vk = @import("../vk.zig");

const Queue = @This();

const vtable = webgpu.Queue.VTable{
    .submit_fn = undefined,
    .on_submitted_work_done_fn = undefined,
    .write_buffer_fn = undefined,
    .write_texture_fn = undefined,
};

super: webgpu.Queue,

handle: vk.Queue,

pub fn create(device: *vulkan.Device, queue_family: u32, queue_index: u32) !*Queue {
    var queue = try device.allocator.create(Queue);
    errdefer device.allocator.destroy(queue);

    queue.super = .{
        .__vtable = &vtable,
        .device = &device.super,
    };

    queue.handle = device.vkd.getDeviceQueue(device.handle, queue_family, queue_index);

    return queue;
}

pub fn destroy(queue: *Queue, device: *vulkan.Device) void {
    device.allocator.destroy(queue);
}
