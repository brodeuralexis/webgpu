const std = @import("std");

const Device = @This();

const webgpu = @import("core.zig");

ptr: *anyopaque,
vtable: *const VTable,

pub const VTable = struct {
    deinit: *const fn(*anyopaque) void,
    create_bind_group: *const fn(*anyopaque, webgpu.BindGroupDescriptor) CreateBindGroupError!webgpu.BindGroup,
    create_bind_group_layout: *const fn(*anyopaque, webgpu.BindGroupLayoutDescriptor) CreateBindGroupLayoutError!webgpu.BindGroupLayout,
    create_buffer: *const fn(*anyopaque, webgpu.BufferDescriptor) CreateBufferError!webgpu.Buffer,
    create_command_encoder: *const fn(*anyopaque, webgpu.CommandEncoderDescriptor) CreateCommandEncoderError!webgpu.CommandEncoder,
    create_compute_pipeline: *const fn(*anyopaque, webgpu.ComputePipelineDescriptor) CreateComputePipelineError!webgpu.ComputePipeline,
    create_pipeline_layout: *const fn(*anyopaque, webgpu.PipelineLayoutDescriptor) CreatePipelineLayoutError!webgpu.PipelineLayout,
    create_query_set: *const fn(*anyopaque, webgpu.QuerySetDescriptor) CreateQuerySetError!webgpu.QuerySet,
    create_render_bundle_encoder: *const fn(*anyopaque, webgpu.RenderBundleEncoderDescriptor) CreateRenderBundleEncoderError!webgpu.RenderBundleEncoder,
    create_render_pipeline: *const fn(*anyopaque, webgpu.RenderPipelineDescriptor) CreateRenderPipelineError!webgpu.RenderPipeline,
    create_sampler: *const fn(*anyopaque, webgpu.SamplerDescriptor) CreateSamplerError!webgpu.Sampler,
    create_shader_module: *const fn(*anyopaque, webgpu.ShaderModuleDescriptor) CreateShaderModuleError!webgpu.ShaderModule,
    create_swap_chain: *const fn(*anyopaque, webgpu.SwapChainDescriptor) CreateSwapChainError!webgpu.SwapChain,
    create_texture: *const fn(*anyopaque, webgpu.TextureDescriptor) CreateTextureError!webgpu.Texture,
    enumerate_features: *const fn(*anyopaque) []const webgpu.FeatureName,
    get_limits: *const fn(*anyopaque) webgpu.Limits,
    get_queue: *const fn(*anyopaque) webgpu.Queue,
    has_feature: *const fn(*anyopaque, webgpu.FeatureName) bool,
    set_label: *const fn(*anyopaque, ?[]const u8) void,
};

