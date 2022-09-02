const std = @import("std");

const webgpu = @import("webgpu");

pub fn main() anyerror!void {
    const instance = try webgpu.backends.dummy.init(std.heap.c_allocator);
    defer instance.deinit();

    const adapter = try instance.requestAdapter(.{
        .power_preference = .high_performance
    });
    _ = adapter;

    const device = try adapter.requestDevice(.{});
    defer device.deinit();

    const buffer = try device.createBuffer(.{
        .usage = webgpu.BufferUsage{.map_read = true, .map_write = true},
        .size = 1024,
        .mapped_at_creation = true,
    });
    defer buffer.deinit();

    std.log.info("All your bases are belong to {s}", .{ "webgpu" });
}
