const std = @import("std");

const Surface = @This();

const webgpu = @import("core.zig");

ptr: *anyopaque,
vtable: *const VTable,

pub const VTable = struct {
    get_preferred_format: *const fn(*anyopaque) webgpu.TextureFormat,
};

pub inline fn init(
    pointer: anytype,
    comptime get_preferred_format_fn: *const fn(@TypeOf(pointer)) webgpu.TextureFormat,
) Surface {
    const Ptr = @TypeOf(pointer);
    const ptr_info = @typeInfo(Ptr);

    std.debug.assert(ptr_info == .Pointer);
    std.debug.assert(ptr_info.Pointer.size == .One);

    const alignment = ptr_info.Pointer.alignment;

    const gen = struct {
        fn getPreferredFormatImpl(ptr: *anyopaque) webgpu.TextureFormat {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return get_preferred_format_fn(self);
        }

        const vtable = VTable{
            .get_preferred_format = getPreferredFormatImpl,
        };
    };

    return Surface{
        .ptr = pointer,
        .vtable = &gen.vtable,
    };
}

pub inline fn getPreferredFormat(surface: Surface) webgpu.TextureFormat {
    return surface.vtable.get_preferred_format(surface.ptr);
}
