const std = @import("std");

const Sampler = @This();

const backend = @import("backend.zig");
const webgpu = @import("webgpu-core");

device: *backend.Device,

pub fn create(device: *backend.Device, descriptor: webgpu.SamplerDescriptor) !*Sampler {
    _ = descriptor;

    var self = try device.adapter.instance.allocator.create(Sampler);
    errdefer device.adapter.instance.allocator.destroy(self);

    self.device = device;

    return self;
}

pub inline fn sampler(self: *Sampler) webgpu.Sampler {
    return webgpu.Sampler.init(
        self,
        setLabel,
    );
}

pub inline fn from(ptr: *anyopaque) *Sampler {
    return @ptrCast(*Sampler, @alignCast(@alignOf(Sampler), ptr));
}

pub fn destroy(self: *Sampler) void {
    self.device.adapter.instance.allocator.destroy(self);
}

fn setLabel(self: *Sampler, label: ?[]const u8) void {
    _ = self;
    _ = label;
}
