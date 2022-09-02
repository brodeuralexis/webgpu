const std = @import("std");

const RenderPipeline = @This();

const webgpu = @import("core.zig");

ptr: *anyopaque,
vtable: *const VTable,

pub const VTable = struct {
    get_bind_group_layout: *const fn(*anyopaque, u32) ?webgpu.BindGroupLayout,
    set_label: *const fn(*anyopaque, ?[]const u8) void,
};

pub inline fn init(
    pointer: anytype,
    comptime get_bind_group_layout_fn: *const fn(@TypeOf(pointer), u32) ?webgpu.BindGroupLayout,
    comptime set_label_fn: *const fn(@TypeOf(pointer), ?[]const u8) void,
) RenderPipeline {
    const Ptr = @TypeOf(pointer);
    const ptr_info = @typeInfo(Ptr);

    std.debug.assert(ptr_info == .Pointer);
    std.debug.assert(ptr_info.Pointer.size == .One);

    const alignment = ptr_info.Pointer.alignment;

    const gen = struct {
        fn getBindGroupLayoutImpl(ptr: *anyopaque, group_index: u32) ?webgpu.BindGroupLayout {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return get_bind_group_layout_fn(self, group_index);
        }

        fn setLabelImpl(ptr: *anyopaque, label: ?[]const u8) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return set_label_fn(self, label);
        }

        const vtable = VTable{
            .get_bind_group_layout = getBindGroupLayoutImpl,
            .set_label = setLabelImpl,
        };
    };

    return RenderPipeline{
        .ptr = pointer,
        .vtable = &gen.vtable,
    };
}

pub inline fn getBindGroupLayout(render_pipeline: RenderPipeline, group_index: u32) ?webgpu.BindGroupLayout {
    return render_pipeline.vtable.get_bind_group_layout(render_pipeline.ptr, group_index);
}

pub inline fn setLabel(render_pipeline: RenderPipeline, label: ?[]const u8) void {
    return render_pipeline.vtable.set_label(render_pipeline.ptr, label);
}
