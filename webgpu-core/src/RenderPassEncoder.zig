const std = @import("std");

const RenderPassEncoder = @This();

const webgpu = @import("core.zig");

ptr: *anyopaque,
vtable: *const VTable,

pub const VTable = struct {
    begin_occlusion_query: *const fn(*anyopaque, u32) void,
    begin_pipeline_statistics_query: *const fn(*anyopaque, webgpu.QuerySet, u32) void,
    draw: *const fn(*anyopaque, u32, u32, u32, u32) void,
    draw_indexed: *const fn(*anyopaque, u32, u32, u32, u32, u32) void,
    draw_indirect_indexed: *const fn(*anyopaque, webgpu.Buffer, usize) void,
    draw_indirect: *const fn(*anyopaque, webgpu.Buffer, usize) void,
    end: *const fn(*anyopaque) void,
    end_occlusion_query: *const fn(*anyopaque) void,
    end_pipeline_statistics_query: *const fn(*anyopaque) void,
    execute_bundles: *const fn(*anyopaque, []const webgpu.RenderBundle) void,
    insert_debug_marker: *const fn(*anyopaque, []const u8) void,
    pop_debug_group: *const fn(*anyopaque) void,
    push_debug_group: *const fn(*anyopaque, []const u8) void,
    set_bind_group: *const fn(*anyopaque, u32, webgpu.BindGroup, []const u32) void,
    set_blend_constant: *const fn(*anyopaque, webgpu.Color) void,
    set_index_buffer: *const fn(*anyopaque, webgpu.Buffer, webgpu.IndexFormat, usize, usize) void,
    set_label: *const fn(*anyopaque, ?[]const u8) void,
    set_pipeline: *const fn(*anyopaque, webgpu.RenderPipeline) void,
    set_scissor_rect: *const fn(*anyopaque, u32, u32, u32, u32) void,
    set_stencil_reference: *const fn(*anyopaque, u32) void,
    set_vertex_buffer: *const fn(*anyopaque, u32, webgpu.Buffer, usize, usize) void,
    set_viewport: *const fn(*anyopaque, f32, f32, f32, f32, f32, f32) void,
};

