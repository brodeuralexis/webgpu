const std = @import("std");

const PipelineLayout = @This();

const backend = @import("backend.zig");
const webgpu = @import("webgpu-core");

device: *backend.Device,
bind_group_layouts: []*backend.BindGroupLayout,

pub fn create(device: *backend.Device, descriptor: webgpu.PipelineLayoutDescriptor) !*PipelineLayout {
    _ = descriptor;

    var self = try device.adapter.instance.allocator.create(PipelineLayout);
    errdefer device.adapter.instance.allocator.destroy(self);

    self.device = device;
    self.bind_group_layouts = try device.adapter.instance.allocator.alloc(*backend.BindGroupLayout, descriptor.bind_group_layouts.len);
    errdefer device.adapter.instance.allocator.free(self.bind_group_layouts);

    var i: usize = 0;
    while (i < descriptor.bind_group_layouts.len) : (i += 1) {
        self.bind_group_layouts[i] = backend.BindGroupLayout.from(descriptor.bind_group_layouts[i].ptr);
    }

    return self;
}

pub inline fn pipelineLayout(self: *PipelineLayout) webgpu.PipelineLayout {
    return webgpu.PipelineLayout.init(
        self,
        setLabel,
    );
}

pub inline fn from(ptr: *anyopaque) *PipelineLayout {
    return @ptrCast(*PipelineLayout, @alignCast(@alignOf(PipelineLayout), ptr));
}

pub fn destroy(self: *PipelineLayout) void {
    self.device.adapter.instance.allocator.destroy(self);
}

fn setLabel(self: *PipelineLayout, label: ?[]const u8) void {
    _ = self;
    _ = label;
}
