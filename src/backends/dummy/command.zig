const std = @import("std");

const webgpu = @import("../../webgpu.zig");
const dummy = @import("./dummy.zig");

pub const CommandBuffer = struct {
    const vtable = webgpu.CommandBuffer.VTable{
        .destroy_fn = destroy,
    };

    super: webgpu.CommandBuffer,

    device: *dummy.Device,

    pub fn create(device: *dummy.Device, descriptor: webgpu.CommandBufferDescriptor) !*CommandBuffer {
        _ = descriptor;

        var command_buffer = try device.allocator.create(CommandBuffer);
        errdefer device.allocator.destroy(command_buffer);

        command_buffer.super.__vtable = &vtable;

        command_buffer.device = device;

        return command_buffer;
    }

    fn destroy(super: *webgpu.CommandBuffer) void {
        var command_buffer = @fieldParentPtr(CommandBuffer, "super", super);

        command_buffer.device.allocator.destroy(command_buffer);
    }
};

pub const CommandEncoder = struct {
    const vtable = webgpu.CommandEncoder.VTable{
        .destroy_fn = destroy,
        .begin_compute_pass_fn = beginComputePass,
        .begin_render_pass_fn = beginRenderPass,
        .clear_buffer_fn = clearBuffer,
        .copy_buffer_to_buffer_fn = copyBufferToBuffer,
        .copy_buffer_to_texture_fn = copyBufferToTexture,
        .copy_texture_to_buffer_fn = copyTextureToBuffer,
        .copy_texture_to_texture_fn = copyTextureToTexture,
        .finish_fn = finish,
        .insert_debug_marker_fn = insertDebugMarker,
        .pop_debug_group_fn = popDebugGroup,
        .push_debug_group_fn = pushDebugGroup,
        .resolve_query_set_fn = resolveQuerySet,
        .write_timestamp_fn = writeTimestamp,
    };

    super: webgpu.CommandEncoder,

    device: *dummy.Device,

    pub fn create(device: *dummy.Device, descriptor: webgpu.CommandEncoderDescriptor) webgpu.Device.CreateCommandEncoderError!*CommandEncoder {
        _ = descriptor;

        var command_encoder = try device.allocator.create(CommandEncoder);
        errdefer device.allocator.destroy(command_encoder);

        command_encoder.super.__vtable = &vtable;

        command_encoder.device = device;

        return command_encoder;
    }

    fn destroy(super: *webgpu.CommandEncoder) void {
        var command_encoder = @fieldParentPtr(CommandEncoder, "super", super);

        command_encoder.device.allocator.destroy(command_encoder);
    }

    fn beginComputePass(super: *webgpu.CommandEncoder, descriptor: webgpu.ComputePassDescriptor) webgpu.CommandEncoder.BeginComputePassError!*webgpu.ComputePassEncoder {
        var command_encoder = @fieldParentPtr(CommandEncoder, "super", super);

        var compute_pass_encoder = try ComputePassEncoder.create(command_encoder.device, descriptor);

        return &compute_pass_encoder.super;
    }

    fn beginRenderPass(super: *webgpu.CommandEncoder, descriptor: webgpu.RenderPassDescriptor) webgpu.CommandEncoder.BeginRenderPassError!*webgpu.RenderPassEncoder {
        var command_encoder = @fieldParentPtr(CommandEncoder, "super", super);

        var render_pass_encoder = try RenderPassEncoder.create(command_encoder.device, descriptor);

        return &render_pass_encoder.super;
    }

    fn clearBuffer(super: *webgpu.CommandEncoder, buffer: *webgpu.Buffer, offset: usize, size: usize) webgpu.CommandEncoder.ClearBufferError!void {
        _ = super;

        var data = try buffer.getMappedRange(offset, size);
        std.mem.set(u8, data, 0);
    }

    fn copyBufferToBuffer(super: *webgpu.CommandEncoder, source: *webgpu.Buffer, source_offset: usize, destination: *webgpu.Buffer, destination_offset: usize, size: usize) webgpu.CommandEncoder.CopyBufferToBufferError!void {
        _ = super;

        var source_data = try source.getMappedRange(source_offset, size);
        var destination_data = try destination.getMappedRange(destination_offset, size);

        std.mem.copy(u8, destination_data, source_data);
    }

    fn copyBufferToTexture(super: *webgpu.CommandEncoder, source: webgpu.ImageCopyBuffer, destination: webgpu.ImageCopyTexture, copy_size: webgpu.Extend3D) webgpu.CommandEncoder.CopyBufferToTextureError!void {
        _ = super;
        _ = source;
        _ = destination;
        _ = copy_size;
    }

    fn copyTextureToBuffer(super: *webgpu.CommandEncoder, source: webgpu.ImageCopyTexture, destination: webgpu.ImageCopyBuffer, copy_size: webgpu.Extend3D) webgpu.CommandEncoder.CopyTextureToBufferError!void {
        _ = super;
        _ = source;
        _ = destination;
        _ = copy_size;
    }

    fn copyTextureToTexture(super: *webgpu.CommandEncoder, source: webgpu.ImageCopyTexture, destination: webgpu.ImageCopyTexture, copy_size: webgpu.Extend3D) webgpu.CommandEncoder.CopyTextureToTextureError!void {
        _ = super;
        _ = source;
        _ = destination;
        _ = copy_size;
    }

    fn finish(super: *webgpu.CommandEncoder, descriptor: webgpu.CommandBufferDescriptor) webgpu.CommandEncoder.FinishError!*webgpu.CommandBuffer {
        var command_encoder = @fieldParentPtr(CommandEncoder, "super", super);

        var command_buffer = try CommandBuffer.create(command_encoder.device, descriptor);

        return &command_buffer.super;
    }

    fn insertDebugMarker(super: *webgpu.CommandEncoder, marker_label: [:0]const u8) void {
        _ = super;
        _ = marker_label;
    }

    fn popDebugGroup(super: *webgpu.CommandEncoder) void {
        _ = super;
    }

    fn pushDebugGroup(super: *webgpu.CommandEncoder, group_label: [:0]const u8) void {
        _ = super;
        _ = group_label;
    }

    fn resolveQuerySet(super: *webgpu.CommandEncoder, query_set: *webgpu.QuerySet, first_query: u32, query_count: u32, destination: *webgpu.Buffer, destination_offset: u64) webgpu.CommandEncoder.ResolveQuerySetError!void {
        _ = super;
        _ = query_set;
        _ = first_query;
        _ = query_count;
        _ = destination;
        _ = destination_offset;
    }

    fn writeTimestamp(super: *webgpu.CommandEncoder, query_set: *webgpu.QuerySet, query_index: u32) webgpu.CommandEncoder.WriteTimestampError!void {
        _ = super;
        _ = query_set;
        _ = query_index;
    }
};

