const std = @import("std");

const Texture = @This();

const webgpu = @import("core.zig");

ptr: *anyopaque,
vtable: *const VTable,

pub const VTable = struct {
    deinit: *const fn(*anyopaque) void,
    create_view: *const fn(*anyopaque, ?webgpu.TextureViewDescriptor) CreateViewError!webgpu.TextureView,
    set_label: *const fn(*anyopaque, ?[]const u8) void,
};

pub inline fn init(
    pointer: anytype,
    comptime deinit_fn: *const fn(@TypeOf(pointer)) void,
    comptime create_view_fn: *const fn(@TypeOf(pointer), ?webgpu.TextureViewDescriptor) CreateViewError!webgpu.TextureView,
    comptime set_label_fn: *const fn(@TypeOf(pointer), ?[]const u8) void,
) Texture {
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

        fn createViewImpl(ptr: *anyopaque, descriptor: ?webgpu.TextureViewDescriptor) CreateViewError!webgpu.TextureView {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return create_view_fn(self, descriptor);
        }

        fn setLabelImpl(ptr: *anyopaque, label: ?[]const u8) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return set_label_fn(self, label);
        }

        const vtable = VTable{
            .deinit = deinitImpl,
            .create_view = createViewImpl,
            .set_label = setLabelImpl,
        };
    };

    return Texture{
        .ptr = pointer,
        .vtable = &gen.vtable,
    };
}

pub inline fn deinit(texture: Texture) void {
    return texture.vtable.deinit(texture.ptr);
}

pub const CreateViewError = error {
    OutOfMemory,
};

pub inline fn createView(texture: Texture, descriptor: ?webgpu.TextureViewDescriptor) CreateViewError!webgpu.TextureView {
    return texture.vtable.create_view(texture.ptr, descriptor);
}

pub inline fn setLabel(texture: Texture, label: ?[]const u8) void {
    return texture.vtable.set_label(texture.ptr, label);
}
