const std = @import("std");

const Allocator = std.mem.Allocator;

const webgpu = @import("../../webgpu.zig");
const dummy = @import("./dummy.zig");

pub const Device = struct {
    const vtable = webgpu.Device.VTable{
        .destroy_fn = destroy,

        .create_buffer_fn = createBuffer,
        .create_texture_fn = createTexture,
        .create_sampler_fn = createSampler,

        .create_bind_group_layout_fn = createBindGroupLayout,
        .create_pipeline_layout_fn = createPipelineLayout,
        .create_bind_group_fn = createBindGroup,

        .create_shader_module_fn = createShaderModule,
        .create_compute_pipeline_fn = createComputePipeline,
        .create_render_pipeline_fn = createRenderPipeline,

        .create_command_encoder_fn = createCommandEncoder,
        .create_render_bundle_encoder_fn = createRenderBundleEncoder,
    };

    super: webgpu.Device,

    allocator: Allocator,

    queue: *Queue,

    pub fn create(adapter: *dummy.Adapter, descriptor: webgpu.DeviceDescriptor) webgpu.Adapter.RequestDeviceError!*Device {
        var instance = @fieldParentPtr(dummy.Instance, "super", adapter.super.instance);

        _ = descriptor;

        var device = try instance.allocator.create(Device);
        errdefer instance.allocator.destroy(device);

        device.super = .{
            .__vtable = &vtable,
            .instance = &instance.super,
            .adapter = &adapter.super,
            .features = .{},
            .limits = .{},
            .queue = undefined,
        };

        device.allocator = instance.allocator;

        device.queue = try Queue.create(device);
        errdefer device.queue.destroy(device);
        device.super.queue = &device.queue.super;

        return device;
    }

    fn destroy(super: *webgpu.Device) void {
        var device = @fieldParentPtr(Device, "super", super);

        device.queue.destroy(device);
        device.allocator.destroy(device);
    }

    fn createBuffer(super: *webgpu.Device, descriptor: webgpu.BufferDescriptor) webgpu.Device.CreateBufferError!*webgpu.Buffer {
        var device = @fieldParentPtr(Device, "super", super);

        var buffer = try dummy.Buffer.create(device, descriptor);

        return &buffer.super;
    }

    fn createTexture(super: *webgpu.Device, descriptor: webgpu.TextureDescriptor) webgpu.Device.CreateTextureError!*webgpu.Texture {
        var device = @fieldParentPtr(Device, "super", super);

        var texture = try dummy.Texture.create(device, descriptor);

        return &texture.super;
    }

    fn createSampler(super: *webgpu.Device, descriptor: webgpu.SamplerDescriptor) webgpu.Device.CreateSamplerError!*webgpu.Sampler {
        var device = @fieldParentPtr(Device, "super", super);

        var sampler = try dummy.Sampler.create(device, descriptor);

        return &sampler.super;
    }

    fn createBindGroupLayout(super: *webgpu.Device, descriptor: webgpu.BindGroupLayoutDescriptor) webgpu.Device.CreateBindGroupLayoutError!*webgpu.BindGroupLayout {
        var device = @fieldParentPtr(Device, "super", super);

        var bind_group_layout = try dummy.BindGroupLayout.create(device, descriptor);

        return &bind_group_layout.super;
    }

    fn createPipelineLayout(super: *webgpu.Device, descriptor: webgpu.PipelineLayoutDescriptor) webgpu.Device.CreatePipelineLayoutError!*webgpu.PipelineLayout {
        var device = @fieldParentPtr(Device, "super", super);

        var pipeline_layout = try dummy.PipelineLayout.create(device, descriptor);

        return &pipeline_layout.super;
    }

    fn createBindGroup(super: *webgpu.Device, descriptor: webgpu.BindGroupDescriptor) webgpu.Device.CreateBindGroupError!*webgpu.BindGroup {
        var device = @fieldParentPtr(Device, "super", super);

        var bind_group = try dummy.BindGroup.create(device, descriptor);

        return &bind_group.super;
    }

    fn createShaderModule(super: *webgpu.Device, descriptor: webgpu.ShaderModuleDescriptor) webgpu.Device.CreateShaderModuleError!*webgpu.ShaderModule {
        var device = @fieldParentPtr(Device, "super", super);

        var shader_module = try dummy.ShaderModule.create(device, descriptor);

        return &shader_module.super;
    }

    fn createComputePipeline(super: *webgpu.Device, descriptor: webgpu.ComputePipelineDescriptor) webgpu.Device.CreateComputePipelineError!*webgpu.ComputePipeline {
        var device = @fieldParentPtr(Device, "super", super);

        var compute_pipeline = try dummy.ComputePipeline.create(device, descriptor);

        return &compute_pipeline.super;
    }

    fn createRenderPipeline(super: *webgpu.Device, descriptor: webgpu.RenderPipelineDescriptor) webgpu.Device.CreateRenderPipelineError!*webgpu.RenderPipeline {
        var device = @fieldParentPtr(Device, "super", super);

        var render_pipeline = try dummy.RenderPipeline.create(device, descriptor);

        return &render_pipeline.super;
    }

    fn createCommandEncoder(super: *webgpu.Device, descriptor: webgpu.CommandEncoderDescriptor) webgpu.Device.CreateCommandEncoderError!*webgpu.CommandEncoder {
        var device = @fieldParentPtr(Device, "super", super);

        var command_encoder = try dummy.CommandEncoder.create(device, descriptor);

        return &command_encoder.super;
    }

    fn createRenderBundleEncoder(super: *webgpu.Device, descriptor: webgpu.RenderBundleEncoderDescriptor) webgpu.Device.CreateRenderBundleEncoderError!*webgpu.RenderBundleEncoder {
        var device = @fieldParentPtr(Device, "super", super);

        var render_bundle_encoder = try dummy.RenderBundleEncoder.create(device, descriptor);

        return &render_bundle_encoder.super;
    }
};

pub const Queue = struct {
    const vtable = webgpu.Queue.VTable{
        .submit_fn = submit,
        .on_submitted_work_done_fn = onSubmittedWorkDone,
        .write_buffer_fn = writeBuffer,
        .write_texture_fn = writeTexture,
    };

    super: webgpu.Queue,

    pub fn create(device: *Device) webgpu.Adapter.RequestDeviceError!*Queue {
        var queue = try device.allocator.create(Queue);
        errdefer device.allocator.destroy(queue);

        queue.super = .{
            .__vtable = &vtable,
        };

        return queue;
    }

    pub fn destroy(queue: *Queue, device: *Device) void {
        device.allocator.destroy(queue);
    }

    fn submit(super: *webgpu.Queue, command_buffers: []webgpu.CommandBuffer) webgpu.Queue.SubmitError!void {
        _ = super;
        _ = command_buffers;
    }

    fn onSubmittedWorkDone(super: *webgpu.Queue) void {
        _ = super;
    }

    fn writeBuffer(super: *webgpu.Queue, buffer: *webgpu.Buffer, buffer_offset: usize, data: []const u8) webgpu.Queue.WriteBufferError!void {
        _ = super;
        _ = buffer;
        _ = buffer_offset;
        _ = data;
    }

    fn writeTexture(super: *webgpu.Queue, destination: webgpu.ImageCopyTexture, data: []const u8, data_layout: webgpu.TextureDataLayout, write_size: webgpu.Extend3D) webgpu.Queue.WriteTextureError!void {
        _ = super;
        _ = destination;
        _ = data;
        _ = data_layout;
        _ = write_size;
    }
};