pub const ComputePassEncoder = struct {
    const vtable = webgpu.ComputePassEncoder.VTable{
        .destroy_fn = destroy,
        .begin_pipeline_statistics_query_fn = beginPipelineStatisticsQuery,
        .dispatch_fn = dispatch,
        .dispatch_indirect_fn = dispatchIndirect,
        .end_pass_fn = endPass,
        .end_pipeline_statistics_query_fn = endPipelineStatisticsQuery,
        .insert_debug_marker_fn = insertDebugMarker,
        .pop_debug_group_fn = popDebugGroup,
        .push_debug_group_fn = pushDebugGroup,
        .set_bind_group_fn = setBindGroup,
        .set_pipeline_fn = setPipeline,
    };

    super: webgpu.ComputePassEncoder,

    device: *dummy.Device,

    pub fn create(device: *dummy.Device, descriptor: webgpu.ComputePassDescriptor) webgpu.CommandEncoder.BeginComputePassError!*ComputePassEncoder {
        _ = descriptor;

        var compute_pass_encoder = try device.allocator.create(ComputePassEncoder);
        errdefer device.allocator.destroy(compute_pass_encoder);

        compute_pass_encoder.super.__vtable = &vtable;

        compute_pass_encoder.device = device;

        return compute_pass_encoder;
    }

    fn destroy(super: *webgpu.ComputePassEncoder) void {
        var compute_pass_encoder = @fieldParentPtr(ComputePassEncoder, "super", super);

        compute_pass_encoder.device.allocator.destroy(compute_pass_encoder);
    }

    fn beginPipelineStatisticsQuery(super: *webgpu.ComputePassEncoder, query_set: *webgpu.QuerySet, query_index: u32) webgpu.ComputePassEncoder.BeginPipelineStatisticsQueryError!void {
        _ = super;
        _ = query_set;
        _ = query_index;
    }

    fn dispatch(super: *webgpu.ComputePassEncoder, x: u32, y: u32, z: u32) webgpu.ComputePassEncoder.DispatchError!void {
        _ = super;
        _ = x;
        _ = y;
        _ = z;
    }

    fn dispatchIndirect(super: *webgpu.ComputePassEncoder, indirect_buffer: *webgpu.Buffer, indirect_offset: u64) webgpu.ComputePassEncoder.DispatchIndirectError!void {
        _ = super;
        _ = indirect_buffer;
        _ = indirect_offset;
    }

    fn endPass(super: *webgpu.ComputePassEncoder) webgpu.ComputePassEncoder.EndPassError!void {
        _ = super;
    }

    fn endPipelineStatisticsQuery(super: *webgpu.ComputePassEncoder) webgpu.ComputePassEncoder.EndPipelineStatisticsQueryError!void {
        _ = super;
    }

    fn insertDebugMarker(super: *webgpu.ComputePassEncoder, marker_label: [:0]const u8) void {
        _ = super;
        _ = marker_label;
    }

    fn popDebugGroup(super: *webgpu.ComputePassEncoder) void {
        _ = super;
    }

    fn pushDebugGroup(super: *webgpu.ComputePassEncoder, group_label: [:0]const u8) void {
        _ = super;
        _ = group_label;
    }

    fn setBindGroup(super: *webgpu.ComputePassEncoder, group_index: u32, group: *webgpu.BindGroup, dynamic_offets: []const u32) webgpu.ComputePassEncoder.SetBindGroupError!void {
        _ = super;
        _ = group_index;
        _ = group;
        _ = dynamic_offets;
    }

    fn setPipeline(super: *webgpu.ComputePassEncoder, pipeline: *webgpu.ComputePipeline) webgpu.ComputePassEncoder.SetPipelineError!void {
        _ = super;
        _ = pipeline;
    }
};

