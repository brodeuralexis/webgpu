const std = @import("std");

const QuerySet = @This();

const backend = @import("backend.zig");
const webgpu = @import("webgpu-core");

device: *backend.Device,

pub fn create(device: *backend.Device, descriptor: webgpu.QuerySetDescriptor) !*QuerySet {
    _ = descriptor;

    var self = try device.adapter.instance.allocator.create(QuerySet);
    errdefer device.adapter.instance.allocator.destroy(self);

    self.device = device;

    return self;
}

pub inline fn querySet(self: *QuerySet) webgpu.QuerySet {
    return webgpu.QuerySet.init(
        self,
        destroy,
        setLabel,
    );
}

pub inline fn from(ptr: *anyopaque) *QuerySet {
    return @ptrCast(*QuerySet, @alignCast(@alignOf(QuerySet), ptr));
}

pub fn destroy(self: *QuerySet) void {
    self.device.adapter.instance.allocator.destroy(self);
}

fn setLabel(self: *QuerySet, label: ?[]const u8) void {
    _ = self;
    _ = label;
}
