const std = @import("std");

const CommandBuffer = @This();

const backend = @import("backend.zig");
const webgpu = @import("webgpu-core");

device: *backend.Device,

pub fn create(device: *backend.Device, descriptor: ?webgpu.CommandBufferDescriptor) !*CommandBuffer {
    _ = descriptor;

    var self = try device.adapter.instance.allocator.create(CommandBuffer);
    errdefer device.adapter.instance.allocator.destroy(self);

    self.device = device;

    return self;
}

pub inline fn commandBuffer(self: *CommandBuffer) webgpu.CommandBuffer {
    return webgpu.CommandBuffer.init(
        self,
        destroy,
        setLabel,
    );
}

pub inline fn from(ptr: *anyopaque) *CommandBuffer {
    return @ptrCast(*CommandBuffer, @alignCast(@alignOf(CommandBuffer), ptr));
}

pub fn destroy(self: *CommandBuffer) void {
    self.device.adapter.instance.allocator.destroy(self);
}

fn setLabel(self: *CommandBuffer, label: ?[]const u8) void {
    _ = self;
    _ = label;
}
