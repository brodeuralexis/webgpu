const std = @import("std");

const Instance = @This();

const webgpu = @import("core.zig");

ptr: *anyopaque,
vtable: *const VTable,

pub const VTable = struct {
    deinit: *const fn(*anyopaque) void,
    create_surface: *const fn(*anyopaque, webgpu.SurfaceDescriptor) CreateSurfaceError!webgpu.Surface,
    process_events: *const fn(*anyopaque) void,
    request_adapter: *const fn(*anyopaque, webgpu.RequestAdapterOptions) webgpu.RequestAdapterError!webgpu.Adapter,
};

pub inline fn init(
    pointer: anytype,
    comptime deinit_fn: *const fn(@TypeOf(pointer)) void,
    comptime create_surface_fn: *const fn(@TypeOf(pointer), webgpu.SurfaceDescriptor) CreateSurfaceError!webgpu.Surface,
    comptime process_events_fn: *const fn(@TypeOf(pointer)) void,
    comptime request_adapter_fn: *const fn(@TypeOf(pointer), webgpu.RequestAdapterOptions) webgpu.RequestAdapterError!webgpu.Adapter,
) Instance {
    const Ptr = @TypeOf(pointer);
    const ptr_info = @typeInfo(Ptr);

    std.debug.assert(ptr_info == .Pointer);
    std.debug.assert(ptr_info.Pointer.size == .One);

    const alignment = ptr_info.Pointer.alignment;

    const gen = struct {
        fn deinitImpl(ptr: *anyopaque) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return deinit_fn(self);
        }

        fn createSurfaceImpl(ptr: *anyopaque, descriptor: webgpu.SurfaceDescriptor) CreateSurfaceError!webgpu.Surface {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return create_surface_fn(self, descriptor);
        }

        fn processEventsImpl(ptr: *anyopaque) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return process_events_fn(self);
        }

        fn requestAdapterImpl(ptr: *anyopaque, options: webgpu.RequestAdapterOptions) webgpu.RequestAdapterError!webgpu.Adapter {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return request_adapter_fn(self, options);
        }

        const vtable = VTable{
            .deinit = deinitImpl,
            .create_surface = createSurfaceImpl,
            .process_events = processEventsImpl,
            .request_adapter = requestAdapterImpl
        };
    };

    return Instance{
        .ptr = pointer,
        .vtable = &gen.vtable,
    };
}

pub inline fn deinit(instance: Instance) void {
    instance.vtable.deinit(instance.ptr);
}

pub const CreateSurfaceError = error {
    OutOfMemory,
};

pub inline fn createSurface(instance: Instance, descriptor: webgpu.SurfaceDescriptor) CreateSurfaceError!webgpu.Surface {
    return instance.vtable.create_surface(instance.ptr, descriptor);
}

pub inline fn processEvents(instance: Instance) void {
    instance.vtable.process_events(instance.ptr);
}

pub inline fn requestAdapter(instance: Instance, options: webgpu.RequestAdapterOptions) webgpu.RequestAdapterError!webgpu.Adapter {
    return instance.vtable.request_adapter(instance.ptr, options);
}
