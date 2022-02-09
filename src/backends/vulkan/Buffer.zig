const std = @import("std");
const vk = @import("./vk.zig");
const webgpu = @import("../../webgpu.zig");
const Device = @import("./Device.zig");

const Buffer = @This();

pub const vtable = webgpu.Buffer.VTable{};

device: *Device,
handle: vk.Buffer,

pub fn init(device: *Device, handle: vk.Buffer) !webgpu.Buffer{
    var ptr = try device.allocator.create(Buffer);
    errdefer device.allocator.destroy(ptr);

    ptr.device = device;
    ptr.handle = handle;

    return webgpu.Buffer{.vtable = vtable, .ptr = ptr};
}
