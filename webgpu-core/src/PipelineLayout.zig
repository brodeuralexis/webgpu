const std = @import("std");

const PipelineLayout = @This();

const webgpu = @import("core.zig");

ptr: *anyopaque,
vtable: *const VTable,

pub const VTable = struct {
    set_label: *const fn(*anyopaque, ?[]const u8) void,
};

pub inline fn init(
    pointer: anytype,
    comptime set_label_fn: *const fn(@TypeOf(pointer), ?[]const u8) void,
) PipelineLayout {
    const Ptr = @TypeOf(pointer);
    const ptr_info = @typeInfo(Ptr);

    std.debug.assert(ptr_info == .Pointer);
    std.debug.assert(ptr_info.Pointer.size == .One);

    const alignment = ptr_info.Pointer.alignment;

    const gen = struct {
        fn setLabelImpl(ptr: *anyopaque, label: ?[]const u8) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return set_label_fn(self, label);
        }

        const vtable = VTable{
            .set_label = setLabelImpl,
        };
    };

    return PipelineLayout{
        .ptr = pointer,
        .vtable = &gen.vtable,
    };
}

pub inline fn setLabel(pipeline_layout: PipelineLayout, label: ?[]const u8) void {
    return pipeline_layout.vtable.set_label(pipeline_layout.ptr, label);
}
