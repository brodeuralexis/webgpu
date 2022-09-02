const std = @import("std");

const RenderPassEncoder = @This();

const backend = @import("backend.zig");
const webgpu = @import("webgpu-core");

device: *backend.Device,

pub fn create(device: *backend.Device, descriptor: webgpu.RenderPassDescriptor) !*RenderPassEncoder {
    _ = descriptor;

    var self = try device.adapter.instance.allocator.create(RenderPassEncoder);
    errdefer self.device.adapter.instance.allocator.destroy(self);

    self.device = device;

    return self;
}

pub inline fn renderPassEncoder(self: *RenderPassEncoder) webgpu.RenderPassEncoder {
    return webgpu.RenderPassEncoder.init(
        self,
        beginOcclusionQuery,
        beginPipelineStatisticsQuery,
        draw,
        drawIndexed,
        drawIndirectIndexed,
        drawIndirect,
        end,
        endOcclusionQuery,
        endPipelineStatisticsQuery,
        executeBundles,
        insertDebugMarker,
        popDebugGroup,
        pushDebugGroup,
        setBindGroup,
        setBlendConstant,
        setIndexBuffer,
        setLabel,
        setPipeline,
        setScissorRect,
        setStencilReference,
        setVertexBuffer,
        setViewport,
    );
}

pub inline fn from(ptr: *anyopaque) *RenderPassEncoder {
    return @ptrCast(*RenderPassEncoder, @alignCast(@alignOf(RenderPassEncoder), ptr));
}

pub fn destroy(self: *RenderPassEncoder) void {
    self.device.adapter.instance.allocator.destroy(self);
}

fn beginOcclusionQuery(self: *RenderPassEncoder, query_index: u32) void {
    _ = self;
    _ = query_index;
}

fn beginPipelineStatisticsQuery(self: *RenderPassEncoder, query_set: webgpu.QuerySet, query_index: u32) void {
    _ = self;
    _ = query_set;
    _ = query_index;
}

fn draw(self: *RenderPassEncoder, vertex_count: u32, instance_count: u32, first_vertex: u32, first_instance: u32) void {
    _ = self;
    _ = vertex_count;
    _ = instance_count;
    _ = first_vertex;
    _ = first_instance;
}

fn drawIndexed(self: *RenderPassEncoder, index_count: u32, instance_count: u32, first_index: u32, base_vertex: u32, first_instance: u32) void {
    _ = self;
    _ = index_count;
    _ = instance_count;
    _ = first_index;
    _ = base_vertex;
    _ = first_instance;
}

fn drawIndirectIndexed(self: *RenderPassEncoder, indirect_buffer: webgpu.Buffer, indirect_offset: usize) void {
    _ = self;
    _ = indirect_buffer;
    _ = indirect_offset;
}

fn drawIndirect(self: *RenderPassEncoder, indirect_buffer: webgpu.Buffer, indirect_offset: usize) void {
    _ = self;
    _ = indirect_buffer;
    _ = indirect_offset;
}

fn end(self: *RenderPassEncoder) void {
    destroy(self);
}

fn endOcclusionQuery(self: *RenderPassEncoder) void {
    _ = self;
}

fn endPipelineStatisticsQuery(self: *RenderPassEncoder) void {
    _ = self;
}

fn executeBundles(self: *RenderPassEncoder, bundles: []const webgpu.RenderBundle) void {
    _ = self;
    _ = bundles;
}

fn insertDebugMarker(self: *RenderPassEncoder, marker_label: []const u8) void {
    _ = self;
    _ = marker_label;
}

fn popDebugGroup(self: *RenderPassEncoder) void {
    _ = self;
}

fn pushDebugGroup(self: *RenderPassEncoder, group_label: []const u8) void {
    _ = self;
    _ = group_label;
}

fn setBindGroup(self: *RenderPassEncoder, group_index: u32, bind_group: webgpu.BindGroup, dynamic_offsets: []const u32) void {
    _ = self;
    _ = group_index;
    _ = bind_group;
    _ = dynamic_offsets;
}

fn setBlendConstant(self: *RenderPassEncoder, color: webgpu.Color) void {
    _ = self;
    _ = color;
}

fn setIndexBuffer(self: *RenderPassEncoder, buffer: webgpu.Buffer, format: webgpu.IndexFormat, offset: usize, size: usize) void {
    _ = self;
    _ = buffer;
    _ = format;
    _ = offset;
    _ = size;
}

fn setLabel(self: *RenderPassEncoder, label: ?[]const u8) void {
    _ = self;
    _ = label;
}

fn setPipeline(self: *RenderPassEncoder, pipeline: webgpu.RenderPipeline) void {
    _ = self;
    _ = pipeline;
}

fn setScissorRect(self: *RenderPassEncoder, x: u32, y: u32, width: u32, height: u32) void {
    _ = self;
    _ = x;
    _ = y;
    _ = width;
    _ = height;
}

fn setStencilReference(self: *RenderPassEncoder, reference: u32) void {
    _ = self;
    _ = reference;
}

fn setVertexBuffer(self: *RenderPassEncoder, slot: u32, buffer: webgpu.Buffer, offset: usize, size: usize) void {
    _ = self;
    _ = slot;
    _ = buffer;
    _ = offset;
    _ = size;
}

fn setViewport(self: *RenderPassEncoder, x: f32, y: f32, width: f32, height: f32, min_depth: f32, max_depth: f32) void {
    _ = self;
    _ = x;
    _ = y;
    _ = width;
    _ = height;
    _ = min_depth;
    _ = max_depth;
}
