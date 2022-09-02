const std = @import("std");

const ComputePassEncoder = @This();

const webgpu = @import("core.zig");

ptr: *anyopaque,
vtable: *const VTable,

pub const VTable = struct {
    begin_pipeline_statistics_query: *const fn(*anyopaque, webgpu.QuerySet, u32) void,
    dispatch_workgroups: *const fn(*anyopaque, u32, u32, u32) void,
    dispatch_workgroups_indirect: *const fn(*anyopaque, webgpu.Buffer, usize) void,
    end: *const fn(*anyopaque) void,
    end_pipeline_statistics_query: *const fn(*anyopaque) void,
    insert_debug_marker: *const fn(*anyopaque, []const u8) void,
    pop_debug_group: *const fn(*anyopaque) void,
    push_debug_group: *const fn(*anyopaque, []const u8) void,
    set_bind_group: *const fn(*anyopaque, u32, webgpu.BindGroup, []const u32) void,
    set_label: *const fn(*anyopaque, ?[]const u8) void,
    set_pipeline: *const fn(*anyopaque, webgpu.ComputePipeline) void,
};

pub inline fn init(
    pointer: anytype,
    comptime begin_pipeline_statistics_query_fn: *const fn(@TypeOf(pointer), webgpu.QuerySet, u32) void,
    comptime dispatch_workgroups_fn: *const fn(@TypeOf(pointer), u32, u32, u32) void,
    comptime dispatch_workgroups_indirect_fn: *const fn(@TypeOf(pointer), webgpu.Buffer, usize) void,
    comptime end_fn: *const fn(@TypeOf(pointer)) void,
    comptime end_pipeline_statistics_query_fn: *const fn(@TypeOf(pointer)) void,
    comptime insert_debug_marker_fn: *const fn(@TypeOf(pointer), []const u8) void,
    comptime pop_debug_group_fn: *const fn(@TypeOf(pointer)) void,
    comptime push_debug_group_fn: *const fn(@TypeOf(pointer), []const u8) void,
    comptime set_bind_group_fn: *const fn(@TypeOf(pointer), u32, webgpu.BindGroup, []const u32) void,
    comptime set_label_fn: *const fn(@TypeOf(pointer), ?[]const u8) void,
    comptime set_pipeline_fn: *const fn(@TypeOf(pointer), webgpu.ComputePipeline) void,
)  ComputePassEncoder {
    const Ptr = @TypeOf(pointer);
    const ptr_info = @typeInfo(Ptr);

    std.debug.assert(ptr_info == .Pointer);
    std.debug.assert(ptr_info.Pointer.size == .One);

    const alignment = ptr_info.Pointer.alignment;

    const gen = struct {
        fn beginPipelineStatisticsQueryImpl(ptr: *anyopaque, query_set: webgpu.QuerySet, query_index: u32) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return begin_pipeline_statistics_query_fn(self, query_set, query_index);
        }

        fn dispatchWorkgroupsImpl(ptr: *anyopaque, workgroupCountX: u32, workgroupCountY: u32, workgroupCountZ: u32) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return dispatch_workgroups_fn(self, workgroupCountX, workgroupCountY, workgroupCountZ);
        }

        fn dispatchWorkgroupsIndirectImpl(ptr: *anyopaque, indirect_buffer: webgpu.Buffer, indirect_offset: usize) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return dispatch_workgroups_indirect_fn(self, indirect_buffer, indirect_offset);
        }

        fn endImpl(ptr: *anyopaque) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return end_fn(self);
        }

        fn endPipelineStatisticsQueryImpl(ptr: *anyopaque) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return end_pipeline_statistics_query_fn(self);
        }

        fn insertDebugMarkerImpl(ptr: *anyopaque, marker_label: []const u8) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return insert_debug_marker_fn(self, marker_label);
        }

        fn popDebugGroupImpl(ptr: *anyopaque) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return pop_debug_group_fn(self);
        }

        fn pushDebugGroupImpl(ptr: *anyopaque, group_label: []const u8) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return push_debug_group_fn(self, group_label);
        }

        fn setBindGroupImpl(ptr: *anyopaque, group_index: u32, bind_group: webgpu.BindGroup, dynamic_offsets: []const u32) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return set_bind_group_fn(self, group_index, bind_group, dynamic_offsets);
        }

        fn setLabelImpl(ptr: *anyopaque, label: ?[]const u8) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return set_label_fn(self, label);
        }

        fn setPipelineImpl(ptr: *anyopaque, pipeline: webgpu.ComputePipeline) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return set_pipeline_fn(self, pipeline);
        }

        const vtable = VTable{
            .begin_pipeline_statistics_query = beginPipelineStatisticsQueryImpl,
            .dispatch_workgroups = dispatchWorkgroupsImpl,
            .dispatch_workgroups_indirect = dispatchWorkgroupsIndirectImpl,
            .end = endImpl,
            .end_pipeline_statistics_query = endPipelineStatisticsQueryImpl,
            .insert_debug_marker = insertDebugMarkerImpl,
            .pop_debug_group = popDebugGroupImpl,
            .push_debug_group = pushDebugGroupImpl,
            .set_bind_group = setBindGroupImpl,
            .set_label = setLabelImpl,
            .set_pipeline = setPipelineImpl,
        };
    };

    return ComputePassEncoder{
        .ptr = pointer,
        .vtable = &gen.vtable,
    };
}