pub inline fn init(
    pointer: anytype,
    comptime deinit_fn: *const fn(@TypeOf(pointer)) void,
    comptime create_bind_group_fn: *const fn(@TypeOf(pointer), webgpu.BindGroupDescriptor) CreateBindGroupError!webgpu.BindGroup,
    comptime create_bind_group_layout_fn: *const fn(@TypeOf(pointer), webgpu.BindGroupLayoutDescriptor) CreateBindGroupLayoutError!webgpu.BindGroupLayout,
    comptime create_buffer_fn: *const fn(@TypeOf(pointer), webgpu.BufferDescriptor) CreateBufferError!webgpu.Buffer,
    comptime create_command_encoder_fn: *const fn(@TypeOf(pointer), webgpu.CommandEncoderDescriptor) CreateCommandEncoderError!webgpu.CommandEncoder,
    comptime create_compute_pipeline_fn: *const fn(@TypeOf(pointer), webgpu.ComputePipelineDescriptor) CreateComputePipelineError!webgpu.ComputePipeline,
    comptime create_pipeline_layout_fn: *const fn(@TypeOf(pointer), webgpu.PipelineLayoutDescriptor) CreatePipelineLayoutError!webgpu.PipelineLayout,
    comptime create_query_set_fn: *const fn(@TypeOf(pointer), webgpu.QuerySetDescriptor) CreateQuerySetError!webgpu.QuerySet,
    comptime create_render_bundle_encoder_fn: *const fn(@TypeOf(pointer), webgpu.RenderBundleEncoderDescriptor) CreateRenderBundleEncoderError!webgpu.RenderBundleEncoder,
    comptime create_render_pipeline_fn: *const fn(@TypeOf(pointer), webgpu.RenderPipelineDescriptor) CreateRenderPipelineError!webgpu.RenderPipeline,
    comptime create_sampler_fn: *const fn(@TypeOf(pointer), webgpu.SamplerDescriptor) CreateSamplerError!webgpu.Sampler,
    comptime create_shader_module_fn: *const fn(@TypeOf(pointer), webgpu.ShaderModuleDescriptor) CreateShaderModuleError!webgpu.ShaderModule,
    comptime create_swap_chain_fn: *const fn(@TypeOf(pointer), webgpu.SwapChainDescriptor) CreateSwapChainError!webgpu.SwapChain,
    comptime create_texture_fn: *const fn(@TypeOf(pointer), webgpu.TextureDescriptor) CreateTextureError!webgpu.Texture,
    comptime enumerate_features_fn: *const fn(@TypeOf(pointer)) []const webgpu.FeatureName,
    comptime get_limits_fn: *const fn(@TypeOf(pointer)) webgpu.Limits,
    comptime get_queue_fn: *const fn(@TypeOf(pointer)) webgpu.Queue,
    comptime has_feature_fn: *const fn(@TypeOf(pointer), webgpu.FeatureName) bool,
    comptime set_label_fn: *const fn(@TypeOf(pointer), ?[]const u8) void,
) Device {
    const Ptr = @TypeOf(pointer);
    const ptr_info = @typeInfo(Ptr);

    std.debug.assert(ptr_info == .Pointer);
    std.debug.assert(ptr_info.Pointer.size == .One);

    const alignment = ptr_info.Pointer.alignment;

    const gen = struct {
        fn deinitImpl(ptr: *anyopaque) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return deinit_fn(self);
        }

        fn createBindGroupImpl(ptr: *anyopaque, descriptor: webgpu.BindGroupDescriptor) CreateBindGroupError!webgpu.BindGroup {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return create_bind_group_fn(self, descriptor);
        }

        fn createBindGroupLayoutImpl(ptr: *anyopaque, descriptor: webgpu.BindGroupLayoutDescriptor) CreateBindGroupLayoutError!webgpu.BindGroupLayout {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return create_bind_group_layout_fn(self, descriptor);
        }

        fn createBufferImpl(ptr: *anyopaque, descriptor: webgpu.BufferDescriptor) CreateBufferError!webgpu.Buffer {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return create_buffer_fn(self, descriptor);
        }

        fn createCommandEncoderImpl(ptr: *anyopaque, descriptor: webgpu.CommandEncoderDescriptor) CreateCommandEncoderError!webgpu.CommandEncoder {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return create_command_encoder_fn(self, descriptor);
        }

        fn createComputePipelineImpl(ptr: *anyopaque, descriptor: webgpu.ComputePipelineDescriptor) CreateComputePipelineError!webgpu.ComputePipeline {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return create_compute_pipeline_fn(self, descriptor);
        }

        fn createPipelineLayoutImpl(ptr: *anyopaque, descriptor: webgpu.PipelineLayoutDescriptor) CreatePipelineLayoutError!webgpu.PipelineLayout {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return create_pipeline_layout_fn(self, descriptor);
        }

        fn createQuerySetImpl(ptr: *anyopaque, descriptor: webgpu.QuerySetDescriptor) CreateQuerySetError!webgpu.QuerySet {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return create_query_set_fn(self, descriptor);
        }

        fn createRenderBundleEncoderImpl(ptr: *anyopaque, descriptor: webgpu.RenderBundleEncoderDescriptor) CreateRenderBundleEncoderError!webgpu.RenderBundleEncoder {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return create_render_bundle_encoder_fn(self, descriptor);
        }

        fn createRenderPipelineImpl(ptr: *anyopaque, descriptor: webgpu.RenderPipelineDescriptor) CreateRenderPipelineError!webgpu.RenderPipeline {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return create_render_pipeline_fn(self, descriptor);
        }

        fn createSamplerImpl(ptr: *anyopaque, descriptor: webgpu.SamplerDescriptor) CreateSamplerError!webgpu.Sampler {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return create_sampler_fn(self, descriptor);
        }

        fn createShaderModuleImpl(ptr: *anyopaque, descriptor: webgpu.ShaderModuleDescriptor) CreateShaderModuleError!webgpu.ShaderModule {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return create_shader_module_fn(self, descriptor);
        }

        fn createSwapChainImpl(ptr: *anyopaque, descriptor: webgpu.SwapChainDescriptor) CreateSwapChainError!webgpu.SwapChain {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return create_swap_chain_fn(self, descriptor);
        }

        fn createTextureImpl(ptr: *anyopaque, descriptor: webgpu.TextureDescriptor) CreateTextureError!webgpu.Texture {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return create_texture_fn(self, descriptor);
        }

        fn enumerateFeaturesImpl(ptr: *anyopaque) []const webgpu.FeatureName {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return enumerate_features_fn(self);
        }

        fn getLimitsImpl(ptr: *anyopaque) webgpu.Limits {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return get_limits_fn(self);
        }

        fn getQueueImpl(ptr: *anyopaque) webgpu.Queue {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return get_queue_fn(self);
        }

        fn hasFeatureImpl(ptr: *anyopaque, feature_name: webgpu.FeatureName) bool {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return has_feature_fn(self, feature_name);
        }

        fn setLabelImpl(ptr: *anyopaque, label: ?[]const u8) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return set_label_fn(self, label);
        }

        const vtable = VTable{
            .deinit = deinitImpl,
            .create_bind_group = createBindGroupImpl,
            .create_bind_group_layout = createBindGroupLayoutImpl,
            .create_buffer = createBufferImpl,
            .create_command_encoder = createCommandEncoderImpl,
            .create_compute_pipeline = createComputePipelineImpl,
            .create_pipeline_layout = createPipelineLayoutImpl,
            .create_query_set = createQuerySetImpl,
            .create_render_bundle_encoder = createRenderBundleEncoderImpl,
            .create_render_pipeline = createRenderPipelineImpl,
            .create_sampler = createSamplerImpl,
            .create_shader_module = createShaderModuleImpl,
            .create_swap_chain = createSwapChainImpl,
            .create_texture = createTextureImpl,
            .enumerate_features = enumerateFeaturesImpl,
            .get_limits = getLimitsImpl,
            .get_queue = getQueueImpl,
            .has_feature = hasFeatureImpl,
            .set_label = setLabelImpl,
        };
    };

    return Device{
        .ptr = pointer,
        .vtable = &gen.vtable,
    };
}

