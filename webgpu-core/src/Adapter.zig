const std = @import("std");

const Adapter = @This();

const webgpu = @import("core.zig");

ptr: *anyopaque,
vtable: *const VTable,

pub const VTable = struct {
    enumerate_features: *const fn(*anyopaque) []const webgpu.FeatureName,
    get_limits: *const fn(*anyopaque) webgpu.Limits,
    get_properties: *const fn(*anyopaque) webgpu.AdapterProperties,
    has_feature: *const fn(*anyopaque, webgpu.FeatureName) bool,
    request_device: *const fn(*anyopaque, webgpu.DeviceDescriptor) RequestDeviceError!webgpu.Device,
};

pub inline fn init(
    pointer: anytype,
    comptime enumerate_features_fn: *const fn(@TypeOf(pointer)) []const webgpu.FeatureName,
    comptime get_limits_fn: *const fn(@TypeOf(pointer)) webgpu.Limits,
    comptime get_properties_fn: *const fn(@TypeOf(pointer)) webgpu.AdapterProperties,
    comptime has_feature_fn: *const fn(@TypeOf(pointer), webgpu.FeatureName) bool,
    comptime request_device_fn: *const fn(@TypeOf(pointer), webgpu.DeviceDescriptor) RequestDeviceError!webgpu.Device,
) Adapter {
    const Ptr = @TypeOf(pointer);
    const ptr_info = @typeInfo(Ptr);

    std.debug.assert(ptr_info == .Pointer);
    std.debug.assert(ptr_info.Pointer.size == .One);

    const alignment = ptr_info.Pointer.alignment;

    const gen = struct {
        fn enumerateFeaturesImpl(ptr: *anyopaque) []const webgpu.FeatureName {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return enumerate_features_fn(self);
        }

        fn getLimitsImpl(ptr: *anyopaque) webgpu.Limits {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return get_limits_fn(self);
        }

        fn getPropertiesImpl(ptr: *anyopaque) webgpu.AdapterProperties {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return get_properties_fn(self);
        }

        fn hasFeatureImpl(ptr: *anyopaque, feature_name: webgpu.FeatureName) bool {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return has_feature_fn(self, feature_name);
        }

        fn requestDeviceImpl(ptr: *anyopaque, descriptor: webgpu.DeviceDescriptor) RequestDeviceError!webgpu.Device {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return request_device_fn(self, descriptor);
        }

        const vtable = VTable{
            .enumerate_features = enumerateFeaturesImpl,
            .get_limits = getLimitsImpl,
            .get_properties = getPropertiesImpl,
            .has_feature = hasFeatureImpl,
            .request_device = requestDeviceImpl,
        };
    };

    return Adapter{
        .ptr = pointer,
        .vtable = &gen.vtable,
    };
}

pub inline fn enumerateFeatures(adapter: Adapter) []const webgpu.FeatureName {
    return adapter.vtable.enumerate_features(adapter.ptr);
}

pub inline fn getLimits(adapter: Adapter) webgpu.Limits {
    return adapter.vtable.get_limits(adapter.ptr);
}

pub inline fn getProperties(adapter: Adapter) webgpu.AdapterProperties {
    return adapter.vtable.get_properties(adapter.ptr);
}

pub inline fn hasFeature(adapter: Adapter, feature: webgpu.FeatureName) bool {
    return adapter.vtable.has_feature(adapter.ptr, feature);
}

pub const RequestDeviceError = error {
    Error,
    Unknown,
    OutOfMemory,
};

pub inline fn requestDevice(adapter: Adapter, descriptor: webgpu.DeviceDescriptor) RequestDeviceError!webgpu.Device {
    return adapter.vtable.request_device(adapter.ptr, descriptor);
}
