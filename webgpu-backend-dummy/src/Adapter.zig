const std = @import("std");

const Adapter = @This();

const backend = @import("backend.zig");
const webgpu = @import("webgpu-core");

instance: *backend.Instance,

pub fn create(instance: *backend.Instance, options: webgpu.RequestAdapterOptions) webgpu.RequestAdapterError!*Adapter {
    _ = options;

    var self = try instance.allocator.create(Adapter);
    errdefer instance.allocator.destroy(self);

    self.instance = instance;

    return self;
}

pub inline fn adapter(self: *Adapter) webgpu.Adapter {
    return webgpu.Adapter.init(
        self,
        enumerateFeatures,
        getLimits,
        getProperties,
        hasFeature,
        requestDevice,
    );
}

pub inline fn from(ptr: *anyopaque) *Adapter {
    return @ptrCast(*Adapter, @alignCast(@alignOf(Adapter), ptr));
}

pub fn destroy(self: *Adapter) void {
    self.instance.allocator.destroy(self);
}

fn enumerateFeatures(self: *Adapter) []const webgpu.FeatureName {
    _ = self;

    return &[0]webgpu.FeatureName{};
}

fn getLimits(self: *Adapter) webgpu.Limits {
    _ = self;

    return std.mem.zeroes(webgpu.Limits);
}

fn getProperties(self: *Adapter) webgpu.AdapterProperties {
    _ = self;

    return .{
        .vendor_id = 0,
        .device_id = 0,
        .name = "backend",
        .driver_descriptor = "backend",
        .adapter_type = .unknown,
        .backend_type = .opengles,
    };
}

fn hasFeature(self: *Adapter, feature_name: webgpu.FeatureName) bool {
    _ = self;
    _ = feature_name;

    return false;
}

fn requestDevice(self: *Adapter, descriptor: webgpu.DeviceDescriptor) webgpu.Adapter.RequestDeviceError!webgpu.Device {
    var device = try backend.Device.create(self, descriptor);
    errdefer device.destroy();

    return device.device();
}