pub inline fn init(
    pointer: anytype,
    comptime begin_occlusion_query_fn: *const fn(@TypeOf(pointer), u32) void,
    comptime begin_pipeline_statistics_query_fn: *const fn(@TypeOf(pointer), webgpu.QuerySet, u32) void,
    comptime draw_fn: *const fn(@TypeOf(pointer), u32, u32, u32, u32) void,
    comptime draw_indexed_fn: *const fn(@TypeOf(pointer), u32, u32, u32, u32, u32) void,
    comptime draw_indirect_indexed_fn: *const fn(@TypeOf(pointer), webgpu.Buffer, usize) void,
    comptime draw_indirect_fn: *const fn(@TypeOf(pointer), webgpu.Buffer, usize) void,
    comptime end_fn: *const fn(@TypeOf(pointer)) void,
    comptime end_occlusion_query_fn: *const fn(@TypeOf(pointer)) void,
    comptime end_pipeline_statistics_query_fn: *const fn(@TypeOf(pointer)) void,
    comptime execute_bundles_fn: *const fn(@TypeOf(pointer), []const webgpu.RenderBundle) void,
    comptime insert_debug_marker_fn: *const fn(@TypeOf(pointer), []const u8) void,
    comptime pop_debug_group_fn: *const fn(@TypeOf(pointer)) void,
    comptime push_debug_group_fn: *const fn(@TypeOf(pointer), []const u8) void,
    comptime set_bind_group_fn: *const fn(@TypeOf(pointer), u32, webgpu.BindGroup, []const u32) void,
    comptime set_blend_constant_fn: *const fn(@TypeOf(pointer), webgpu.Color) void,
    comptime set_index_buffer_fn: *const fn(@TypeOf(pointer), webgpu.Buffer, webgpu.IndexFormat, usize, usize) void,
    comptime set_label_fn: *const fn(@TypeOf(pointer), ?[]const u8) void,
    comptime set_pipeline_fn: *const fn(@TypeOf(pointer), webgpu.RenderPipeline) void,
    comptime set_scissor_rect_fn: *const fn(@TypeOf(pointer), u32, u32, u32, u32) void,
    comptime set_stencil_reference_fn: *const fn(@TypeOf(pointer), u32) void,
    comptime set_vertex_buffer_fn: *const fn(@TypeOf(pointer), u32, webgpu.Buffer, usize, usize) void,
    comptime set_viewport_fn: *const fn(@TypeOf(pointer), f32, f32, f32, f32, f32, f32) void,
) RenderPassEncoder {
    const Ptr = @TypeOf(pointer);
    const ptr_info = @typeInfo(Ptr);

    std.debug.assert(ptr_info == .Pointer);
    std.debug.assert(ptr_info.Pointer.size == .One);

    const alignment = ptr_info.Pointer.alignment;

    const gen = struct {
        fn beginOcclusionQueryImpl(ptr: *anyopaque, query_index: u32) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return begin_occlusion_query_fn(self, query_index);
        }

        fn beginPipelineStatisticsQueryImpl(ptr: *anyopaque, query_set: webgpu.QuerySet, query_index: u32) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return begin_pipeline_statistics_query_fn(self, query_set, query_index);
        }

        fn drawImpl(ptr: *anyopaque, vertex_count: u32, instance_count: u32, first_vertex: u32, first_instance: u32) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return draw_fn(self, vertex_count, instance_count, first_vertex, first_instance);
        }

        fn drawIndexedImpl(ptr: *anyopaque, index_count: u32, instance_count: u32, first_index: u32, base_vertex: u32, first_instance: u32) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return draw_indexed_fn(self, index_count, instance_count, first_index, base_vertex, first_instance);
        }

        fn drawIndirectIndexedImpl(ptr: *anyopaque, indirect_buffer: webgpu.Buffer, indirect_offset: usize) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return draw_indirect_indexed_fn(self, indirect_buffer, indirect_offset);
        }

        fn drawIndirectImpl(ptr: *anyopaque, indirect_buffer: webgpu.Buffer, indirect_offset: usize) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return draw_indirect_fn(self, indirect_buffer, indirect_offset);
        }

        fn endImpl(ptr: *anyopaque) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return end_fn(self);
        }

        fn endOcclusionQueryImpl(ptr: *anyopaque) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return end_occlusion_query_fn(self);
        }

        fn endPipelineStatisticsQueryImpl(ptr: *anyopaque) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return end_pipeline_statistics_query_fn(self);
        }

        fn executeBundlesImpl(ptr: *anyopaque, bundles: []const webgpu.RenderBundle) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return execute_bundles_fn(self, bundles);
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

        fn setBlendConstantImpl(ptr: *anyopaque, color: webgpu.Color) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return set_blend_constant_fn(self, color);
        }

        fn setIndexBufferImpl(ptr: *anyopaque, buffer: webgpu.Buffer, format: webgpu.IndexFormat, offset: usize, size: usize) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return set_index_buffer_fn(self, buffer, format, offset, size);
        }

        fn setLabelImpl(ptr: *anyopaque, label: ?[]const u8) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return set_label_fn(self, label);
        }

        fn setPipelineImpl(ptr: *anyopaque, pipeline: webgpu.RenderPipeline) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return set_pipeline_fn(self, pipeline);
        }

        fn setScissorRectImpl(ptr: *anyopaque, x: u32, y: u32, width: u32, height: u32) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return set_scissor_rect_fn(self, x, y, width, height);
        }

        fn setStencilReferenceImpl(ptr: *anyopaque, reference: u32) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return set_stencil_reference_fn(self, reference);
        }

        fn setVertexBufferImpl(ptr: *anyopaque, slot: u32, buffer: webgpu.Buffer, offset: usize, size: usize) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return set_vertex_buffer_fn(self, slot, buffer, offset, size);
        }

        fn setViewportImpl(ptr: *anyopaque, x: f32, y: f32, width: f32, height: f32, min_depth: f32, max_depth: f32) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return set_viewport_fn(self, x, y, width, height, min_depth, max_depth);
        }

        const vtable = VTable{
            .begin_occlusion_query = beginOcclusionQueryImpl,
            .begin_pipeline_statistics_query = beginPipelineStatisticsQueryImpl,
            .draw = drawImpl,
            .draw_indexed = drawIndexedImpl,
            .draw_indirect_indexed = drawIndirectIndexedImpl,
            .draw_indirect = drawIndirectImpl,
            .end = endImpl,
            .end_occlusion_query = endOcclusionQueryImpl,
            .end_pipeline_statistics_query = endPipelineStatisticsQueryImpl,
            .execute_bundles = executeBundlesImpl,
            .insert_debug_marker = insertDebugMarkerImpl,
            .pop_debug_group = popDebugGroupImpl,
            .push_debug_group = pushDebugGroupImpl,
            .set_bind_group = setBindGroupImpl,
            .set_blend_constant = setBlendConstantImpl,
            .set_index_buffer = setIndexBufferImpl,
            .set_label = setLabelImpl,
            .set_pipeline = setPipelineImpl,
            .set_scissor_rect = setScissorRectImpl,
            .set_stencil_reference = setStencilReferenceImpl,
            .set_vertex_buffer = setVertexBufferImpl,
            .set_viewport = setViewportImpl,
        };
    };

    return RenderPassEncoder{
        .ptr = pointer,
        .vtable = &gen.vtable,
    };
}

pub inline fn beginOcclusionQuery(render_pass_encoder: RenderPassEncoder, query_index: u32) void {
    return render_pass_encoder.vtable.begin_occlusion_query(render_pass_encoder.ptr, query_index);
}

pub inline fn beginPipelineStatisticsQuery(render_pass_encoder: RenderPassEncoder, query_set: webgpu.QuerySet, query_index: u32) void {
    return render_pass_encoder.vtable.begin_pipeline_statistics_query(render_pass_encoder.ptr, query_set, query_index);
}

