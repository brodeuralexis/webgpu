const std = @import("std");

const Buffer = @This();

const backend = @import("backend.zig");
const webgpu = @import("webgpu-core");

device: *backend.Device,
data: []u8,

pub fn create(device: *backend.Device, descriptor: webgpu.BufferDescriptor) !*Buffer {
    var self = try device.adapter.instance.allocator.create(Buffer);
    errdefer device.adapter.instance.allocator.destroy(self);

    self.device = device;
    self.data = try device.adapter.instance.allocator.alloc(u8, descriptor.size);
    errdefer device.adapter.instance.allocator.free(self.data);

    return self;
}

pub inline fn buffer(self: *Buffer) webgpu.Buffer {
    return webgpu.Buffer.init(
        self,
        destroy,
        getConstMappedRange,
        getMappedRange,
        map,
        setLabel,
        unmap,
    );
}

pub inline fn from(ptr: *anyopaque) *Buffer {
    return @ptrCast(*Buffer, @alignCast(@alignOf(Buffer), ptr));
}

pub fn destroy(self: *Buffer) void {
    self.device.adapter.instance.allocator.free(self.data);
    self.device.adapter.instance.allocator.destroy(self);
}

fn getConstMappedRange(self: *Buffer, offset: usize, size: ?usize) webgpu.Buffer.GetConstMappedRangeError![]const u8 {
    const len = if (size) |s| s else self.data.len - offset;
    return self.data[offset..(offset + len)];
}

fn getMappedRange(self: *Buffer, offset: usize, size: ?usize) webgpu.Buffer.GetMappedRangeError![]u8 {
    const len = if (size) |s| s else self.data.len - offset;
    return self.data[offset..(offset + len)];
}

fn map(self: *Buffer, mode: webgpu.MapMode, offset: usize, size: ?usize) webgpu.BufferMapAsyncError!void {
    _ = self;
    _ = mode;
    _ = offset;
    _ = size;
}

fn setLabel(self: *Buffer, label: ?[]const u8) void {
    _ = self;
    _ = label;
}

fn unmap(self: *Buffer) void {
    _ = self;
}
