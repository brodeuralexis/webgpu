const std = @import("std");

const Allocator = std.mem.Allocator;

const webgpu = @import("../../webgpu.zig");
const dummy = @import("./dummy.zig");

pub const Instance = struct {
    const vtable = webgpu.Instance.VTable{
        .destroy_fn = destroy,
        .create_surface_fn = createSurface,
        .request_adapter_fn = requestAdapter,
    };

    super: webgpu.Instance,

    allocator: Allocator,

    low_power_adapter: ?*Adapter,
    high_performance_adapter: ?*Adapter,

    pub fn create(descriptor: webgpu.InstanceDescriptor) webgpu.Instance.CreateError!*Instance {
        var instance = try descriptor.allocator.create(Instance);
        errdefer descriptor.allocator.destroy(instance);

        instance.super.__vtable = &vtable;

        instance.allocator = descriptor.allocator;

        instance.low_power_adapter = null;
        instance.high_performance_adapter = null;

        return instance;
    }

    fn destroy(super: *webgpu.Instance) void {
        var instance = @fieldParentPtr(Instance, "super", super);

        if (instance.low_power_adapter) |adapter| {
            adapter.destroy();
        }

        if (instance.high_performance_adapter) |adapter| {
            adapter.destroy();
        }

        instance.allocator.destroy(instance);
    }

    fn createSurface(super: *webgpu.Instance, descriptor: webgpu.SurfaceDescriptor) webgpu.Instance.CreateSurfaceError!*webgpu.Surface {
        var instance = @fieldParentPtr(Instance, "super", super);

        var surface = try Surface.create(instance, descriptor);

        return &surface.super;
    }

    fn requestAdapter(super: *webgpu.Instance, options: webgpu.RequestAdapterOptions) webgpu.Instance.RequestAdapterError!*webgpu.Adapter {
        var instance = @fieldParentPtr(Instance, "super", super);

        var adapter = switch (options.power_preference) {
            .low_power => &instance.low_power_adapter,
            .high_performance => &instance.high_performance_adapter,
        };

        if (adapter.*) |cached| {
            return &cached.super;
        }

        adapter.* = try Adapter.create(instance, options);
        errdefer adapter.*.?.destroy();

        return &adapter.*.?.super;
    }
};

pub const Adapter = struct {
    const vtable = webgpu.Adapter.VTable{
        .request_device_fn = requestDevice,
    };

    super: webgpu.Adapter,

    pub fn create(instance: *Instance, options: webgpu.RequestAdapterOptions) webgpu.Instance.RequestAdapterError!*Adapter {
        _ = options;

        var adapter = try instance.allocator.create(Adapter);
        errdefer instance.allocator.destroy(adapter);

        adapter.super = .{
            .__vtable = &vtable,
            .instance = &instance.super,
            .features = .{},
            .limits = .{},
            .adapter_type = .unknown,
            .backend_type = .unknown,
            .device_id = 0,
            .vendor_id = 0,
            .name = "Dummy",
        };

        return adapter;
    }

    pub fn destroy(adapter: *Adapter) void {
        var instance = @fieldParentPtr(Instance, "super", adapter.super.instance);

        instance.allocator.destroy(adapter);
    }

    fn requestDevice(super: *webgpu.Adapter, descriptor: webgpu.DeviceDescriptor) webgpu.Adapter.RequestDeviceError!*webgpu.Device {
        var adapter = @fieldParentPtr(Adapter, "super", super);

        var device = try dummy.Device.create(adapter, descriptor);

        return &device.super;
    }
};

pub const Surface = struct {
    const vtable = webgpu.Surface.VTable{
        .destroy_fn = destroy,
        .get_preferred_format_fn = getPreferredFormat,
    };

    super: webgpu.Surface,

    pub fn create(instance: *Instance, descriptor: webgpu.SurfaceDescriptor) webgpu.Instance.CreateSurfaceError!*Surface {
        _ = descriptor;

        var surface = try instance.allocator.create(Surface);
        errdefer instance.allocator.destroy(surface);

        surface.super = .{
            .__vtable = &vtable,
            .instance = &instance.super,
        };

        return surface;
    }

    fn destroy(super: *webgpu.Surface) void {
        var surface = @fieldParentPtr(Surface, "super", super);
        var instance = @fieldParentPtr(Instance, "super", surface.super.instance);

        instance.allocator.destroy(surface);
    }

    fn getPreferredFormat(super: *webgpu.Surface) webgpu.TextureFormat {
        _ = super;

        return .bgra8_unorm;
    }
};
