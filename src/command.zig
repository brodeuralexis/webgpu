const std = @import("std");
const webgpu = @import("./webgpu.zig");

pub const CommandBuffer = struct {
    pub const VTable = struct {
        destroy_fn: fn(*CommandBuffer) void,
    };

    __vtable: *const VTable,

    device: *webgpu.Device,

    pub inline fn destroy(command_buffer: *CommandBuffer) void {
        command_buffer.__vtable.destroy_fn(command_buffer);
    }
};

pub const CommandEncoder = struct {
    pub const VTable = struct {
        destroy_fn: fn(*CommandEncoder) void,
        begin_compute_pass_fn: fn(*CommandEncoder, webgpu.ComputePassDescriptor) BeginComputePassError!*ComputePassEncoder,
        begin_render_pass_fn: fn(*CommandEncoder, webgpu.RenderPassDescriptor) BeginRenderPassError!*RenderPassEncoder,
        clear_buffer_fn: fn(*CommandEncoder, *webgpu.Buffer, usize, usize) ClearBufferError!void,
        copy_buffer_to_buffer_fn: fn(*CommandEncoder, *webgpu.Buffer, usize, *webgpu.Buffer, usize, usize) CopyBufferToBufferError!void,
        copy_buffer_to_texture_fn: fn(*CommandEncoder, webgpu.ImageCopyBuffer, webgpu.ImageCopyTexture, webgpu.Extend3D) CopyBufferToTextureError!void,
        copy_texture_to_buffer_fn: fn(*CommandEncoder, webgpu.ImageCopyTexture, webgpu.ImageCopyBuffer, webgpu.Extend3D) CopyTextureToBufferError!void,
        copy_texture_to_texture_fn: fn(*CommandEncoder, webgpu.ImageCopyTexture, webgpu.ImageCopyTexture, webgpu.Extend3D) CopyTextureToTextureError!void,
        finish_fn: fn(*CommandEncoder, webgpu.CommandBufferDescriptor) FinishError!*CommandBuffer,
        insert_debug_marker_fn: fn(*CommandEncoder, [:0]const u8) void,
        pop_debug_group_fn: fn(*CommandEncoder) void,
        push_debug_group_fn: fn(*CommandEncoder, [:0]const u8) void,
        resolve_query_set_fn: fn(*CommandEncoder, *webgpu.QuerySet, u32, u32, *webgpu.Buffer, u64) ResolveQuerySetError!void,
        write_timestamp_fn: fn(*CommandEncoder, *webgpu.QuerySet, u32) WriteTimestampError!void,
    };

    __vtable: *const VTable,

    device: *webgpu.Device,

    pub inline fn destroy(command_encoder: *CommandEncoder) void {
        command_encoder.__vtable.destroy_fn(command_encoder);
    }

    pub const BeginComputePassError = error {
        OutOfMemory,
        Failed,
    };

    pub inline fn beginComputePass(command_encoder: *CommandEncoder, descriptor: webgpu.ComputePassDescriptor) BeginComputePassError!*ComputePassEncoder {
        return command_encoder.__vtable.begin_compute_pass_fn(command_encoder, descriptor);
    }

    pub const BeginRenderPassError = error {
        OutOfMemory,
        Failed,
    };

    pub inline fn beginRenderPass(command_encoder: *CommandEncoder, descriptor: webgpu.RenderPassDescriptor) BeginRenderPassError!*RenderPassEncoder {
        return command_encoder.__vtable.begin_render_pass_fn(command_encoder, descriptor);
    }

    pub const ClearBufferError = error {
        Failed,
    };

    pub inline fn clearBuffer(command_encoder: *CommandEncoder, buffer: *webgpu.Buffer, offset: usize, size: usize) ClearBufferError!void {
        return command_encoder.__vtable.clear_buffer_fn(command_encoder, buffer, offset, size);
    }

    pub const CopyBufferToBufferError = error {
        Failed,
    };

    pub inline fn copyBufferToBuffer(command_encoder: *CommandEncoder, source: *webgpu.Buffer, source_offset: usize, destination: *webgpu.Buffer, destination_offset: usize, size: usize) CopyBufferToBufferError!void {
        return command_encoder.__vtable.copy_buffer_to_buffer_fn(command_encoder, source, source_offset, destination, destination_offset, size);
    }

    pub const CopyBufferToTextureError = error {
        Failed,
    };

    pub inline fn copyBufferToTexture(command_encoder: *CommandEncoder, source: webgpu.ImageCopyBuffer, destination: webgpu.ImageCopyTexture, copy_size: webgpu.Extend3D) CopyBufferToTextureError!void {
        return command_encoder.__vtable.copy_buffer_to_texture_fn(command_encoder, source, destination, copy_size);
    }

    pub const CopyTextureToBufferError = error {
        Failed,
    };

    pub inline fn copyTextureToBuffer(command_encoder: *CommandEncoder, source: webgpu.ImageCopyTexture, destination: webgpu.ImageCopyBuffer, copy_size: webgpu.Extend3D) CopyTextureToBufferError!void {
        return command_encoder.__vtable.copy_texture_to_buffer_fn(command_encoder, source, destination, copy_size);
    }

    pub const CopyTextureToTextureError = error {
        Failed,
    };

    pub inline fn copyTextureToTexture(command_encoder: *CommandEncoder, source: webgpu.ImageCopyTexture, destination: webgpu.ImageCopyTexture, copy_size: webgpu.Extend3D) CopyTextureToTextureError!void {
        return command_encoder.__vtable.copy_texture_to_texture_fn(command_encoder, source, destination, copy_size);
    }

    pub const FinishError = error {
        OutOfMemory,
        Failed,
    };

    pub inline fn finish(command_encoder: *CommandEncoder) FinishError!CommandBuffer {
        return command_encoder.__vtable.finish_fn(command_encoder);
    }

    pub inline fn insertDebugMarker(command_encoder: *CommandEncoder, marker_label: [:0]const u8) void {
        command_encoder.__vtable.insert_debug_marker_fn(command_encoder, marker_label);
    }

    pub inline fn popDebugGroup(command_encoder: *CommandEncoder) void {
        command_encoder.__vtable.pop_debug_group_fn(command_encoder);
    }

    pub inline fn pushDebugGroup(command_encoder: *CommandEncoder, group_label: [:0]const u8) void {
        command_encoder.__vtable.push_debug_group_fn(command_encoder, group_label);
    }

    pub const ResolveQuerySetError = error {
        Failed,
    };

    pub inline fn resolveQuerySet(command_encoder: *CommandEncoder, query_set: *webgpu.QuerySet, first_query: u32, query_count: u32, destination: *webgpu.Buffer, destination_offset: u64) ResolveQuerySetError!void {
        return command_encoder.__vtable.resolve_query_set_fn(command_encoder, query_set, first_query, query_count, destination, destination_offset);
    }

    pub const WriteTimestampError = error {
        Failed,
    };

    pub inline fn writeTimestamp(command_encoder: *CommandEncoder, query_set: *webgpu.QuerySet, query_index: u32) WriteTimestampError!void {
        return command_encoder.__vtable.write_timestamp_fn(command_encoder, query_set, query_index);
    }
};