pub inline fn deinit(device: Device) void {
    return device.vtable.deinit(device.ptr);
}

pub const CreateBindGroupError = error {
    OutOfMemory,
};

pub inline fn createBindGroup(device: Device, descriptor: webgpu.BindGroupDescriptor) CreateBindGroupError!webgpu.BindGroup {
    return device.vtable.create_bind_group(device.ptr, descriptor);
}

pub const CreateBindGroupLayoutError = error {
    OutOfMemory,
};

pub inline fn createBindGroupLayout(device: Device, descriptor: webgpu.BindGroupLayoutDescriptor) CreateBindGroupLayoutError!webgpu.BindGroupLayout {
    return device.vtable.create_bind_group_layout(device.ptr, descriptor);
}

pub const CreateBufferError = error {
    OutOfMemory,
};

pub inline fn createBuffer(device: Device, descriptor: webgpu.BufferDescriptor) CreateBufferError!webgpu.Buffer {
    return device.vtable.create_buffer(device.ptr, descriptor);
}

pub const CreateCommandEncoderError = error {
    OutOfMemory,
};

pub inline fn createCommandEncoder(device: Device, descriptor: webgpu.CommandEncoderDescriptor) CreateCommandEncoderError!webgpu.CommandEncoder {
    return device.vtable.create_command_encoder(device.ptr, descriptor);
}

