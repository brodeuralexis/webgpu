const std = @import("std");
const webgpu = @import("./webgpu.zig");

pub const Buffer = struct {
    pub const VTable = struct {
        destroy_fn: fn(*Buffer) void,
        get_const_mapped_range_fn: fn(*Buffer, usize, usize) GetConstMappedRangeError![]align(16) const u8,
        get_mapped_range_fn: fn(*Buffer, usize, usize) GetMappedRangeError![]align(16) u8,
        map_async_fn: fn(*Buffer, webgpu.MapMode, usize, usize) MapAsyncError!void,
        unmap_fn: fn(*Buffer) UnmapError!void,
    };

    __vtable: *const VTable,

    device: *webgpu.Device,

    pub inline fn destroy(buffer: *Buffer) void {
        buffer.__vtable.destroy_fn(buffer);
    }

    pub const GetConstMappedRangeError = error {
        Failed,
    };

    pub inline fn getConstMappedRange(buffer: *Buffer, offset: usize, size: usize) GetConstMappedRangeError![]align(16) const u8 {
        return buffer.__vtable.get_const_mapped_range_fn(buffer, offset, size);
    }

    pub const GetMappedRangeError = error {
        Failed,
    };

    pub inline fn getMappedRange(buffer: *Buffer, offset: usize, size: usize) GetMappedRangeError![]align(16) u8 {
        return buffer.__vtable.get_mapped_range_fn(buffer, offset, size);
    }

    pub const MapAsyncError = error {};

    pub inline fn mapAsync(buffer: *Buffer, mode: webgpu.MapMode, offset: usize, size: usize) MapAsyncError!void {
        return buffer.__vtable.map_async_fn(buffer, mode, offset, size);
    }

    pub const UnmapError = error {};

    pub inline fn unmap(buffer: *Buffer) UnmapError!void {
        return buffer.__vtable.unmap_fn(buffer);
    }
};

pub const QuerySet = struct {
    pub const VTable = struct {
        destroy_fn: fn(*QuerySet) void,
    };

    __vtable: *const VTable,

    device: *webgpu.Device,

    pub inline fn destroy(query_set: *QuerySet) void {
        query_set.__vtable.destroy_fn(query_set);
    }
};

pub const Sampler = struct {
    pub const VTable = struct {
        destroy_fn: fn(*Sampler) void,
    };

    __vtable: *const VTable,

    device: *webgpu.Device,

    pub inline fn destroy(sampler: *Sampler) void {
        sampler.__vtable.destroy_fn(sampler);
    }
};

pub const SwapChain = struct {
    pub const VTable = struct {
        destroy_fn: fn(*SwapChain) void,
        get_current_texture_view_fn: fn(*SwapChain) ?*webgpu.TextureView,
    };

    __vtable: *const VTable,

    device: *webgpu.Device,

    pub inline fn destroy(swap_chain: *SwapChain) void {
        return swap_chain.__vtable.destroy_fn(swap_chain);
    }

    pub inline fn getCurrentTextureView(swap_chain: *SwapChain) ?*webgpu.TextureView {
        return swap_chain.__vtable.get_current_texture_view_fn(swap_chain);
    }
};

pub const Texture = struct {
    pub const VTable = struct {
        destroy_fn: fn(*Texture) void,
        create_view_fn: fn(*Texture, webgpu.TextureViewDescriptor) CreateViewError!*webgpu.TextureView,
    };

    __vtable: *const VTable,

    device: *webgpu.Device,

    pub inline fn destroy(texture: *Texture) void {
        texture.__vtable.destroy_fn(texture);
    }

    pub const CreateViewError = error {
        OutOfMemory,
    };

    pub inline fn createView(texture: *Texture, descriptor: webgpu.TextureViewDescriptor) CreateViewError!*webgpu.TextureView {
        return texture.__vtable.create_view_fn(texture, descriptor);
    }
};

pub const TextureView = struct {
    pub const VTable = struct {
        destroy_fn: fn(*TextureView) void,
    };

    __vtable: *const VTable,

    texture: *Texture,
    device: *webgpu.Device,

    pub inline fn destroy(texture_view: *TextureView) void {
        texture_view.__vtable.destroy_fn(texture_view);
    }
};
