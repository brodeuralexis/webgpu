const std = @import("std");

const SwapChain = @This();

const webgpu = @import("core.zig");

ptr: *anyopaque,
vtable: *const VTable,

pub const VTable = struct {
    get_current_texture_view: *const fn(*anyopaque) webgpu.TextureView,
    present: *const fn(*anyopaque) void,
};

pub inline fn init(
    pointer: anytype,
    comptime get_current_texture_view_fn: *const fn(@TypeOf(pointer)) webgpu.TextureView,
    comptime present_fn: *const fn(@TypeOf(pointer)) void,
) SwapChain {
    const Ptr = @TypeOf(pointer);
    const ptr_info = @typeInfo(Ptr);

    std.debug.assert(ptr_info == .Pointer);
    std.debug.assert(ptr_info.Pointer.size == .One);

    const alignment = ptr_info.Pointer.alignment;

    const gen = struct {
        fn getCurrentTextureViewImpl(ptr: *anyopaque) webgpu.TextureView {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return get_current_texture_view_fn(self);
        }

        fn presentImpl(ptr: *anyopaque) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return present_fn(self);
        }

        const vtable = VTable{
            .get_current_texture_view = getCurrentTextureViewImpl,
            .present = presentImpl,
        };
    };

    return SwapChain{
        .ptr = pointer,
        .vtable = &gen.vtable,
    };
}

pub inline fn getCurrentTextureView(swap_chain: SwapChain) webgpu.TextureView {
    return swap_chain.vtable.get_current_texture_view(swap_chain.ptr);
}

pub inline fn present(swap_chain: SwapChain) void {
    return swap_chain.vtable.present(swap_chain.ptr);
}