pub const ComputePassEncoder = struct {
    pub const VTable = struct {
        destroy_fn: fn(*ComputePassEncoder) void,
        begin_pipeline_statistics_query_fn: fn(*ComputePassEncoder, *webgpu.QuerySet, u32) BeginPipelineStatisticsQueryError!void,
        dispatch_fn: fn(*ComputePassEncoder, u32, u32, u32) DispatchError!void,
        dispatch_indirect_fn: fn(*ComputePassEncoder, *webgpu.Buffer, u64) DispatchIndirectError!void,
        end_pass_fn: fn(*ComputePassEncoder) EndPassError!void,
        end_pipeline_statistics_query_fn: fn(*ComputePassEncoder) EndPipelineStatisticsQueryError!void,
        insert_debug_marker_fn: fn(*ComputePassEncoder, [:0]const u8) void,
        pop_debug_group_fn: fn(*ComputePassEncoder) void,
        push_debug_group_fn: fn(*ComputePassEncoder, [:0]const u8) void,
        set_bind_group_fn: fn(*ComputePassEncoder, u32, *webgpu.BindGroup, []const u32) SetBindGroupError!void,
        set_pipeline_fn: fn(*ComputePassEncoder, *webgpu.ComputePipeline) SetPipelineError!void,
    };

    __vtable: *const VTable,

    device: *webgpu.Device,

    pub inline fn destroy(compute_pass_encoder: *ComputePassEncoder) void {
        compute_pass_encoder.__vtable.destroy_fn(compute_pass_encoder);
    }

    pub const BeginPipelineStatisticsQueryError = error {
        Failed,
    };

    pub inline fn beginPipelineStatisticsQuery(compute_pass_encoder: *ComputePassEncoder, query_set: *webgpu.QuerySet, query_index: u32) BeginPipelineStatisticsQueryError!void {
        return compute_pass_encoder.__vtable.begin_pipeline_statistics_query_fn(compute_pass_encoder, query_set, query_index);
    }

    pub const DispatchError = error {
        Failed,
    };

    pub inline fn dispatch(compute_pass_encoder: *ComputePassEncoder, x: u32, y: u32, z: u32) DispatchError!void {
        return compute_pass_encoder.__vtable.dispatch_fn(compute_pass_encoder, x, y, z);
    }

    pub const DispatchIndirectError = error {
        Failed,
    };

    pub inline fn dispatchIndirect(compute_pass_encoder: *ComputePassEncoder, indirect_buffer: *webgpu.Buffer, indirect_offset: u64) DispatchIndirectError!void {
        return compute_pass_encoder.__vtable.dispatch_indirect_fn(compute_pass_encoder, indirect_buffer, indirect_offset);
    }

    pub const EndPassError = error {
        Failed
    };

    pub inline fn endPass(compute_pass_encoder: *ComputePassEncoder) EndPassError!void {
        return compute_pass_encoder.__vtable.end_pass_fn(compute_pass_encoder);
    }

    pub const EndPipelineStatisticsQueryError = error {
        Failed,
    };

    pub inline fn endPipelineStatisticsQuery(compute_pass_encoder: *ComputePassEncoder) EndPipelineStatisticsQueryError!void {
        return compute_pass_encoder.__vtable.end_pipeline_statistics_query_fn(compute_pass_encoder);
    }

    pub inline fn insertDebugMarker(compute_pass_encoder: *ComputePassEncoder, marker_label: [:0]const u8) void {
        compute_pass_encoder.__vtable.insert_debug_marker_fn(compute_pass_encoder, marker_label);
    }

    pub inline fn popDebugGroup(compute_pass_encoder: *ComputePassEncoder) void {
        compute_pass_encoder.__vtable.pop_debug_group_fn(compute_pass_encoder);
    }

    pub inline fn pushDebugGroup(compute_pass_encoder: *ComputePassEncoder, group_label: [:0]const u8) void {
        compute_pass_encoder.__vtable.push_debug_group_fn(compute_pass_encoder, group_label);
    }

    pub const SetBindGroupError = error {
        Failed,
    };

    pub inline fn setBindGroup(compute_pass_encoder: *ComputePassEncoder, group_index: u32, group: *webgpu.BindGroup, dynamic_offets: []const u32) SetBindGroupError!void {
        return compute_pass_encoder.__vtable.set_bind_group_fn(compute_pass_encoder, group_index, group, dynamic_offets);
    }

    pub const SetPipelineError = error {
        Failed,
    };

    pub inline fn setPipeline(compute_pass_encoder: *ComputePassEncoder, pipeline: *webgpu.ComputePipeline) SetPipelineError!void {
        compute_pass_encoder.__vtable.set_pipeline_fn(compute_pass_encoder, pipeline);
    }
};

