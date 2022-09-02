const std = @import("std");

const TextureView = @This();

const backend = @import("backend.zig");
const webgpu = @import("webgpu-core");

device: *backend.Device,

pub fn create(device: *backend.Device, texture: *backend.Texture, descriptor: ?webgpu.TextureViewDescriptor) !*TextureView {
    _ = texture;
    _ = descriptor;

    var self = try device.adapter.instance.allocator.create(TextureView);
    errdefer device.adapter.instance.allocator.destroy(self);

    self.device = device;

    return self;
}

pub inline fn textureView(self: *TextureView) webgpu.TextureView {
    return webgpu.TextureView.init(
        self,
        setLabel,
    );
}

pub inline fn from(ptr: *anyopaque) *TextureView {
    return @ptrCast(*TextureView, @alignCast(@alignOf(TextureView), ptr));
}

pub fn destroy(self: *TextureView) void {
    self.device.adapter.instance.allocator.destroy(self);
}

fn setLabel(self: *TextureView, label: ?[]const u8) void {
    _ = self;
    _ = label;
}
