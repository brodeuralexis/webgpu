const std = @import("std");

const Allocator = std.mem.Allocator;

pub const Adapter = @import("Adapter.zig");
pub const BindGroup = @import("BindGroup.zig");
pub const BindGroupLayout = @import("BindGroupLayout.zig");
pub const Buffer = @import("Buffer.zig");
pub const CommandBuffer = @import("CommandBuffer.zig");
pub const CommandEncoder = @import("CommandEncoder.zig");
pub const ComputePassEncoder = @import("ComputePassEncoder.zig");
pub const ComputePipeline = @import("ComputePipeline.zig");
pub const Device = @import("Device.zig");
pub const Instance = @import("Instance.zig");
pub const PipelineLayout = @import("PipelineLayout.zig");
pub const QuerySet = @import("QuerySet.zig");
pub const Queue = @import("Queue.zig");
pub const RenderBundle = @import("RenderBundle.zig");
pub const RenderBundleEncoder = @import("RenderBundleEncoder.zig");
pub const RenderPassEncoder = @import("RenderPassEncoder.zig");
pub const RenderPipeline = @import("RenderPipeline.zig");
pub const Sampler = @import("Sampler.zig");
pub const ShaderModule = @import("ShaderModule.zig");
pub const Surface = @import("Surface.zig");
pub const SwapChain = @import("SwapChain.zig");
pub const Texture = @import("Texture.zig");
pub const TextureView = @import("TextureView.zig");

const webgpu = @import("webgpu-core");

pub fn init(allocator: Allocator) !webgpu.Instance {
    var instance = try Instance.create(allocator);
    errdefer instance.destroy();

    return instance.instance();
}

test "backend" {
    std.testing.refAllDecls(@This());
}
