const std = @import("std");

const webgpu = @import("../../webgpu.zig");
const dummy = @import("./dummy.zig");

pub const Buffer = struct {
    const vtable = webgpu.Buffer.VTable{
        .destroy_fn = destroy,
        .get_const_mapped_range_fn = getConstMappedRange,
        .get_mapped_range_fn = getMappedRange,
        .map_async_fn = mapAsync,
        .unmap_fn = unmap,
    };

    super: webgpu.Buffer,

    device: *dummy.Device,

    data: []align(16) u8,

    pub fn create(device: *dummy.Device, descriptor: webgpu.BufferDescriptor) webgpu.Device.CreateBufferError!*Buffer {
        var buffer = try device.allocator.create(Buffer);
        errdefer device.allocator.destroy(buffer);

        buffer.super.__vtable = &vtable;

        buffer.device = device;

        buffer.data = try device.allocator.allocAdvanced(u8, 16, descriptor.size, .at_least);
        errdefer device.allocator.free(buffer.data);

        return buffer;
    }

    fn destroy(super: *webgpu.Buffer) void {
        var buffer = @fieldParentPtr(Buffer, "super", super);

        buffer.device.allocator.free(buffer.data);
        buffer.device.allocator.destroy(buffer);
    }

    fn getConstMappedRange(super: *webgpu.Buffer, offset: usize, size: usize) webgpu.Buffer.GetConstMappedRangeError![]align(16) const u8 {
        var buffer = @fieldParentPtr(Buffer, "super", super);

        if (offset + size > buffer.data.len) {
            return error.Failed;
        }

        return buffer.data[offset..(offset + size)];
    }

    fn getMappedRange(super: *webgpu.Buffer, offset: usize, size: usize) webgpu.Buffer.GetMappedRangeError![]align(16) u8 {
        var buffer = @fieldParentPtr(Buffer, "super", super);

        if (offset + size > buffer.data.len) {
            return error.Failed;
        }

        return buffer.data[offset..(offset + size)];
    }

    fn mapAsync(super: *webgpu.Buffer, mode: webgpu.MapMode, offset: usize, size: usize) webgpu.Buffer.MapAsyncError!void {
        _ = super;
        _ = mode;
        _ = offset;
        _ = size;
    }

    fn unmap(super: *webgpu.Buffer) webgpu.Buffer.UnmapError!void {
        _ = super;
    }
};

pub const QuerySet = struct {
    const vtable = webgpu.QuerySet.VTable{
        .destroy_fn = destroy,
    };

    super: webgpu.QuerySet,

    device: *dummy.Device,

    pub fn create(device: *dummy.Device, descriptor: webgpu.QuerySetDescriptor) dummy.Device.CreateQuerySetError!*QuerySet {
        _ = descriptor;

        var query_set = try device.allocator.create(QuerySet);
        errdefer device.allocator.destroy(query_set);

        query_set.super.__vtable = &vtable;

        query_set.device = device;

        return query_set;
    }

    fn destroy(super: *webgpu.QuerySet) void {
        var query_set = @fieldParentPtr(QuerySet, "super", super);

        query_set.device.allocator.destroy(query_set);
    }
};

pub const Sampler = struct {
    const vtable = webgpu.Sampler.VTable{
        .destroy_fn = destroy,
    };

    super: webgpu.Sampler,

    device: *dummy.Device,

    pub fn create(device: *dummy.Device, descriptor: webgpu.SamplerDescriptor) webgpu.Device.CreateSamplerError!*Sampler {
        _ = descriptor;

        var sampler = try device.allocator.create(Sampler);
        errdefer device.allocator.destroy(sampler);

        sampler.super.__vtable = &vtable;

        sampler.device = device;

        return sampler;
    }

    fn destroy(super: *webgpu.Sampler) void {
        var sampler = @fieldParentPtr(Sampler, "super", super);

        sampler.device.allocator.destroy(sampler);
    }
};

pub const SwapChain = struct {
    const vtable = webgpu.SwapChain.VTable{
        .destroy_fn = destroy,
        .get_current_texture_view_fn = getCurrentTextureView,
    };

    super: webgpu.SwapChain,

    device: *dummy.Device,

    texture_view: *TextureView,

    pub fn create(device: *dummy.Device, descriptor: webgpu.SwapChainDescriptor) webgpu.Device.CreateSwapChainError!*SwapChain {
        _ = descriptor;

        var swap_chain = try device.allocator.create(SwapChain);
        errdefer device.allocator.destroy(swap_chain);

        swap_chain.super.__vtable = &vtable;

        swap_chain.device = device;

        swap_chain.texture_view = try TextureView.create(device, .{});
        errdefer swap_chain.texture_view.super.destroy();

        return swap_chain;
    }

    fn destroy(super: *webgpu.TextureView) void {
        var swap_chain = @fieldParentPtr(SwapChain, "super", super);

        swap_chain.texture_view.super.destroy();

        swap_chain.device.allocator.destroy(swap_chain);
    }

    fn getCurrentTextureView(super: *webgpu.SwapChain) *webgpu.TextureView {
        var swap_chain = @fieldParentPtr(SwapChain, "super", super);

        return &swap_chain.texture_view.super;
    }
};

pub const Texture = struct {
    const vtable = webgpu.Texture.VTable{
        .destroy_fn = destroy,
        .create_view_fn = createView,
    };

    super: webgpu.Texture,

    device: *dummy.Device,

    pub fn create(device: *dummy.Device, descriptor: webgpu.TextureDescriptor) webgpu.Device.CreateTextureError!*Texture {
        _ = descriptor;

        var texture = try device.allocator.create(Texture);
        errdefer device.allocator.destroy(texture);

        texture.super.__vtable = &vtable;

        texture.device = device;

        return texture;
    }

    fn destroy(super: *webgpu.Texture) void {
        var texture = @fieldParentPtr(Texture, "super", super);

        texture.device.allocator.destroy(texture);
    }

    fn createView(super: *webgpu.Texture, descriptor: webgpu.TextureViewDescriptor) webgpu.Texture.CreateViewError!*webgpu.TextureView {
        var texture = @fieldParentPtr(Texture, "super", super);

        var texture_view = try TextureView.create(texture.device, texture, descriptor);

        return &texture_view.super;
    }
};

pub const TextureView = struct {
    const vtable = webgpu.TextureView.VTable{
        .destroy_fn = destroy,
    };

    super: webgpu.TextureView,

    device: *dummy.Device,
    texture: *Texture,

    pub fn create(device: *dummy.Device, texture: *Texture, descriptor: webgpu.TextureViewDescriptor) webgpu.Texture.CreateViewError!*TextureView {
        _ = descriptor;

        var texture_view = try device.allocator.create(TextureView);
        errdefer device.allocator.destroy(texture_view);

        texture_view.super.__vtable = &vtable;

        texture_view.device = device;
        texture_view.texture = texture;

        return texture_view;
    }

    fn destroy(super: *webgpu.TextureView) void {
        var texture_view = @fieldParentPtr(TextureView, "super", super);

        texture_view.device.allocator.destroy(texture_view);
    }
};
