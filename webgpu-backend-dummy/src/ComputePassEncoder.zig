const std = @import("std");

const ComputePassEncoder = @This();

const backend = @import("backend.zig");
const webgpu = @import("webgpu-core");

device: *backend.Device,

pub fn create(device: *backend.Device, descriptor: ?webgpu.ComputePassDescriptor) !*ComputePassEncoder {
    _ = descriptor;

    var self = try device.adapter.instance.allocator.create(ComputePassEncoder);
    errdefer device.adapter.instance.allocator.destroy(self);

    self.device = device;

    return self;
}

pub inline fn computePassEncoder(self: *ComputePassEncoder) webgpu.ComputePassEncoder {
    return webgpu.ComputePassEncoder.init(
        self,
        beginPipelineStatisticsQuery,
        dispatchWorkgroups,
        dispatchWorkgroupsIndirect,
        end,
        endPipelineStatisticsQuery,
        insertDebugMarker,
        popDebugGroup,
        pushDebugGroup,
        setBindGroup,
        setLabel,
        setPipeline,
    );
}

pub inline fn from(ptr: *anyopaque) *ComputePassEncoder {
    return @ptrCast(*ComputePassEncoder, @alignCast(@alignOf(ComputePassEncoder), ptr));
}

pub fn destroy(self: *ComputePassEncoder) void {
    self.device.adapter.instance.allocator.destroy(self);
}

fn beginPipelineStatisticsQuery(self: *ComputePassEncoder, query_set: webgpu.QuerySet, query_index: u32) void {
    _ = self;
    _ = query_set;
    _ = query_index;
}

fn dispatchWorkgroups(self: *ComputePassEncoder, workgroupCountX: u32, workgroupCountY: u32, workgroupCountZ: u32) void {
    _ = self;
    _ = workgroupCountX;
    _ = workgroupCountY;
    _ = workgroupCountZ;
}

fn dispatchWorkgroupsIndirect(self: *ComputePassEncoder, indirect_buffer: webgpu.Buffer, indirect_offset: usize) void {
    _ = self;
    _ = indirect_buffer;
    _ = indirect_offset;
}

fn end(self: *ComputePassEncoder) void {
    self.destroy();
}

fn endPipelineStatisticsQuery(self: *ComputePassEncoder) void {
    _ = self;
}

fn insertDebugMarker(self: *ComputePassEncoder, marker_label: []const u8) void {
    _ = self;
    _ = marker_label;
}

fn popDebugGroup(self: *ComputePassEncoder) void {
    _ = self;
}

fn pushDebugGroup(self: *ComputePassEncoder, group_label: []const u8) void {
    _ = self;
    _ = group_label;
}

fn setBindGroup(self: *ComputePassEncoder, group_index: u32, bind_group: webgpu.BindGroup, dynamic_offsets: []const u32) void {
    _ = self;
    _ = group_index;
    _ = bind_group;
    _ = dynamic_offsets;
}

fn setLabel(self: *ComputePassEncoder, label: ?[]const u8) void {
    _ = self;
    _ = label;
}

fn setPipeline(self: *ComputePassEncoder, pipeline: webgpu.ComputePipeline) void {
    _ = self;
    _ = pipeline;
}
