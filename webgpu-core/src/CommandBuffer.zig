const std = @import("std");

const CommandBuffer = @This();

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
) CommandBuffer {
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

    return CommandBuffer{
        .ptr = pointer,
        .vtable = &gen.vtable,
    };
}

pub inline fn deinit(command_buffer: CommandBuffer) void {
    command_buffer.vtable.deinit(command_buffer.ptr);
}

pub inline fn setLabel(command_buffer: CommandBuffer, label: ?[]const u8) void {
    command_buffer.vtable.set_label(command_buffer.ptr, label);
}
