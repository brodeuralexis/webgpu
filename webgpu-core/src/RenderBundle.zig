const std = @import("std");

const RenderBundle = @This();

const webgpu = @import("core.zig");

ptr: *anyopaque,
vtable: *const VTable,

pub const VTable = struct {};

pub inline fn init(
    pointer: anytype,
) RenderBundle {
    const Ptr = @TypeOf(pointer);
    const ptr_info = @typeInfo(Ptr);

    std.debug.assert(ptr_info == .Pointer);
    std.debug.assert(ptr_info.Pointer.size == .One);

    const alignment = ptr_info.Pointer.alignment;
    _ = alignment;

    const gen = struct {
        const vtable = VTable{};
    };

    return RenderBundle{
        .ptr = pointer,
        .vtable = &gen.vtable,
    };
}