pub const RenderBundle = struct {
    pub const VTable = struct {
        destroy_fn: fn(*RenderBundle) void,
    };

    __vtable: *const VTable,

    device: *webgpu.Device,

    pub inline fn destroy(render_bundle: *RenderBundle) void {
        render_bundle.__vtable.destroy_fn(render_bundle);
    }
};

pub const RenderBundleEncoder = struct {
    pub const VTable = struct {
        destroy_fn: fn(*RenderBundleEncoder) void,
        draw_fn: fn(*RenderBundleEncoder, u32, u32, u32, u32) void,
        draw_indexed_fn: fn(*RenderBundleEncoder, u32, u32, u32, u32, u32) void,
        draw_indexed_indirect_fn: fn(*RenderBundleEncoder, *webgpu.Buffer, u64) void,
        draw_indirect_fn: fn(*RenderBundleEncoder, *webgpu.Buffer, u64) void,
        finish_fn: fn(*RenderBundleEncoder) FinishError!*RenderBundle,
        insert_debug_marker_fn: fn(*RenderBundleEncoder, [:0]const u8) void,
        pop_debug_group_fn: fn(*RenderBundleEncoder) void,
        push_debug_group_fn: fn(*RenderBundleEncoder, [:0]const u8) void,
        set_bind_group_fn: fn(*RenderBundleEncoder, u32, *webgpu.BindGroup, []const u32) void,
        set_index_buffer_fn: fn(*RenderBundleEncoder, *webgpu.Buffer, webgpu.IndexFormat, u64, u64) void,
        set_pipeline_fn: fn(*RenderBundleEncoder, *webgpu.RenderPipeline) void,
        set_vertex_buffer_fn: fn(*RenderBundleEncoder, u32, *webgpu.Buffer, u64, u64) void,
    };

    __vtable: *const VTable,

    device: *webgpu.Device,

    pub inline fn destroy(render_bundle_encoder: *RenderBundleEncoder) void {
        return render_bundle_encoder.__vtable.destroy_fn(render_bundle_encoder);
    }

    pub inline fn draw(render_bundle_encoder: *RenderBundleEncoder, vertex_count: u32, instance_count: u32, first_vertex: u32, first_instance: u32) void {
        return render_bundle_encoder.__vtable.draw_fn(render_bundle_encoder, vertex_count, instance_count, first_vertex, first_instance);
    }

    pub inline fn drawIndexed(render_bundle_encoder: *RenderBundleEncoder, index_count: u32, instance_count: u32, first_index: u32, base_vertex: u32, first_instance: u32) void {
        return render_bundle_encoder.__vtable.draw_indexed_fn(render_bundle_encoder, index_count, instance_count, first_index, base_vertex, first_instance);
    }

    pub inline fn drawIndexedIndirect(render_bundle_encoder: *RenderBundleEncoder, indirect_buffer: *webgpu.Buffer, indirect_offset: u64) void {
        return render_bundle_encoder.__vtable.draw_indexed_indirect_fn(render_bundle_encoder, indirect_buffer, indirect_offset);
    }

    pub inline fn drawIndirect(render_bundle_encoder: *RenderBundleEncoder, indirect_buffer: *webgpu.Buffer, indirect_offset: u64) void {
        return render_bundle_encoder.__vtable.draw_indirect_fn(render_bundle_encoder, indirect_buffer, indirect_offset);
    }

    pub const FinishError = error {
        OutOfMemory,
    };

    pub inline fn finish(render_bundle_encoder: *RenderBundleEncoder) FinishError!*RenderBundle {
        return render_bundle_encoder.__vtable.finish_fn(render_bundle_encoder);
    }

    pub inline fn insertDebugMarker(render_bundle_encoder: *RenderBundleEncoder, marker_label: [:0]const u8) void {
        return render_bundle_encoder.__vtable.insert_debug_marker_fn(render_bundle_encoder, marker_label);
    }

    pub inline fn popDebugGroup(render_bundle_encoder: *RenderBundleEncoder) void {
        return render_bundle_encoder.__vtable.pop_debug_group_fn(render_bundle_encoder);
    }

    pub inline fn pushDebugGroup(render_bundle_encoder: *RenderBundleEncoder, group_label: [:0]const u8) void {
        return render_bundle_encoder.__vtable.push_debug_group_fn(render_bundle_encoder, group_label);
    }

    pub inline fn setBindGroup(render_bundle_encoder: *RenderBundleEncoder, group_index: u32, group: *webgpu.BindGroup, dynamic_offsets: []const u32) void {
        return render_bundle_encoder.__vtable.set_bind_group_fn(render_bundle_encoder, group_index, group, dynamic_offsets);
    }

    pub inline fn setIndexBuffer(render_bundle_encoder: *RenderBundleEncoder, buffer: *webgpu.Buffer, format: webgpu.IndexFormat, offset: u64, size: u64) void {
        return render_bundle_encoder.__vtable.set_index_buffer_fn(render_bundle_encoder, buffer, format, offset, size);
    }

    pub inline fn setPipeline(render_bundle_encoder: *RenderBundleEncoder, pipeline: *webgpu.RenderPipeline) void {
        return render_bundle_encoder.__vtable.set_pipeline_fn(render_bundle_encoder, pipeline);
    }

    pub inline fn setVertexBuffer(render_bundle_encoder: *RenderBundleEncoder, slot: u32, buffer: *webgpu.Buffer, offset: u64, size: u64) void {
        return render_bundle_encoder.__vtable.set_vertex_buffer_fn(render_bundle_encoder, slot, buffer, offset, size);
    }
};