pub inline fn draw(render_pass_encoder: RenderPassEncoder, vertex_count: u32, instance_count: u32, first_vertex: u32, first_instance: u32) void {
    return render_pass_encoder.vtable.draw(render_pass_encoder.ptr, vertex_count, instance_count, first_vertex, first_instance);
}

pub inline fn drawIndexed(render_pass_encoder: RenderPassEncoder, index_count: u32, instance_count: u32, first_index: u32, base_vertex: u32, first_instance: u32) void {
    return render_pass_encoder.vtable.draw_indexed(render_pass_encoder.ptr, index_count, instance_count, first_index, base_vertex, first_instance);
}

pub inline fn drawIndirectIndexed(render_pass_encoder: RenderPassEncoder, indirect_buffer: webgpu.Buffer, indirect_offset: usize) void {
    return render_pass_encoder.vtable.draw_indirect_indexed(render_pass_encoder.ptr, indirect_buffer, indirect_offset);
}

pub inline fn drawIndirect(render_pass_encoder: RenderPassEncoder, indirect_buffer: webgpu.Buffer, indirect_offset: usize) void {
    return render_pass_encoder.vtable.draw_indirect(render_pass_encoder.ptr, indirect_buffer, indirect_offset);
}

pub inline fn end(render_pass_encoder: RenderPassEncoder) void {
    return render_pass_encoder.vtable.end(render_pass_encoder.ptr);
}

pub inline fn endOcclusionQuery(render_pass_encoder: RenderPassEncoder) void {
    return render_pass_encoder.vtable.end_occlusion_query(render_pass_encoder.ptr);
}

pub inline fn endPipelineStatisticsQuery(render_pass_encoder: RenderPassEncoder) void {
    return render_pass_encoder.vtable.end_pipeline_statistics_query(render_pass_encoder.ptr);
}

pub inline fn executeBundles(render_pass_encoder: RenderPassEncoder, bundles: []const webgpu.RenderBundle) void {
    return render_pass_encoder.vtable.execute_bundles(render_pass_encoder.ptr, bundles);
}

pub inline fn insertDebugMarker(render_pass_encoder: RenderPassEncoder, marker_label: []const u8) void {
    return render_pass_encoder.vtable.insert_debug_marker(render_pass_encoder.ptr, marker_label);
}

pub inline fn popDebugGroup(render_pass_encoder: RenderPassEncoder) void {
    return render_pass_encoder.vtable.pop_debug_group(render_pass_encoder.ptr);
}

pub inline fn pushDebugGroup(render_pass_encoder: RenderPassEncoder, group_label: []const u8) void {
    return render_pass_encoder.vtable.push_debug_group(render_pass_encoder.ptr, group_label);
}

pub inline fn setBindGroup(render_pass_encoder: RenderPassEncoder, group_index: u32, bind_group: webgpu.BindGroup, dynamic_offsets: []const u32) void {
    return render_pass_encoder.vtable.set_bind_group(render_pass_encoder.ptr, group_index, bind_group, dynamic_offsets);
}

pub inline fn setBlendConstant(render_pass_encoder: RenderPassEncoder, color: webgpu.Color) void {
    return render_pass_encoder.vtable.set_blend_constant(render_pass_encoder.ptr, color);
}

pub inline fn setIndexBuffer(render_pass_encoder: RenderPassEncoder, buffer: webgpu.Buffer, format: webgpu.IndexFormat, offset: usize, size: usize) void {
    return render_pass_encoder.vtable.set_index_buffer(render_pass_encoder.ptr, buffer, format, offset, size);
}

pub inline fn setLabel(render_pass_encoder: RenderPassEncoder, label: ?[]const u8) void {
    return render_pass_encoder.vtable.set_label(render_pass_encoder.ptr, label);
}

pub inline fn setPipeline(render_pass_encoder: RenderPassEncoder, pipeline: webgpu.RenderPipeline) void {
    return render_pass_encoder.vtable.set_pipeline(render_pass_encoder.ptr, pipeline);
}

pub inline fn setScissorRect(render_pass_encoder: RenderPassEncoder, x: u32, y: u32, width: u32, height: u32) void {
    return render_pass_encoder.vtable.set_scissor_rect(render_pass_encoder.ptr, x, y, width, height);
}

pub inline fn setStencilReference(render_pass_encoder: RenderPassEncoder, reference: u32) void {
    return render_pass_encoder.vtable.set_stencil_reference(render_pass_encoder.ptr, reference);
}

pub inline fn setVertexBuffer(render_pass_encoder: RenderPassEncoder, slot: u32, buffer: webgpu.Buffer, offset: usize, size: usize) void {
    return render_pass_encoder.vtable.set_vertex_buffer(render_pass_encoder.ptr, slot, buffer, offset, size);
}

pub inline fn setViewport(render_pass_encoder: RenderPassEncoder, x: f32, y: f32, width: f32, height: f32, min_depth: f32, max_depth: f32) void {
    return render_pass_encoder.vtable.set_viewport(render_pass_encoder.ptr, x, y, width, height, min_depth, max_depth);
}
