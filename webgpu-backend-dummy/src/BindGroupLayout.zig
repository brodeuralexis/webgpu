const std = @import("std");

const BindGroupLayout = @This();

const backend = @import("backend.zig");
const webgpu = @import("webgpu-core");

device: *backend.Device,

pub fn create(device: *backend.Device, descriptor: webgpu.BindGroupLayoutDescriptor) !*BindGroupLayout {
    _ = descriptor;

    var self = try device.adapter.instance.allocator.create(BindGroupLayout);
    errdefer device.adapter.instance.allocator.destroy(self);

    self.* = BindGroupLayout{
        .device = device,
    };

    return self;
}

pub inline fn bindGroupLayout(self: *BindGroupLayout) webgpu.BindGroupLayout {
    return webgpu.BindGroupLayout.init(
        self,
        destroy,
        setLabel,
    );
}

pub inline fn from(ptr: *anyopaque) *BindGroupLayout {
    return @ptrCast(*BindGroupLayout, @alignCast(@alignOf(BindGroupLayout), ptr));
}

pub fn destroy(self: *BindGroupLayout) void {
    self.device.adapter.instance.allocator.destroy(self);
}

fn setLabel(self: *BindGroupLayout, label: ?[]const u8) void {
    _ = self;
    _ = label;
}
