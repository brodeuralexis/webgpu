const std = @import("std");

const SwapChain = @This();

const backend = @import("backend.zig");
const webgpu = @import("webgpu-core");

device: *backend.Device,
texture: *backend.Texture,
texture_view: *backend.TextureView,

pub fn create(device: *backend.Device, descriptor: webgpu.SwapChainDescriptor) !*SwapChain {
    _ = descriptor;

    var self = try device.adapter.instance.allocator.create(SwapChain);
    errdefer device.adapter.instance.allocator.destroy(self);

    self.device = device;

    self.texture = try backend.Texture.create(device, undefined);
    errdefer self.texture.destroy();

    self.texture_view = try backend.TextureView.create(device, self.texture, undefined);
    errdefer self.texture_view.destroy();

    return self;
}

pub inline fn swapChain(self: *SwapChain) webgpu.SwapChain {
    return webgpu.SwapChain.init(
        self,
        getCurrentTextureView,
        present,
    );
}

pub inline fn from(ptr: *anyopaque) *SwapChain {
    return @ptrCast(*SwapChain, @alignCast(@alignOf(SwapChain), ptr));
}

pub fn destroy(self: *SwapChain) void {
    self.device.adapter.instance.allocator.destroy(self);
}

fn getCurrentTextureView(self: *SwapChain) webgpu.TextureView {
    return self.texture_view.textureView();
}

fn present(self: *SwapChain) void {
    _ = self;
}
