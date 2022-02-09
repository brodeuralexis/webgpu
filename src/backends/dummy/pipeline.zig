const std = @import("std");

const webgpu = @import("../../webgpu.zig");
const dummy = @import("./dummy.zig");

pub const ComputePipeline = struct {
    const vtable = webgpu.ComputePipeline.VTable{
        .destroy_fn = destroy,
        .get_bind_group_layout_fn = getBindGroupLayout,
        .set_label_fn = setLabel,
    };

    super: webgpu.ComputePipeline,

    device: *dummy.Device,

    pub fn create(device: *dummy.Device, descriptor: webgpu.ComputePipelineDescriptor) webgpu.Device.CreateComputePipelineError!*ComputePipeline {
        _ = descriptor;

        var compute_pipeline = try device.allocator.create(ComputePipeline);
        errdefer device.allocator.destroy(compute_pipeline);

        compute_pipeline.super.__vtable = &vtable;

        compute_pipeline.device = device;

        return compute_pipeline;
    }

    fn destroy(super: *webgpu.ComputePipeline) void {
        var compute_pipeline = @fieldParentPtr(ComputePipeline, "super", super);

        compute_pipeline.device.allocator.destroy(compute_pipeline);
    }

    fn getBindGroupLayout(super: *webgpu.ComputePipeline, group_index: u32) ?*webgpu.BindGroupLayout {
        _ = super;
        _ = group_index;

        return null;
    }

    fn setLabel(super: *webgpu.ComputePipeline, label: [:0]const u8) void {
        _ = super;
        _ = label;
    }
};

pub const RenderPipeline = struct {
    const vtable = webgpu.RenderPipeline.VTable{
        .destroy_fn = destroy,
        .get_bind_group_layout_fn = getBindGroupLayout,
        .set_label_fn = setLabel,
    };

    super: webgpu.RenderPipeline,

    device: *dummy.Device,

    pub fn create(device: *dummy.Device, descriptor: webgpu.RenderPipelineDescriptor) webgpu.Device.CreateRenderPipelineError!*RenderPipeline {
        _ = descriptor;

        var render_pipeline = try device.allocator.create(RenderPipeline);
        errdefer device.allocator.destroy(render_pipeline);

        render_pipeline.super.__vtable = &vtable;

        render_pipeline.device = device;

        return render_pipeline;
    }

    fn destroy(super: *webgpu.RenderPipeline) void {
        var render_pipeline = @fieldParentPtr(RenderPipeline, "super", super);

        render_pipeline.device.allocator.destroy(render_pipeline);
    }

    fn getBindGroupLayout(super: *webgpu.RenderPipeline, group_index: u32) ?*webgpu.BindGroupLayout {
        _ = super;
        _ = group_index;

        return null;
    }

    fn setLabel(super: *webgpu.RenderPipeline, label: [:0]const u8) void {
        _ = super;
        _ = label;
    }
};

pub const ShaderModule = struct {
    const vtable = webgpu.ShaderModule.VTable{
        .destroy_fn = destroy,
        .get_compilation_info_fn = getCompilationInfo,
        .set_label_fn = setLabel,
    };

    super: webgpu.ShaderModule,

    device: *dummy.Device,

    pub fn create(device: *dummy.Device, descriptor: webgpu.ShaderModuleDescriptor) webgpu.Device.CreateShaderModuleError!*ShaderModule {
        _ = descriptor;

        var shader_module = try device.allocator.create(ShaderModule);
        errdefer device.allocator.destroy(shader_module);

        shader_module.super.__vtable = &vtable;

        shader_module.device = device;

        return shader_module;
    }

    fn destroy(super: *webgpu.ShaderModule) void {
        var shader_module = @fieldParentPtr(ShaderModule, "super", super);

        shader_module.device.allocator.destroy(shader_module);
    }

    fn getCompilationInfo(super: *webgpu.ShaderModule) webgpu.ShaderModule.GetCompilationInfoError!webgpu.CompilationInfo {
        _ = super;

        return webgpu.CompilationInfo{.messages = &.{}};
    }

    fn setLabel(super: *webgpu.ShaderModule, label: [:0]const u8) void {
        _ = super;
        _ = label;
    }
};