pub inline fn beginPipelineStatisticsQuery(compute_pass_encoder: ComputePassEncoder, query_set: webgpu.QuerySet, query_index: u32) void {
    return compute_pass_encoder.vtable.begin_pipeline_statistics_query(compute_pass_encoder.ptr, query_set, query_index);
}

pub inline fn dispatchWorkgroups(compute_pass_encoder: ComputePassEncoder, workgroupCountX: u32, workgroupCountY: u32, workgroupCountZ: u32) void {
    return compute_pass_encoder.vtable.dispatch_workgroups(compute_pass_encoder.ptr, workgroupCountX, workgroupCountY, workgroupCountZ);
}

pub inline fn dispatchWorkgroupsIndirect(compute_pass_encoder: ComputePassEncoder, indirect_buffer: webgpu.Buffer, indirect_offset: usize) void {
    return compute_pass_encoder.vtable.dispatch_workgroups_indirect(compute_pass_encoder.ptr, indirect_buffer, indirect_offset);
}

pub inline fn end(compute_pass_encoder: ComputePassEncoder) void {
    return compute_pass_encoder.vtable.end(compute_pass_encoder.ptr);
}

pub inline fn endPipelineStatisticsQuery(compute_pass_encoder: ComputePassEncoder) void {
    return compute_pass_encoder.vtable.end_pipeline_statistics_query(compute_pass_encoder.ptr);
}

pub inline fn insertDebugMarker(compute_pass_encoder: ComputePassEncoder, marker_label: []const u8) void {
    return compute_pass_encoder.vtable.insert_debug_marker(compute_pass_encoder.ptr, marker_label);
}

pub inline fn popDebugGroup(compute_pass_encoder: ComputePassEncoder) void {
    return compute_pass_encoder.vtable.pop_debug_group(compute_pass_encoder.ptr);
}

pub inline fn pushDebugGroup(compute_pass_encoder: ComputePassEncoder, group_label: []const u8) void {
    return compute_pass_encoder.vtable.push_debug_group(compute_pass_encoder.ptr, group_label);
}

pub inline fn setBindGroup(compute_pass_encoder: ComputePassEncoder, group_index: u32, bind_group: webgpu.BindGroup, dynamic_offsets: []const u32) void {
    return compute_pass_encoder.vtable.set_bind_group(compute_pass_encoder.ptr, group_index, bind_group, dynamic_offsets);
}

pub inline fn setLabel(compute_pass_encoder: ComputePassEncoder, label: ?[]const u8) void {
    return compute_pass_encoder.vtable.set_label(compute_pass_encoder.ptr, label);
}

pub inline fn setPipeline(compute_pass_encoder: ComputePassEncoder, pipeline: webgpu.ComputePipeline) void {
    return compute_pass_encoder.vtable.set_pipeline(compute_pass_encoder.ptr, pipeline);
}