pub const RenderBundle = struct {
    const vtable = webgpu.RenderBundle.VTable{
        .destroy_fn = destroy,
    };

    super: webgpu.RenderBundle,

    device: *dummy.Device,

    pub fn create(device: *dummy.Device) !*RenderBundle {
        var render_bundle = try device.allocator.create(RenderBundle);
        errdefer device.allocator.destroy(render_bundle);

        render_bundle.super.__vtable = &vtable;

        render_bundle.device = device;

        return render_bundle;
    }

    fn destroy(super: *webgpu.RenderBundle) void {
        var render_bundle = @fieldParentPtr(RenderBundle, "super", super);

        render_bundle.device.allocator.destroy(render_bundle);
    }
};

pub const RenderBundleEncoder = struct {
    const vtable = webgpu.RenderBundleEncoder.VTable{
        .destroy_fn = destroy,
        .draw_fn = draw,
        .draw_indexed_fn = drawIndexed,
        .draw_indexed_indirect_fn = drawIndexedIndirect,
        .draw_indirect_fn = drawIndirect,
        .finish_fn = finish,
        .insert_debug_marker_fn = insertDebugMarker,
        .pop_debug_group_fn = popDebugGroup,
        .push_debug_group_fn = pushDebugGroup,
        .set_bind_group_fn = setBindGroup,
        .set_index_buffer_fn = setIndexBuffer,
        .set_pipeline_fn = setPipeline,
        .set_vertex_buffer_fn = setVertexBuffer,
    };

    super: webgpu.RenderBundleEncoder,

    device: *dummy.Device,

    pub fn create(device: *dummy.Device, descriptor: webgpu.RenderBundleEncoderDescriptor) webgpu.CommandEncoder.BeginComputePassError!*RenderBundleEncoder {
        _ = descriptor;

        var compute_pass_encoder = try device.allocator.create(RenderBundleEncoder);
        errdefer device.allocator.destroy(compute_pass_encoder);

        compute_pass_encoder.super.__vtable = &vtable;

        compute_pass_encoder.device = device;

        return compute_pass_encoder;
    }

    fn destroy(super: *webgpu.RenderBundleEncoder) void {
        var render_bundle_encoder = @fieldParentPtr(RenderBundleEncoder, "super", super);

        render_bundle_encoder.device.allocator.destroy(render_bundle_encoder);
    }

    fn draw(super: *webgpu.RenderBundleEncoder, vertex_count: u32, instance_count: u32, first_vertex: u32, first_instance: u32) void {
        _ = super;
        _ = vertex_count;
        _ = instance_count;
        _ = first_vertex;
        _ = first_instance;
    }

    fn drawIndexed(super: *webgpu.RenderBundleEncoder, index_count: u32, instance_count: u32, first_index: u32, base_vertex: u32, first_instance: u32) void {
        _ = super;
        _ = index_count;
        _ = instance_count;
        _ = first_index;
        _ = base_vertex;
        _ = first_instance;
    }

    fn drawIndexedIndirect(super: *webgpu.RenderBundleEncoder, indirect_buffer: *webgpu.Buffer, indirect_offset: u64) void {
        _ = super;
        _ = indirect_buffer;
        _ = indirect_offset;
    }

    fn drawIndirect(super: *webgpu.RenderBundleEncoder, indirect_buffer: *webgpu.Buffer, indirect_offset: u64) void {
        _ = super;
        _ = indirect_buffer;
        _ = indirect_offset;
    }

    fn finish(super: *webgpu.RenderBundleEncoder) webgpu.RenderBundleEncoder.FinishError!*webgpu.RenderBundle {
        var render_bundle_encoder = @fieldParentPtr(RenderBundleEncoder, "super", super);

        var render_bundle = try RenderBundle.create(render_bundle_encoder.device);

        return &render_bundle.super;
    }

    fn beginPipelineStatisticsQuery(super: *webgpu.RenderBundleEncoder, query_set: *webgpu.QuerySet, query_index: u32) webgpu.RenderBundleEncoder.BeginPipelineStatisticsQueryError!void {
        _ = super;
        _ = query_set;
        _ = query_index;
    }

    fn dispatch(super: *webgpu.RenderBundleEncoder, x: u32, y: u32, z: u32) webgpu.RenderBundleEncoder.DispatchError!void {
        _ = super;
        _ = x;
        _ = y;
        _ = z;
    }

    fn dispatchIndirect(super: *webgpu.RenderBundleEncoder, indirect_buffer: *webgpu.Buffer, indirect_offset: u64) webgpu.RenderBundleEncoder.DispatchIndirectError!void {
        _ = super;
        _ = indirect_buffer;
        _ = indirect_offset;
    }

    fn endPass(super: *RenderBundleEncoder) webgpu.RenderBundleEncoder.EndPassError!void {
        _ = super;
    }

    fn endPipelineStatisticsQuery(super: *webgpu.RenderBundleEncoder) webgpu.RenderBundleEncoder.EndPipelineStatisticsQueryError!void {
        _ = super;
    }

    fn insertDebugMarker(super: *webgpu.RenderBundleEncoder, marker_label: [:0]const u8) void {
        _ = super;
        _ = marker_label;
    }

    fn popDebugGroup(super: *webgpu.RenderBundleEncoder) void {
        _ = super;
    }

    fn pushDebugGroup(super: *webgpu.RenderBundleEncoder, group_label: [:0]const u8) void {
        _ = super;
        _ = group_label;
    }

    fn setBindGroup(super: *webgpu.RenderBundleEncoder, group_index: u32, group: *webgpu.BindGroup, dynamic_offets: []const u32) void {
        _ = super;
        _ = group_index;
        _ = group;
        _ = dynamic_offets;
    }

    fn setIndexBuffer(super: *webgpu.RenderBundleEncoder, buffer: *webgpu.Buffer, format: webgpu.IndexFormat, offset: u64, size: u64) void {
        _ = super;
        _ = buffer;
        _ = format;
        _ = offset;
        _ = size;
    }

    fn setPipeline(super: *webgpu.RenderBundleEncoder, pipeline: *webgpu.RenderPipeline) void {
        _ = super;
        _ = pipeline;
    }

    fn setVertexBuffer(super: *webgpu.RenderBundleEncoder, slot: u32, buffer: *webgpu.Buffer, offset: u64, size: u64) void {
        _ = super;
        _ = slot;
        _ = buffer;
        _ = offset;
        _ = size;
    }
};

