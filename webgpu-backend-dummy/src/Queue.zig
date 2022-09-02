const std = @import("std");

const Queue = @This();

const backend = @import("backend.zig");
const webgpu = @import("webgpu-core");

device: *backend.Device,

pub fn create(device: *backend.Device, descriptor: webgpu.QueueDescriptor) !*Queue {
    _ = descriptor;

    var self = try device.adapter.instance.allocator.create(Queue);
    errdefer device.adapter.instance.allocator.destroy(self);

    self.device = device;

    return self;
}

pub inline fn queue(self: *Queue) webgpu.Queue {
    return webgpu.Queue.init(
        self,
        setLabel,
        submit,
        writeBuffer,
        writeTexture,
    );
}

pub inline fn from(ptr: *anyopaque) *Queue {
    return @ptrCast(*Queue, @alignCast(@alignOf(Queue), ptr));
}

pub fn destroy(self: *Queue) void {
    self.device.adapter.instance.allocator.destroy(self);
}

fn setLabel(self: *Queue, label: ?[]const u8) void {
    _ = self;
    _ = label;
}

fn submit(self: *Queue, command_buffers: []const webgpu.CommandBuffer) void {
    _ = self;
    _ = command_buffers;
}

fn writeBuffer(self: *Queue, buffer: webgpu.Buffer, buffer_offset: usize, data: []const u8) void {
    _ = self;
    _ = buffer;
    _ = buffer_offset;
    _ = data;
}

fn writeTexture(self: *Queue, destination: webgpu.ImageCopyTexture, data: []const u8, data_layout: webgpu.TextureDataLayout, write_size: webgpu.Extent3D) void {
    _ = self;
    _ = destination;
    _ = data;
    _ = data_layout;
    _ = write_size;
}
