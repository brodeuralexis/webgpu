const std = @import("std");

const Texture = @This();

const backend = @import("backend.zig");
const webgpu = @import("webgpu-core");

device: *backend.Device,

pub fn create(device: *backend.Device, descriptor: webgpu.TextureDescriptor) !*Texture {
    _ = descriptor;

    var self = try device.adapter.instance.allocator.create(Texture);
    errdefer device.adapter.instance.allocator.destroy(self);

    self.device = device;

    return self;
}

pub inline fn texture(self: *Texture) webgpu.Texture {
    return webgpu.Texture.init(
        self,
        destroy,
        createView,
        setLabel,
    );
}

pub inline fn from(ptr: *anyopaque) *Texture {
    return @ptrCast(*Texture, @alignCast(@alignOf(Texture), ptr));
}

pub fn destroy(self: *Texture) void {
    self.device.adapter.instance.allocator.destroy(self);
}

fn createView(self: *Texture, descriptor: ?webgpu.TextureViewDescriptor) webgpu.Texture.CreateViewError!webgpu.TextureView {
    var texture_view = try backend.TextureView.create(self.device, self, descriptor);
    errdefer texture_view.destroy();

    return texture_view.textureView();
}

fn setLabel(self: *Texture, label: ?[]const u8) void {
    _ = self;
    _ = label;
}
