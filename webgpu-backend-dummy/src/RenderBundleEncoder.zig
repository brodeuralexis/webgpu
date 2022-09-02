const std = @import("std");

const RenderBundleEncoder = @This();

const backend = @import("backend.zig");
const webgpu = @import("webgpu-core");

device: *backend.Device,

pub fn create(device: *backend.Device, descriptor: webgpu.RenderBundleEncoderDescriptor) !*RenderBundleEncoder {
    _ = descriptor;

    var self = try device.adapter.instance.allocator.create(RenderBundleEncoder);
    errdefer device.adapter.instance.allocator.destroy(self);

    self.device = device;

    return self;
}

pub inline fn renderBundleEncoder(self: *RenderBundleEncoder) webgpu.RenderBundleEncoder {
    return webgpu.RenderBundleEncoder.init(
        self,
        draw,
        drawIndexed,
        drawIndexedIndirect,
        drawIndirect,
        finish,
        insertDebugMarker,
        popDebugGroup,
        pushDebugGroup,
        setBindGroup,
        setIndexBuffer,
        setLabel,
        setPipeline,
        setVertexBuffer,
    );
}

pub inline fn from(ptr: *anyopaque) *RenderBundleEncoder {
    return @ptrCast(*RenderBundleEncoder, @alignCast(@alignOf(RenderBundleEncoder), ptr));
}

pub fn destroy(self: *RenderBundleEncoder) void {
    self.device.adapter.instance.allocator.destroy(self);
}

fn draw(self: *RenderBundleEncoder, vertex_count: u32, instance_count: u32, first_vertex: u32, first_instance: u32) void {
    _ = self;
    _ = vertex_count;
    _ = instance_count;
    _ = first_vertex;
    _ = first_instance;
}

fn drawIndexed(self: *RenderBundleEncoder, index_count: u32, instance_count: u32, first_index: u32, base_vertex: u32, first_instance: u32) void {
    _ = self;
    _ = index_count;
    _ = instance_count;
    _ = first_index;
    _ = base_vertex;
    _ = first_instance;
}

fn drawIndexedIndirect(self: *RenderBundleEncoder, indirect_buffer: webgpu.Buffer, indirect_offset: usize) void {
    _ = self;
    _ = indirect_buffer;
    _ = indirect_offset;
}

fn drawIndirect(self: *RenderBundleEncoder, indirect_buffer: webgpu.Buffer, indirect_offset: usize) void {
    _ = self;
    _ = indirect_buffer;
    _ = indirect_offset;
}

fn finish(self: *RenderBundleEncoder, descriptor: ?webgpu.RenderBundleDescriptor) webgpu.RenderBundle {
    var render_bundle = backend.RenderBundle.create(self.device, descriptor) catch unreachable;
    errdefer render_bundle.destroy();

    return render_bundle.renderBundle();
}

fn insertDebugMarker(self: *RenderBundleEncoder, marker_label: []const u8) void {
    _ = self;
    _ = marker_label;
}

fn popDebugGroup(self: *RenderBundleEncoder) void {
    _ = self;
}

fn pushDebugGroup(self: *RenderBundleEncoder, group_label: []const u8) void {
    _ = self;
    _ = group_label;
}

fn setBindGroup(self: *RenderBundleEncoder, group_index: u32, bind_group: webgpu.BindGroup, dynamic_offsets: []const u32) void {
    _ = self;
    _ = group_index;
    _ = bind_group;
    _ = dynamic_offsets;
}

fn setIndexBuffer(self: *RenderBundleEncoder, buffer: webgpu.Buffer, format: webgpu.IndexFormat, offset: usize, size: usize) void {
    _ = self;
    _ = buffer;
    _ = format;
    _ = offset;
    _ = size;
}

fn setLabel(self: *RenderBundleEncoder, label: ?[]const u8) void {
    _ = self;
    _ = label;
}

fn setPipeline(self: *RenderBundleEncoder, pipeline: webgpu.RenderPipeline) void {
    _ = self;
    _ = pipeline;
}

fn setVertexBuffer(self: *RenderBundleEncoder, slot: u32, buffer: webgpu.Buffer, offset: usize, size: usize) void {
    _ = self;
    _ = slot;
    _ = buffer;
    _ = offset;
    _ = size;
}
