const std = @import("std");

const ComputePipeline = @This();

const backend = @import("backend.zig");
const webgpu = @import("webgpu-core");

device: *backend.Device,
layout: ?*backend.PipelineLayout,

pub fn create(device: *backend.Device, descriptor: webgpu.ComputePipelineDescriptor) !*ComputePipeline {
    _ = descriptor;

    var self = try device.adapter.instance.allocator.create(ComputePipeline);
    errdefer device.adapter.instance.allocator.destroy(self);

    self.device = device;
    self.layout = if (descriptor.layout) |layout| backend.PipelineLayout.from(layout.ptr) else null;

    return self;
}

pub inline fn computePipeline(self: *ComputePipeline) webgpu.ComputePipeline {
    return webgpu.ComputePipeline.init(
        self,
        getBindGroupLayout,
        setLabel,
    );
}

pub inline fn from(ptr: *anyopaque) *ComputePipeline {
    return @ptrCast(*ComputePipeline, @alignCast(@alignOf(ComputePipeline), ptr));
}

pub fn destroy(self: *ComputePipeline) void {
    self.device.adapter.instance.allocator.destroy(self);
}

fn getBindGroupLayout(self: *ComputePipeline, group_index: u32) ?webgpu.BindGroupLayout {
    if (self.layout) |layout| {
        if (group_index < layout.bind_group_layouts.len) {
            return layout.bind_group_layouts[group_index].bindGroupLayout();
        }
    }

    return null;
}

fn setLabel(self: *ComputePipeline, label: ?[]const u8) void {
    _ = self;
    _ = label;
}
