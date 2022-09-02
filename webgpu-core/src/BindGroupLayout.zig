const std = @import("std");

const BindGroupLayout = @This();

const webgpu = @import("core.zig");

ptr: *anyopaque,
vtable: *const VTable,

pub const VTable = struct {
    deinit: *const fn(*anyopaque) void,
    set_label: *const fn(*anyopaque, ?[]const u8) void,
};

pub inline fn init(
    pointer: anytype,
    comptime deinit_fn: *const fn(@TypeOf(pointer)) void,
    comptime set_label_fn: *const fn(@TypeOf(pointer), ?[]const u8) void,
) BindGroupLayout {
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

        fn setLabelImpl(ptr: *anyopaque, label: ?[]const u8) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return set_label_fn(self, label);
        }

        const vtable = VTable{
            .deinit = deinitImpl,
            .set_label = setLabelImpl,
        };
    };

    return BindGroupLayout{
        .ptr = pointer,
        .vtable = &gen.vtable,
    };
}

pub inline fn deinit(bind_group_layout: BindGroupLayout) void {
    bind_group_layout.vtable.deinit(bind_group_layout.ptr);
}

pub inline fn setLabel(bind_group_layout: BindGroupLayout, label: ?[]const u8) void {
    bind_group_layout.vtable.set_label(bind_group_layout.ptr, label);
}
