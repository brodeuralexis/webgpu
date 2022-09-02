const std = @import("std");

const RenderPipeline = @This();

const backend = @import("backend.zig");
const webgpu = @import("webgpu-core");

device: *backend.Device,
layout: ?*backend.PipelineLayout,

pub fn create(device: *backend.Device, descriptor: webgpu.RenderPipelineDescriptor) !*RenderPipeline {
    _ = descriptor;

    var self = try device.adapter.instance.allocator.create(RenderPipeline);
    errdefer device.adapter.instance.allocator.destroy(self);

    self.device = device;
    self.layout = if (descriptor.layout) |layout| backend.PipelineLayout.from(layout.ptr) else null;

    return self;
}

pub inline fn renderPipeline(self: *RenderPipeline) webgpu.RenderPipeline {
    return webgpu.RenderPipeline.init(
        self,
        getBindGroupLayout,
        setLabel,
    );
}

pub inline fn from(ptr: *anyopaque) *RenderPipeline {
    return @ptrCast(*RenderPipeline, @alignCast(@alignOf(RenderPipeline), ptr));
}

pub fn destroy(self: *RenderPipeline) void {
    self.device.adapter.instance.allocator.destroy(self);
}

fn getBindGroupLayout(self: *RenderPipeline, group_index: u32) ?webgpu.BindGroupLayout {
    if (self.layout) |layout| {
        if (group_index < layout.bind_group_layouts.len) {
            return layout.bind_group_layouts[group_index].bindGroupLayout();
        }
    }

    return null;
}

fn setLabel(self: *RenderPipeline, label: ?[]const u8) void {
    _ = self;
    _ = label;
}
