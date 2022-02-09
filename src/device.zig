const std = @import("std");
const webgpu = @import("./webgpu.zig");

pub const Device = struct {
    pub const VTable = struct {
        destroy_fn: fn(*Device) void,

        create_buffer_fn: fn(*Device, webgpu.BufferDescriptor) CreateBufferError!*webgpu.Buffer,
        create_texture_fn: fn(*Device, webgpu.TextureDescriptor) CreateTextureError!*webgpu.Texture,
        create_sampler_fn: fn(*Device, webgpu.SamplerDescriptor) CreateSamplerError!*webgpu.Sampler,

        create_bind_group_layout_fn: fn(*Device, webgpu.BindGroupLayoutDescriptor) CreateBindGroupLayoutError!*webgpu.BindGroupLayout,
        create_pipeline_layout_fn: fn(*Device, webgpu.PipelineLayoutDescriptor) CreatePipelineLayoutError!*webgpu.PipelineLayout,
        create_bind_group_fn: fn(*Device, webgpu.BindGroupDescriptor) CreateBindGroupError!*webgpu.BindGroup,

        create_shader_module_fn: fn(*Device, webgpu.ShaderModuleDescriptor) CreateShaderModuleError!*webgpu.ShaderModule,
        create_compute_pipeline_fn: fn(*Device, webgpu.ComputePipelineDescriptor) CreateComputePipelineError!*webgpu.ComputePipeline,
        create_render_pipeline_fn: fn(*Device, webgpu.RenderPipelineDescriptor) CreateRenderPipelineError!*webgpu.RenderPipeline,

        create_command_encoder_fn: fn(*Device, webgpu.CommandEncoderDescriptor) CreateCommandEncoderError!*webgpu.CommandEncoder,
        create_render_bundle_encoder_fn: fn(*Device, webgpu.RenderBundleEncoderDescriptor) CreateRenderBundleEncoderError!*webgpu.RenderBundleEncoder,
    };

    __vtable: *const VTable,

    features: *const webgpu.Features,
    limits: *const webgpu.Limits,

    queue: *Queue,

    pub inline fn destroy(device: *Device) void {
        device.__vtable.destroy_fn(device);
    }

    pub const CreateBufferError = error {
        OutOfMemory,
        Failed,
    };

    pub inline fn createBuffer(device: *Device, descriptor: webgpu.BufferDescriptor) CreateBufferError!*webgpu.Buffer {
        return device.__vtable.create_buffer_fn(device, descriptor);
    }

    pub const CreateTextureError = error {
        OutOfMemory,
        Failed,
    };

    pub inline fn createTexture(device: *Device, descriptor: webgpu.TextureDescriptor) CreateTextureError!*webgpu.Texture {
        return device.__vtable.create_texture_fn(device, descriptor);
    }

    pub const CreateSamplerError = error {
        OutOfMemory,
        Failed,
    };

    pub inline fn createSampler(device: *Device, descriptor: webgpu.SamplerDescriptor) CreateSamplerError!*webgpu.Sampler {
        return device.__vtable.create_sampler_fn(device, descriptor);
    }

    pub const CreateBindGroupLayoutError = error {
        OutOfMemory,
        Failed,
    };

    pub inline fn createBindGroupLayout(device: *Device, descriptor: webgpu.BindGroupLayoutDescriptor) CreateBindGroupLayoutError!*webgpu.BindGroupLayout {
        return device.__vtable.create_bind_group_layout_fn(device, descriptor);
    }

    pub const CreatePipelineLayoutError = error {
        OutOfMemory,
        Failed,
    };

    pub inline fn createPipelineLayout(device: *Device, descriptor: webgpu.PipelineLayoutDescriptor) CreatePipelineLayoutError!*webgpu.PipelineLayout {
        return device.__vtable.create_pipeline_layout_fn(device, descriptor);
    }

    pub const CreateBindGroupError = error {
        OutOfMemory,
        Failed,
    };

    pub inline fn createBindGroup(device: *Device, descriptor: webgpu.BindGroupDescriptor) CreateBindGroupError!*webgpu.BindGroup {
        return device.__vtable.create_bind_group_fn(device, descriptor);
    }

    pub const CreateShaderModuleError = error {
        OutOfMemory,
        Failed,
    };

    pub inline fn createShaderModule(device: *Device, descriptor: webgpu.ShaderModuleDescriptor) CreateShaderModuleError!*webgpu.ShaderModule {
        return device.__vtable.create_shader_module_fn(device, descriptor);
    }

    pub const CreateComputePipelineError = error {
        OutOfMemory,
        Failed,
    };

    pub inline fn createComputePipeline(device: *Device, descriptor: webgpu.ComputePipelineDescriptor) CreateComputePipelineError!*webgpu.ComputePipeline {
        return device.__vtable.create_compute_pipeline_fn(device, descriptor);
    }

    pub const CreateRenderPipelineError = error {
        OutOfMemory,
        Failed,
    };

    pub inline fn createRenderPipeline(device: *Device, descriptor: webgpu.RenderPipelineDescriptor) CreateRenderPipelineError!*webgpu.RenderPipeline {
        return device.__vtable.create_render_pipeline_fn(device, descriptor);
    }

    pub const CreateCommandEncoderError = error {
        OutOfMemory,
        Failed,
    };

    pub inline fn createCommandEncoder(device: *Device, descriptor: webgpu.CommandEncoderDescriptor) CreateCommandEncoderError!*webgpu.CommandEncoder {
        return device.__vtable.create_command_encoder_fn(device, descriptor);
    }

    pub const CreateRenderBundleEncoderError = error {
        OutOfMemory,
        Failed,
    };

    pub inline fn createRenderBundleEncoder(device: *Device, descriptor: webgpu.RenderBundleEncoderDescriptor) CreateRenderBundleEncoderError!*webgpu.RenderBundleEncoder {
        return device.__vtable.create_render_bundle_encoder_fn(device, descriptor);
    }
};

