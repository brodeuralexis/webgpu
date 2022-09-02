const std = @import("std");

const Buffer = @This();

const webgpu = @import("core.zig");

ptr: *anyopaque,
vtable: *const VTable,

pub const VTable = struct {
    deinit: *const fn(*anyopaque) void,
    get_const_mapped_range: *const fn(*anyopaque, usize, ?usize) GetConstMappedRangeError![]const u8,
    get_mapped_range: *const fn(*anyopaque, usize, ?usize) GetMappedRangeError![]u8,
    map: *const fn(*anyopaque, webgpu.MapMode, usize, ?usize) webgpu.BufferMapAsyncError!void,
    set_label: *const fn(*anyopaque, ?[]const u8) void,
    unmap: *const fn(*anyopaque) void,
};

pub inline fn init(
    pointer: anytype,
    comptime deinit_fn: *const fn(@TypeOf(pointer)) void,
    comptime get_const_mapped_range_fn: *const fn(@TypeOf(pointer), usize, ?usize) GetConstMappedRangeError![]const u8,
    comptime get_mapped_range_fn: *const fn(@TypeOf(pointer), usize, ?usize) GetMappedRangeError![]u8,
    comptime map_fn: *const fn(@TypeOf(pointer), webgpu.MapMode, usize, ?usize) webgpu.BufferMapAsyncError!void,
    comptime set_label_fn: *const fn(@TypeOf(pointer), ?[]const u8) void,
    comptime unmap_fn: *const fn(@TypeOf(pointer)) void,
) Buffer {
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

        fn getConstMappedRangeImpl(ptr: *anyopaque, offset: usize, size: ?usize) GetConstMappedRangeError![]const u8 {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return get_const_mapped_range_fn(self, offset, size);
        }

        fn getMappedRangeImpl(ptr: *anyopaque, offset: usize, size: ?usize) GetMappedRangeError![]u8 {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return get_mapped_range_fn(self, offset, size);
        }

        fn mapImpl(ptr: *anyopaque, mode: webgpu.MapMode, offset: usize, size: ?usize) webgpu.BufferMapAsyncError!void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return map_fn(self, mode, offset, size);
        }

        fn setLabelImpl(ptr: *anyopaque, label: ?[]const u8) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return set_label_fn(self, label);
        }

        fn unmapImpl(ptr: *anyopaque) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return unmap_fn(self);
        }

        const vtable = VTable{
            .deinit = deinitImpl,
            .get_const_mapped_range = getConstMappedRangeImpl,
            .get_mapped_range = getMappedRangeImpl,
            .map = mapImpl,
            .set_label = setLabelImpl,
            .unmap = unmapImpl,
        };
    };

    return Buffer{
        .ptr = pointer,
        .vtable = &gen.vtable,
    };
}

pub inline fn deinit(buffer: Buffer) void {
    buffer.vtable.deinit(buffer.ptr);
}

pub const GetConstMappedRangeError = error {};

pub inline fn getConstMappedRange(buffer: Buffer, offset: usize, size: ?usize) GetConstMappedRangeError![]const u8 {
    return buffer.vtable.get_const_mapped_range(buffer.ptr, offset, size);
}

pub const GetMappedRangeError = error {};

pub inline fn getMappedRange(buffer: Buffer, offset: usize, size: ?usize) GetMappedRangeError![]u8 {
    return buffer.vtable.get_mapped_range(buffer.ptr, offset, size);
}

pub inline fn map(buffer: Buffer, offset: usize, size: ?usize) webgpu.BufferMapAsyncError!void {
    return buffer.vtable.map(buffer.ptr, offset, size);
}

pub inline fn setLabel(buffer: Buffer, label: ?[]const u8) void {
    return buffer.vtable.set_label(buffer.ptr, label);
}

pub inline fn unmap(buffer: Buffer) void {
    return buffer.vtable.unmap(buffer.ptr);
}
