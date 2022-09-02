const std = @import("std");

const Surface = @This();

const backend = @import("backend.zig");
const webgpu = @import("webgpu-core");

instance: *backend.Instance,

pub fn create(instance: *backend.Instance, descriptor: webgpu.SurfaceDescriptor) !*Surface {
    _ = descriptor;

    var self = try instance.allocator.create(Surface);
    errdefer instance.allocator.destroy(self);

    self.instance = instance;

    return self;
}

pub inline fn surface(self: *Surface) webgpu.Surface {
    return webgpu.Surface.init(
        self,
        getPreferredFormat,
    );
}

pub inline fn from(ptr: *anyopaque) *Surface {
    return @ptrCast(*Surface, @alignCast(@alignOf(Surface), ptr));
}

pub fn destroy(self: *Surface) void {
    self.instance.allocator.destroy(self);
}

fn getPreferredFormat(self: *Surface) webgpu.TextureFormat {
    _ = self;

    return .rgba8_uint;
}
