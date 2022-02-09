const std = @import("std");

const webgpu = @import("../../webgpu.zig");
const dummy = @import("./dummy.zig");

pub const BindGroup = struct {
    const vtable = webgpu.BindGroup.VTable{
        .destroy_fn = destroy,
    };

    super: webgpu.BindGroup,

    pub fn create(device: *dummy.Device, descriptor: webgpu.BindGroupDescriptor) webgpu.Device.CreateBindGroupError!*BindGroup {
        _ = descriptor;

        var bind_group = try device.allocator.create(BindGroup);
        errdefer device.allocator.destroy(bind_group);

        bind_group.super = .{
            .__vtable = &vtable,
            .device = &device.super,
        };

        return bind_group;
    }

    fn destroy(super: *webgpu.BindGroup) void {
        var bind_group = @fieldParentPtr(BindGroup, "super", super);
        var device = @fieldParentPtr(dummy.Device, "super", super.device);

        device.allocator.destroy(bind_group);
    }
};

pub const BindGroupLayout = struct {
    const vtable = webgpu.BindGroupLayout.VTable{
        .destroy_fn = destroy,
    };

    super: webgpu.BindGroupLayout,

    pub fn create(device: *dummy.Device, descriptor: webgpu.BindGroupLayoutDescriptor) webgpu.Device.CreateBindGroupLayoutError!*BindGroupLayout {
        _ = descriptor;

        var bind_group_layout = try device.allocator.create(BindGroupLayout);
        errdefer device.allocator.destroy(bind_group_layout);

        bind_group_layout.super = .{
            .__vtable = &vtable,
            .device = &device.super,
        };

        return bind_group_layout;
    }

    fn destroy(super: *webgpu.BindGroupLayout) void {
        var bind_group_layout = @fieldParentPtr(BindGroupLayout, "super", super);
        var device = @fieldParentPtr(dummy.Device, "super", super.device);

        device.allocator.destroy(bind_group_layout);
    }
};

pub const PipelineLayout = struct {
    const vtable = webgpu.PipelineLayout.VTable{
        .destroy_fn = destroy,
    };

    super: webgpu.PipelineLayout,

    pub fn create(device: *dummy.Device, descriptor: webgpu.PipelineLayoutDescriptor) webgpu.Device.CreatePipelineLayoutError!*PipelineLayout {
        _ = descriptor;

        var pipeline_layout = try device.allocator.create(PipelineLayout);
        errdefer device.allocator.destroy(pipeline_layout);

        pipeline_layout.super = .{
            .__vtable = &vtable,
            .device = &device.super,
        };

        return pipeline_layout;
    }

    fn destroy(super: *webgpu.PipelineLayout) void {
        var pipeline_layout = @fieldParentPtr(PipelineLayout, "super", super);
        var device = @fieldParentPtr(dummy.Device, "super", super.device);

        device.allocator.destroy(pipeline_layout);
    }
};
