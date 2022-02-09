const std = @import("std");
const webgpu = @import("./webgpu.zig");

pub const Instance = struct {
    pub const VTable = struct {
        destroy_fn: fn(*Instance) void,
        create_surface_fn: fn(*Instance, webgpu.SurfaceDescriptor) CreateSurfaceError!*Surface,
        request_adapter_fn: fn(*Instance, webgpu.RequestAdapterOptions) RequestAdapterError!*Adapter,
    };

    __vtable: *const VTable,

    pub const CreateError = error {
        OutOfMemory,
        Failed,
    };

    pub inline fn create(comptime B: type, descriptor: webgpu.InstanceDescriptor) CreateError!*Instance {
        return B.create(descriptor);
    }

    pub inline fn destroy(instance: *Instance) void {
        instance.__vtable.destroy_fn(instance);
    }

    pub const CreateSurfaceError = error {
        OutOfMemory,
        Failed,
    };

    pub inline fn createSurface(instance: *Instance, descriptor: webgpu.SurfaceDescriptor) CreateSurfaceError!*Surface {
        return instance.__vtable.create_surface_fn(instance, descriptor);
    }

    pub const RequestAdapterError = error {
        OutOfMemory,
        Unavailable,
        Failed,
        Unknown,
    };

    pub inline fn requestAdapter(instance: *Instance, options: webgpu.RequestAdapterOptions) RequestAdapterError!*Adapter {
        return instance.__vtable.request_adapter_fn(instance, options);
    }
};

pub const Adapter = struct {
    pub const VTable = struct {
        request_device_fn: fn(*Adapter, descriptor: webgpu.DeviceDescriptor) RequestDeviceError!*webgpu.Device,
    };

    __vtable: *const VTable,

    instance: *Instance,

    features: webgpu.Features,
    limits: webgpu.Limits,

    adapter_type: webgpu.AdapterType,
    backend_type: webgpu.BackendType,
    vendor_id: u32,
    device_id: u32,
    name: [:0]const u8,

    pub const RequestDeviceError = error {
        OutOfMemory,
        Failed,
    };

    pub inline fn requestDevice(adapter: *Adapter, descriptor: webgpu.DeviceDescriptor) RequestDeviceError!*webgpu.Device {
        return adapter.__vtable.request_device_fn(adapter, descriptor);
    }
};

pub const Surface = struct {
    pub const VTable = struct {
        destroy_fn: fn(*Surface) void,
        get_preferred_format_fn: fn(*Surface) webgpu.TextureFormat,
    };

    __vtable: *const VTable,

    instance: *Instance,

    pub inline fn destroy(surface: *Surface) void {
        surface.__vtable.destroy_fn(surface);
    }

    pub inline fn getPreferredFormat(surface: *Surface) webgpu.TextureFormat {
        return surface.__vtable.get_preferred_format_fn(surface);
    }
};