pub const CreateComputePipelineError = error {
    OutOfMemory,
};

pub inline fn createComputePipeline(device: Device, descriptor: webgpu.ComputePipelineDescriptor) CreateComputePipelineError!webgpu.ComputePipeline {
    return device.vtable.create_compute_pipeline(device.ptr, descriptor);
}

pub const CreatePipelineLayoutError = error {
    OutOfMemory,
};

pub inline fn createPipelineLayout(device: Device, descriptor: webgpu.PipelineLayoutDescriptor) CreatePipelineLayoutError!webgpu.PipelineLayout {
    return device.vtable.create_pipeline_layout(device.ptr, descriptor);
}

pub const CreateQuerySetError = error {
    OutOfMemory,
};

pub inline fn createQuerySet(device: Device, descriptor: webgpu.QuerySetDescriptor) CreateQuerySetError!webgpu.QuerySet {
    return device.vtable.create_query_set(device.ptr, descriptor);
}

pub const CreateRenderBundleEncoderError = error {
    OutOfMemory,
};

pub inline fn createRenderBundleEncoder(device: Device, descriptor: webgpu.RenderBundleEncoderDescriptor) CreateRenderBundleEncoderError!webgpu.RenderBundleEncoder {
    return device.vtable.create_render_bundle_encoder(device.ptr, descriptor);
}

pub const CreateRenderPipelineError = error {
    OutOfMemory,
};

pub inline fn createREnderPipeline(device: Device, descriptor: webgpu.RenderPipelineDescriptor) CreateRenderPipelineError!webgpu.RenderPipeline {
    return device.vtable.create_render_pipeline(device.ptr, descriptor);
}

pub const CreateSamplerError = error {
    OutOfMemory,
};

pub inline fn createSampler(device: Device, descriptor: webgpu.SamplerDescriptor) CreateSamplerError!webgpu.Sampler {
    return device.vtable.create_sampler(device.ptr, descriptor);
}

pub const CreateShaderModuleError = error {
    OutOfMemory,
};

pub inline fn createShaderModule(device: Device, descriptor: webgpu.ShaderModuleDescriptor) CreateShaderModuleError!webgpu.ShaderModule {
    return device.vtable.create_shader_module(device.ptr, descriptor);
}

pub const CreateSwapChainError = error {
    OutOfMemory,
};

pub inline fn createSwapChain(device: Device, descriptor: webgpu.SwapChainDescriptor) CreateSwapChainError!webgpu.SwapChain {
    return device.vtable.create_swap_chain(device.ptr, descriptor);
}

pub const CreateTextureError = error {
    OutOfMemory,
};

pub inline fn createTexture(device: Device, descriptor: webgpu.TextureDescriptor) CreateTextureError!webgpu.Texture {
    return device.vtable.create_texture(device.ptr, descriptor);
}

pub inline fn enumerateFeatures(device: Device) []const webgpu.FeatureName {
    return device.vtable.enumerate_features(device.ptr);
}

pub inline fn getLimits(device: Device) webgpu.Limits {
    return device.vtable.get_limits(device.ptr);
}

pub inline fn getQueue(device: Device) webgpu.Queue {
    return device.vtable.get_queue(device.ptr);
}

pub inline fn hasFeature(device: Device, feature_name: webgpu.FeatureName) bool {
    return device.vtable.has_feature(device.ptr, feature_name);
}

pub inline fn setLabel(device: Device, label: ?[]const u8) void {
    return device.vtable.set_label(device.ptr, label);
}
