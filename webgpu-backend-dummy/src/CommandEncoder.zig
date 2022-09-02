const std = @import("std");

const CommandEncoder = @This();

const backend = @import("backend.zig");
const webgpu = @import("webgpu-core");

device: *backend.Device,

pub fn create(device: *backend.Device, descriptor: webgpu.CommandEncoderDescriptor) !*CommandEncoder {
    _ = descriptor;

    var self = try device.adapter.instance.allocator.create(CommandEncoder);
    errdefer device.adapter.instance.allocator.destroy(self);

    return self;
}

pub inline fn commandEncoder(self: *CommandEncoder) webgpu.CommandEncoder {
    return webgpu.CommandEncoder.init(
        self,
        destroy,
        beginComputePass,
        beginRenderPass,
        clearBuffer,
        copyBufferToBuffer,
        copyBufferToTexture,
        copyTextureToBuffer,
        copyTextureToTexture,
        finish,
        insertDebugMarker,
        popDebugGroup,
        pushDebugGroup,
        resolveQuerySet,
        setLabel,
        writeTimestamp,
    );
}

pub inline fn from(ptr: *anyopaque) *CommandEncoder {
    return @ptrCast(*CommandEncoder, @alignCast(@alignOf(CommandEncoder), ptr));
}

pub fn destroy(self: *CommandEncoder) void {
    self.device.adapter.instance.allocator.destroy(self);
}

fn beginComputePass(self: *CommandEncoder, descriptor: ?webgpu.ComputePassDescriptor) webgpu.CommandEncoder.BeginComputePassError!webgpu.ComputePassEncoder {
    var compute_pass_encoder = try backend.ComputePassEncoder.create(self.device, descriptor);
    errdefer compute_pass_encoder.destroy();

    return compute_pass_encoder.computePassEncoder();
}

fn beginRenderPass(self: *CommandEncoder, descriptor: webgpu.RenderPassDescriptor) webgpu.CommandEncoder.BeginRenderPassError!webgpu.RenderPassEncoder {
    var render_pass_encoder = try backend.RenderPassEncoder.create(self.device, descriptor);
    errdefer render_pass_encoder.destroy();

    return render_pass_encoder.renderPassEncoder();
}

fn clearBuffer(self: *CommandEncoder, buffer: webgpu.Buffer, offset: usize, size: ?usize) void {
    _ = self;

    var backend_buffer = backend.Buffer.from(buffer.ptr);
    const len = if (size) |s| s else backend_buffer.data.len - offset;
    std.mem.set(u8, backend_buffer.data[offset..(offset + len)], 0);
}

fn copyBufferToBuffer(self: *CommandEncoder, source: webgpu.Buffer, source_offset: usize, destination: webgpu.Buffer, destination_offset: usize, size: usize) void {
    _ = self;
    _ = source;
    _ = source_offset;
    _ = destination;
    _ = destination_offset;
    _ = size;
}

fn copyBufferToTexture(self: *CommandEncoder, source: webgpu.ImageCopyBuffer, destination: webgpu.ImageCopyTexture, extent: webgpu.Extent3D) void {
    _ = self;
    _ = source;
    _ = destination;
    _ = extent;
}

fn copyTextureToBuffer(self: *CommandEncoder, source: webgpu.ImageCopyTexture, destination: webgpu.ImageCopyTexture, extent: webgpu.Extent3D) void {
    _ = self;
    _ = source;
    _ = destination;
    _ = extent;
}

fn copyTextureToTexture(self: *CommandEncoder, source: webgpu.ImageCopyTexture, destination: webgpu.ImageCopyTexture, extent: webgpu.Extent3D) void {
    _ = self;
    _ = source;
    _ = destination;
    _ = extent;
}

fn finish(self: *CommandEncoder, descriptor: ?webgpu.CommandBufferDescriptor) webgpu.CommandBuffer {
    _ = descriptor;

    var command_buffer = backend.CommandBuffer.create(self.device, descriptor) catch unreachable;
    errdefer command_buffer.destroy();

    return command_buffer.commandBuffer();
}

fn insertDebugMarker(self: *CommandEncoder, marker_label: []const u8) void {
    _ = self;
    _ = marker_label;
}

fn popDebugGroup(self: *CommandEncoder) void {
    _ = self;
}

fn pushDebugGroup(self: *CommandEncoder, group_label: []const u8) void {
    _ = self;
    _ = group_label;
}

fn resolveQuerySet(self: *CommandEncoder, query_set: webgpu.QuerySet, first_query: u32, query_count: u32, destination: webgpu.Buffer, destination_offset: usize) void {
    _ = self;
    _ = query_set;
    _ = first_query;
    _ = query_count;
    _ = destination;
    _ = destination_offset;
}

fn setLabel(self: *CommandEncoder, label: ?[]const u8) void {
    _ = self;
    _ = label;
}

fn writeTimestamp(self: *CommandEncoder, query_set: webgpu.QuerySet, query_index: u32) void {
    _ = self;
    _ = query_set;
    _ = query_index;
}