pub const RenderPassEncoder = struct {
    pub const VTable = struct {
        destroy_fn: fn(*RenderPassEncoder) void,
        begin_occlusion_query_fn: fn(*RenderPassEncoder, u32) void,
        begin_pipeline_statistics_query_fn: fn(*RenderPassEncoder, *webgpu.QuerySet, u32) void,
        draw_fn: fn(*RenderPassEncoder, u32, u32, u32, u32) void,
        draw_indexed_fn: fn(*RenderPassEncoder, u32, u32, u32, u32, u32) void,
        draw_indexed_indirect_fn: fn(*RenderPassEncoder, *webgpu.Buffer, u64) void,
        draw_indirect_fn: fn(*RenderPassEncoder, *webgpu.Buffer, u64) void,
        end_occlusion_query_fn: fn(*RenderPassEncoder) void,
        end_pipeline_statistics_query_fn: fn(*RenderPassEncoder) void,
        execute_bundles_fn: fn(*RenderPassEncoder, []*RenderBundle) void,
        insert_debug_marker_fn: fn(*RenderPassEncoder, [:0]const u8) void,
        pop_debug_group_fn: fn(*RenderPassEncoder) void,
        push_debug_group_fn: fn(*RenderPassEncoder, [:0]const u8) void,
        set_bind_group_fn: fn(*RenderPassEncoder, u32, *webgpu.BindGroup, []const u32) void,
        set_blend_constant_fn: fn(*RenderPassEncoder, webgpu.Color) void,
        set_index_buffer_fn: fn(*RenderPassEncoder, *webgpu.Buffer, webgpu.IndexFormat, u64, u64) void,
        set_pipeline_fn: fn(*RenderPassEncoder, *webgpu.RenderPipeline) void,
        set_scissor_rect_fn: fn(*RenderPassEncoder, u32, u32, u32, u32) void,
        set_stencil_reference_fn: fn(*RenderPassEncoder, u32) void,
        set_vertex_buffer_fn: fn(*RenderPassEncoder, u32, *webgpu.Buffer, u64, u64) void,
        set_viewport_fn: fn(*RenderPassEncoder, f32, f32, f32, f32, f32, f32) void,
    };

    __vtable: *const VTable,

    device: *webgpu.Device,

    pub inline fn destroy(render_pass_encoder: *RenderPassEncoder) void {
        render_pass_encoder.__vtable.destroy_fn(render_pass_encoder);
    }

    pub inline fn beginOcclusionQuery(render_pass_encoder: *RenderPassEncoder, query_index: u32) void {
        return render_pass_encoder.__vtable.begin_occlusion_query_fn(render_pass_encoder, query_index);
    }

    pub inline fn beginPipelineStatisticsQuery(render_pass_encoder: *RenderPassEncoder, query_set: *webgpu.QuerySet, query_index: u32) void {
        return render_pass_encoder.__vtable.begin_pipeline_statistics_query_fn(render_pass_encoder, query_set, query_index);
    }

    pub inline fn draw(render_pass_encoder: *RenderPassEncoder, vertex_count: u32, instance_count: u32, first_vertex: u32, first_instance: u32) void {
        return render_pass_encoder.__vtable.draw_fn(render_pass_encoder, vertex_count, instance_count, first_vertex, first_instance);
    }

    pub inline fn drawIndexed(render_pass_encoder: *RenderPassEncoder, index_count: u32, instance_count: u32, first_index: u32, base_vertex: u32, first_instance: u32) void {
        return render_pass_encoder.__vtable.draw_indexed_fn(render_pass_encoder, index_count, instance_count, first_index, base_vertex, first_instance);
    }

    pub inline fn drawIndexedIndirect(render_pass_encoder: *RenderPassEncoder, indirect_buffer: *webgpu.Buffer, indirect_offset: u64) void {
        return render_pass_encoder.__vtable.draw_indexed_indirect_fn(render_pass_encoder, indirect_buffer, indirect_offset);
    }

    pub inline fn drawIndirect(render_pass_encoder: *RenderPassEncoder, indirect_buffer: *webgpu.Buffer, indirect_offset: u64) void {
        return render_pass_encoder.__vtable.draw_indirect_fn(render_pass_encoder, indirect_buffer, indirect_offset);
    }

    pub inline fn endOcclusionQuery(render_pass_encoder: *RenderPassEncoder) void {
        return render_pass_encoder.__vtable.end_occlusion_query_fn(render_pass_encoder);
    }

    pub inline fn endPipelineStatisticsQuery(render_pass_encoder: *RenderPassEncoder) void {
        return render_pass_encoder.__vtable.end_pipeline_statistics_query_fn(render_pass_encoder);
    }

    pub inline fn executeBundles(render_pass_encoder: *RenderPassEncoder, bundles: []RenderBundle) void {
        return render_pass_encoder.__vtable.execute_bundles_fn(render_pass_encoder, bundles);
    }

    pub inline fn insertDebugMarker(render_pass_encoder: *RenderPassEncoder, marker_label: [:0]const u8) void {
        return render_pass_encoder.__vtable.insert_debug_marker_fn(render_pass_encoder, marker_label);
    }

    pub inline fn popDebugGroup(render_pass_encoder: *RenderPassEncoder) void {
        return render_pass_encoder.__vtable.pop_debug_group_fn(render_pass_encoder);
    }

    pub inline fn pushDebugGroup(render_pass_encoder: *RenderPassEncoder, group_label: [:0]const u8) void {
        return render_pass_encoder.__vtable.push_debug_group_fn(render_pass_encoder, group_label);
    }

    pub inline fn setBindGroup(render_pass_encoder: *RenderPassEncoder, group_index: u32, group: *webgpu.BindGroup, dynamic_offsets: []const u32) void {
        return render_pass_encoder.__vtable.set_bind_group_fn(render_pass_encoder, group_index, group, dynamic_offsets);
    }

    pub inline fn setBlendConstant(render_pass_encoder: *RenderPassEncoder, color: webgpu.Color) void {
        return render_pass_encoder.__vtable.set_blend_constant_fn(render_pass_encoder, color);
    }

    pub inline fn setIndexBuffer(render_pass_encoder: *RenderPassEncoder, buffer: *webgpu.Buffer, format: webgpu.IndexFormat, offset: u64, size: u64) void {
        return render_pass_encoder.__vtable.set_index_buffer_fn(render_pass_encoder, buffer, format, offset, size);
    }

    pub inline fn setPipeline(render_pass_encoder: *RenderPassEncoder, pipeline: *webgpu.RenderPipeline) void {
        return render_pass_encoder.__vtable.set_pipeline_fn(render_pass_encoder, pipeline);
    }

    pub inline fn setScissorRect(render_pass_encoder: *RenderPassEncoder, x: u32, y: u32, width: u32, height: u32) void {
        return render_pass_encoder.__vtable.set_scissor_rect_fn(render_pass_encoder, x, y, width, height);
    }

    pub inline fn setStencilReference(render_pass_encoder: *RenderPassEncoder, reference: u32) void {
        return render_pass_encoder.__vtable.set_stencil_reference_fn(render_pass_encoder, reference);
    }

    pub inline fn setVertexBuffer(render_pass_encoder: *RenderPassEncoder, slot: u32, buffer: *webgpu.Buffer, offset: u64, size: u64) void {
        return render_pass_encoder.__vtable.set_vertex_buffer_fn(render_pass_encoder, slot, buffer, offset, size);
    }

    pub inline fn setViewport(render_pass_encoder: *RenderPassEncoder, x: f32, y: f32, width: f32, height: f32, min_depth: f32, max_depth: f32) void {
        return render_pass_encoder.__vtable.set_viewport_fn(render_pass_encoder, x, y, width, height, min_depth, max_depth);
    }
};