pub const Queue = struct {
    pub const VTable = struct {
        submit_fn: fn(*Queue, []webgpu.CommandBuffer) SubmitError!void,
        on_submitted_work_done_fn: fn(*Queue) void,
        write_buffer_fn: fn(*Queue, *webgpu.Buffer, usize, []const u8) WriteBufferError!void,
        write_texture_fn: fn(*Queue, webgpu.ImageCopyTexture, []const u8, webgpu.TextureDataLayout, webgpu.Extend3D) WriteTextureError!void,
    };

    __vtable: *const VTable,

    pub const SubmitError = error {
        OutOfMemory,
        Failed,
    };

    pub inline fn submit(queue: *Queue, command_buffers: []webgpu.CommandBuffer) SubmitError!void {
        return queue.__vtable.submit_fn(queue, command_buffers);
    }

    pub const OnSubmittedWorkDoneError = error {};

    pub inline fn onSubmittedWorkDone(queue: *Queue) OnSubmittedWorkDoneError!void {
        return queue.__vtable.on_submitted_work_done_fn(queue);
    }

    pub const WriteBufferError = error {
        Failed,
    };

    pub inline fn writeBuffer(queue: *Queue, buffer: *webgpu.Buffer, buffer_offset: usize, data: []const u8) WriteBufferError!void {
        return queue.__vtable.write_buffer_fn(queue, buffer, buffer_offset, data);
    }

    pub const WriteTextureError = error {
        Failed,
    };

    pub inline fn writeTexture(queue: *Queue, destination: webgpu.ImageCopyTexture, data: []const u8, data_layout: webgpu.TextureDataLayout, size: webgpu.Extend3D) WriteTextureError!void {
        return queue.__vtable.write_texture_fn(queue, destination, data, data_layout, size);
    }
};
