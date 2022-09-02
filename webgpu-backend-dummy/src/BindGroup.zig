const std = @import("std");

const BindGroup = @This();

const backend = @import("backend.zig");
const webgpu = @import("webgpu-core");

device: *backend.Device,

pub fn create(device: *backend.Device, descriptor: webgpu.BindGroupDescriptor) !*BindGroup {
    _ = descriptor;

    var self = try device.adapter.instance.allocator.create(BindGroup);
    errdefer device.adapter.instance.destroy(self);

    self.* = BindGroup{
        .device = device,
    };

    return self;
}

pub inline fn bindGroup(self: *BindGroup) webgpu.BindGroup {
    return webgpu.BindGroup.init(
        self,
        destroy,
        setLabel,
    );
}

pub inline fn from(ptr: *anyopaque) *BindGroup {
    return @ptrCast(*BindGroup, @alignCast(@alignOf(BindGroup), ptr));
}

pub fn destroy(self: *BindGroup) void {
    self.device.adapter.instance.allocator.destroy(self);
}

fn setLabel(self: *BindGroup, label: ?[]const u8) void {
    _ = self;
    _ = label;
}