pub const RenderPassEncoder = struct {
    const vtable = webgpu.RenderPassEncoder.VTable{
        .destroy_fn = destroy,
        .begin_occlusion_query_fn = beginOcclusionQuery,
        .begin_pipeline_statistics_query_fn = beginPipelineStatisticsQuery,
        .draw_fn = draw,
        .draw_indexed_fn = drawIndexed,
        .draw_indexed_indirect_fn = drawIndexedIndirect,
        .draw_indirect_fn = drawIndirect,
        .end_occlusion_query_fn = endOcclusionQuery,
        .end_pipeline_statistics_query_fn = endPipelineStatisticsQuery,
        .execute_bundles_fn = executeBundles,
        .insert_debug_marker_fn = insertDebugMarker,
        .pop_debug_group_fn = popDebugGroup,
        .push_debug_group_fn = pushDebugGroup,
        .set_bind_group_fn = setBindGroup,
        .set_blend_constant_fn = setBlendConstant,
        .set_index_buffer_fn = setIndexBuffer,
        .set_pipeline_fn = setPipeline,
        .set_scissor_rect_fn = setScissorRect,
        .set_stencil_reference_fn = setStencilReference,
        .set_vertex_buffer_fn = setVertexBuffer,
        .set_viewport_fn = setViewport,
    };

    super: webgpu.RenderPassEncoder,

    device: *dummy.Device,

    pub fn create(device: *dummy.Device, descriptor: webgpu.RenderPassDescriptor) webgpu.CommandEncoder.BeginRenderPassError!*RenderPassEncoder {
        _ = descriptor;

        var render_pass_encoder = try device.allocator.create(RenderPassEncoder);
        errdefer device.allocator.destroy(render_pass_encoder);

        render_pass_encoder.super.__vtable = &vtable;

        render_pass_encoder.device = device;

        return render_pass_encoder;
    }

    fn destroy(super: *webgpu.RenderPassEncoder) void {
        var render_pass_encoder = @fieldParentPtr(RenderPassEncoder, "super", super);

        render_pass_encoder.device.allocator.destroy(render_pass_encoder);
    }

    fn beginOcclusionQuery(super: *webgpu.RenderPassEncoder, query_index: u32) void {
        _ = super;
        _ = query_index;
    }

    fn beginPipelineStatisticsQuery(super: *webgpu.RenderPassEncoder, query_set: *webgpu.QuerySet, query_index: u32) void {
        _ = super;
        _ = query_set;
        _ = query_index;
    }

    fn draw(super: *webgpu.RenderPassEncoder, vertex_count: u32, instance_count: u32, first_vertex: u32, first_instance: u32) void {
        _ = super;
        _ = vertex_count;
        _ = instance_count;
        _ = first_vertex;
        _ = first_instance;
    }

    fn drawIndexed(super: *webgpu.RenderPassEncoder, index_count: u32, instance_count: u32, first_index: u32, base_vertex: u32, first_instance: u32) void {
        _ = super;
        _ = index_count;
        _ = instance_count;
        _ = first_index;
        _ = base_vertex;
        _ = first_instance;
    }

    fn drawIndexedIndirect(super: *webgpu.RenderPassEncoder, indirect_buffer: *webgpu.Buffer, indirect_offset: u64) void {
        _ = super;
        _ = indirect_buffer;
        _ = indirect_offset;
    }

    fn drawIndirect(super: *webgpu.RenderPassEncoder, indirect_buffer: *webgpu.Buffer, indirect_offset: u64) void {
        _ = super;
        _ = indirect_buffer;
        _ = indirect_offset;
    }

    fn endOcclusionQuery(super: *webgpu.RenderPassEncoder) void {
        _ = super;
    }

    fn endPipelineStatisticsQuery(super: *webgpu.RenderPassEncoder) void {
        _ = super;
    }

    fn executeBundles(super: *webgpu.RenderPassEncoder, bundles: []*webgpu.RenderBundle) void {
        _ = super;
        _ = bundles;
    }

    fn insertDebugMarker(super: *webgpu.RenderPassEncoder, marker_label: [:0]const u8) void {
        _ = super;
        _ = marker_label;
    }

    fn popDebugGroup(super: *webgpu.RenderPassEncoder) void {
        _ = super;
    }

    fn pushDebugGroup(super: *webgpu.RenderPassEncoder, group_label: [:0]const u8) void {
        _ = super;
        _ = group_label;
    }

    fn setBindGroup(super: *webgpu.RenderPassEncoder, group_index: u32, group: *webgpu.BindGroup, dynamic_offsets: []const u32) void {
        _ = super;
        _ = group_index;
        _ = group;
        _ = dynamic_offsets;
    }

    fn setBlendConstant(super: *webgpu.RenderPassEncoder, color: webgpu.Color) void {
        _ = super;
        _ = color;
    }

    fn setIndexBuffer(super: *webgpu.RenderPassEncoder, buffer: *webgpu.Buffer, format: webgpu.IndexFormat, offset: u64, size: u64) void {
        _ = super;
        _ = buffer;
        _ = format;
        _ = offset;
        _ = size;
    }

    fn setPipeline(super: *webgpu.RenderPassEncoder, pipeline: *webgpu.RenderPipeline) void {
        _ = super;
        _ = pipeline;
    }

    fn setScissorRect(super: *webgpu.RenderPassEncoder, x: u32, y: u32, width: u32, height: u32) void {
        _ = super;
        _ = x;
        _ = y;
        _ = width;
        _ = height;
    }

    fn setStencilReference(super: *webgpu.RenderPassEncoder, reference: u32) void {
        _ = super;
        _ = reference;
    }

    fn setVertexBuffer(super: *webgpu.RenderPassEncoder, slot: u32, buffer: *webgpu.Buffer, offset: u64, size: u64) void {
        _ = super;
        _ = slot;
        _ = buffer;
        _ = offset;
        _ = size;
    }

    fn setViewport(super: *webgpu.RenderPassEncoder, x: f32, y: f32, width: f32, height: f32, min_depth: f32, max_depth: f32) void {
        _ = super;
        _ = x;
        _ = y;
        _ = width;
        _ = height;
        _ = min_depth;
        _ = max_depth;
    }
};
