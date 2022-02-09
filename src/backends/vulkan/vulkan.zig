const std = @import("std");

const webgpu = @import("../../webgpu.zig");

pub usingnamespace @import("./constants.zig");

pub const BindGroup = @import("./binding_model/BindGroup.zig");
pub const BindGroupLayout = @import("./binding_model/BindGroupLayout.zig");
pub const PipelineLayout = @import("./binding_model/PipelineLayout.zig");

pub const CommandBuffer = @import("./command/CommandBuffer.zig");
pub const CommandEncoder = @import("./command/CommandEncoder.zig");
pub const ComputePassEncoder = @import("./command/ComputePassEncoder.zig");
pub const RenderBundle = @import("./command/RenderBundle.zig");
pub const RenderBundleEncoder = @import("./command/RenderBundleEncoder.zig");
pub const RenderPassEncoder = @import("./command/RenderPassEncoder.zig");

pub const Device = @import("./device/Device.zig");
pub const Queue = @import("./device/Queue.zig");

pub const Instance = @import("./instance/Instance.zig");
pub const Adapter = @import("./instance/Adapter.zig");

pub const ComputePipeline = @import("./pipeline/ComputePipeline.zig");
pub const RenderPipeline = @import("./pipeline/RenderPipeline.zig");
pub const ShaderModule = @import("./pipeline/ShaderModule.zig");

pub const Buffer = @import("./resource/Buffer.zig");
pub const QuerySet = @import("./resource/QuerySet.zig");
pub const Sampler = @import("./resource/Sampler.zig");
pub const SwapChain = @import("./resource/SwapChain.zig");
pub const Texture = @import("./resource/Texture.zig");
pub const TextureView = @import("./resource/TextureView.zig");

pub fn create(descriptor: webgpu.InstanceDescriptor) webgpu.Instance.CreateError!*webgpu.Instance {
    var instance = Instance.create(descriptor)
        catch return error.Failed;
    errdefer instance.super.destroy();

    return &instance.super;
}
