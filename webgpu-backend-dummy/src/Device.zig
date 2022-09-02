const std = @import("std");

const Device = @This();

const backend = @import("backend.zig");
const webgpu = @import("webgpu-core");

adapter: *backend.Adapter,
queue: *backend.Queue,

pub fn create(adapter: *backend.Adapter, descriptor: webgpu.DeviceDescriptor) !*Device {
    var self = try adapter.instance.allocator.create(Device);
    errdefer adapter.instance.allocator.destroy(self);

    self.adapter = adapter;
    self.queue = try backend.Queue.create(self, descriptor.default_queue);
    errdefer self.queue.destroy();

    return self;
}

pub inline fn device(self: *Device) webgpu.Device {
    return webgpu.Device.init(
        self,
        destroy,
        createBindGroup,
        createBindGroupLayout,
        createBuffer,
        createCommandEncoder,
        createComputePipeline,
        createPipelineLayout,
        createQuerySet,
        createRenderBundleEncoder,
        createRenderPipeline,
        createSampler,
        createShaderModule,
        createSwapChain,
        createTexture,
        enumerateFeatures,
        getLimits,
        getQueue,
        hasFeature,
        setLabel,
    );
}

pub inline fn from(ptr: *anyopaque) *Device {
    return @ptrCast(*Device, @alignCast(@alignOf(Device), ptr));
}

pub fn destroy(self: *Device) void {
    self.queue.destroy();
    self.adapter.instance.allocator.destroy(self);
}

fn createBindGroup(self: *Device, descriptor: webgpu.BindGroupDescriptor) webgpu.Device.CreateBindGroupError!webgpu.BindGroup {
    var bind_group = try backend.BindGroup.create(self, descriptor);
    errdefer bind_group.destroy();

    return bind_group.bindGroup();
}

fn createBindGroupLayout(self: *Device, descriptor: webgpu.BindGroupLayoutDescriptor) webgpu.Device.CreateBindGroupLayoutError!webgpu.BindGroupLayout {
    var bind_group_layout = try backend.BindGroupLayout.create(self, descriptor);
    errdefer bind_group_layout.destroy();

    return bind_group_layout.bindGroupLayout();
}

fn createBuffer(self: *Device, descriptor: webgpu.BufferDescriptor) webgpu.Device.CreateBufferError!webgpu.Buffer {
    var buffer = try backend.Buffer.create(self, descriptor);
    errdefer buffer.destroy();

    return buffer.buffer();
}

fn createCommandEncoder(self: *Device, descriptor: webgpu.CommandEncoderDescriptor) webgpu.Device.CreateCommandEncoderError!webgpu.CommandEncoder {
    var command_encoder = try backend.CommandEncoder.create(self, descriptor);
    errdefer command_encoder.destroy();

    return command_encoder.commandEncoder();
}

fn createComputePipeline(self: *Device, descriptor: webgpu.ComputePipelineDescriptor) webgpu.Device.CreateComputePipelineError!webgpu.ComputePipeline {
    var compute_pipeline = try backend.ComputePipeline.create(self, descriptor);
    errdefer compute_pipeline.destroy();

    return compute_pipeline.computePipeline();
}

fn createPipelineLayout(self: *Device, descriptor: webgpu.PipelineLayoutDescriptor) webgpu.Device.CreatePipelineLayoutError!webgpu.PipelineLayout {
    var pipeline_layout = try backend.PipelineLayout.create(self, descriptor);
    errdefer pipeline_layout.destroy();

    return pipeline_layout.pipelineLayout();
}

fn createQuerySet(self: *Device, descriptor: webgpu.QuerySetDescriptor) webgpu.Device.CreateQuerySetError!webgpu.QuerySet {
    var query_set = try backend.QuerySet.create(self, descriptor);
    errdefer query_set.destroy();

    return query_set.querySet();
}

fn createRenderBundleEncoder(self: *Device, descriptor: webgpu.RenderBundleEncoderDescriptor) webgpu.Device.CreateRenderBundleEncoderError!webgpu.RenderBundleEncoder {
    var render_bundle_encoder= try backend.RenderBundleEncoder.create(self, descriptor);
    errdefer render_bundle_encoder.destroy();

    return render_bundle_encoder.renderBundleEncoder();
}

fn createRenderPipeline(self: *Device, descriptor: webgpu.RenderPipelineDescriptor) webgpu.Device.CreateRenderPipelineError!webgpu.RenderPipeline {
    var render_pipeline = try backend.RenderPipeline.create(self, descriptor);
    errdefer render_pipeline.destroy();

    return render_pipeline.renderPipeline();
}

fn createSampler(self: *Device, descriptor: webgpu.SamplerDescriptor) webgpu.Device.CreateSamplerError!webgpu.Sampler {
    var sampler = try backend.Sampler.create(self, descriptor);
    errdefer sampler.destroy();

    return sampler.sampler();
}

fn createShaderModule(self: *Device, descriptor: webgpu.ShaderModuleDescriptor) webgpu.Device.CreateShaderModuleError!webgpu.ShaderModule {
    var shader_module = try backend.ShaderModule.create(self, descriptor);
    errdefer shader_module.destroy();

    return shader_module.shaderModule();
}

pub fn createSwapChain(self: *Device, descriptor: webgpu.SwapChainDescriptor) webgpu.Device.CreateSwapChainError!webgpu.SwapChain {
    var swap_chain = try backend.SwapChain.create(self, descriptor);
    errdefer swap_chain.destroy();

    return swap_chain.swapChain();
}

pub fn createTexture(self: *Device, descriptor: webgpu.TextureDescriptor) webgpu.Device.CreateTextureError!webgpu.Texture {
    var texture = try backend.Texture.create(self, descriptor);
    errdefer texture.destroy();

    return texture.texture();
}

pub fn enumerateFeatures(self: *Device) []const webgpu.FeatureName {
    _ = self;

    return &[0]webgpu.FeatureName{};
}

pub fn getLimits(self: *Device) webgpu.Limits {
    _ = self;

    return std.mem.zeroes(webgpu.Limits);
}

pub fn getQueue(self: *Device) webgpu.Queue {
    return self.queue.queue();
}

pub fn hasFeature(self: *Device, feature_name: webgpu.FeatureName) bool {
    _ = self;
    _ = feature_name;

    return false;
}

pub fn setLabel(self: *Device, label: ?[]const u8) void {
    _ = self;
    _ = label;
}
