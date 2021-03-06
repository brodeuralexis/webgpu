const std = @import("std");

const webgpu = @import("webgpu");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    var instance = try webgpu.Instance.create(webgpu.backends.vulkan, .{ .allocator = allocator });
    defer instance.destroy();

    var adapter = try instance.requestAdapter(.{ .power_preference = .high_performance });
    var device = try adapter.requestDevice(.{});
    defer device.destroy();

    var buffer = try device.createBuffer(.{
        .usage = .{ .map_read = true, .map_write = true, },
        .size = 64,
    });
    defer buffer.destroy();

    std.log.info("buffer: {*}", .{ buffer });
}
