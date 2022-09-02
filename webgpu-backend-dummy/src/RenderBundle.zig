const std = @import("std");

const RenderBundle = @This();

const backend = @import("backend.zig");
const webgpu = @import("webgpu-core");

device: *backend.Device,

pub fn create(device: *backend.Device, descriptor: ?webgpu.RenderBundleDescriptor) !*RenderBundle {
    _ = descriptor;

    var self = try device.adapter.instance.allocator.create(RenderBundle);
    errdefer device.adapter.instance.allocator.destroy(self);

    self.device = device;

    return self;
}

pub inline fn renderBundle(self: *RenderBundle) webgpu.RenderBundle {
    return webgpu.RenderBundle.init(
        self,
    );
}

pub inline fn from(ptr: *anyopaque) *RenderBundle {
    return @ptrCast(*RenderBundle, @alignCast(@alignOf(RenderBundle), ptr));
}

pub fn destroy(self: *RenderBundle) void {
    self.device.adapter.instance.allocator.destroy(self);
}
