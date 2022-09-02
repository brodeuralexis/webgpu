const std = @import("std");

const ComputePipeline = @This();

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
) ComputePipeline {
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

    return ComputePipeline{
        .ptr = pointer,
        .vtable = &gen.vtable,
    };
}

pub inline fn getBindGroupLayout(compute_pipeline: ComputePipeline, group_index: u32) ?webgpu.BindGroupLayout {
    return compute_pipeline.vtable.get_bind_group_layout(compute_pipeline.ptr, group_index);
}

pub inline fn setLabel(compute_pipeline: ComputePipeline, label: ?[]const u8) void {
    return compute_pipeline.vtable.set_label(compute_pipeline.ptr, label);
}
