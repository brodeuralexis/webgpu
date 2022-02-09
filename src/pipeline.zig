const std = @import("std");
const webgpu = @import("./webgpu.zig");

pub const ComputePipeline = struct {
    pub const VTable = struct {
        destroy_fn: fn(*ComputePipeline) void,
        get_bind_group_layout_fn: fn(*ComputePipeline, u32) ?*webgpu.BindGroupLayout,
        set_label_fn: fn(*ComputePipeline, [:0]const u8) void,
    };

    __vtable: *const VTable,

    device: *webgpu.Device,

    pub inline fn destroy(compute_pipeline: *ComputePipeline) void {
        compute_pipeline.__vtable.destroy_fn(compute_pipeline);
    }

    pub inline fn getBindGroupLayout(compute_pipeline: *ComputePipeline, group_index: u32) ?*webgpu.BindGroupLayout {
        return compute_pipeline.__vtable.get_bind_group_layout_fn(compute_pipeline, group_index);
    }

    pub inline fn setLabel(compute_pipeline: *ComputePipeline, label: [:0]const u8) void {
        compute_pipeline.__vtable.set_label_fn(compute_pipeline, label);
    }
};

pub const RenderPipeline = struct {
    pub const VTable = struct {
        destroy_fn: fn(*RenderPipeline) void,
        get_bind_group_layout_fn: fn(*RenderPipeline, u32) ?*webgpu.BindGroupLayout,
        set_label_fn: fn(*RenderPipeline, [:0]const u8) void,
    };

    __vtable: *const VTable,

    device: *webgpu.Device,

    pub inline fn destroy(render_pipeline: *RenderPipeline) void {
        render_pipeline.__vtable.destroy_fn(render_pipeline);
    }

    pub inline fn setBindGroupLayout(render_pipeline: *RenderPipeline, group_index: u32) ?*webgpu.BindGroupLayout {
        return render_pipeline.__vtable.get_bind_group_layout_fn(render_pipeline, group_index);
    }

    pub inline fn setLabel(render_pipeline: *RenderPipeline, label: [:0]const u8) void {
        return render_pipeline.__vtable.set_label_fn(render_pipeline, label);
    }
};

pub const ShaderModule = struct {
    pub const VTable = struct {
        destroy_fn: fn(*ShaderModule) void,
        get_compilation_info_fn: fn(*ShaderModule) GetCompilationInfoError!webgpu.CompilationInfo,
        set_label_fn: fn(*ShaderModule, [:0]const u8) void,
    };

    __vtable: *const VTable,

    device: *webgpu.Device,

    pub inline fn destroy(shader_module: *ShaderModule) void {
        return shader_module.__vtable.destroy_fn(shader_module);
    }

    pub const GetCompilationInfoError = error {
        Failed,
    };

    pub inline fn getCompilationInfo(shader_module: *ShaderModule) GetCompilationInfoError!webgpu.CompilationInfo {
        return shader_module.__vtable.get_compilation_info_fn(shader_module);
    }

    pub inline fn setLabel(shader_module: *ShaderModule, label: [:0]const u8) void {
        return shader_module.__vtable.set_label_fn(shader_module, label);
    }
};
