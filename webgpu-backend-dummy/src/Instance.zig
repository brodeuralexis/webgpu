const std = @import("std");

const Allocator = std.mem.Allocator;

const Instance = @This();

const backend = @import("backend.zig");
const webgpu = @import("webgpu-core");

allocator: Allocator,
low_power_adapter: ?*backend.Adapter = null,
high_performance_adapter: ?*backend.Adapter = null,

pub fn instance(self: *Instance) webgpu.Instance {
    return webgpu.Instance.init(
        self,
        destroy,
        createSurface,
        processEvents,
        requestAdapter
    );
}

pub inline fn from(ptr: *anyopaque) *Instance {
    return @ptrCast(*Instance, @alignCast(@alignOf(Instance), ptr));
}

pub fn create(allocator: Allocator) !*Instance {
    var self = try allocator.create(Instance);
    errdefer allocator.destroy(self);

    self.* = Instance{
        .allocator = allocator
    };

    return self;
}

pub fn destroy(self: *Instance) void {
    self.allocator.destroy(self);
}

fn createSurface(self: *Instance, descriptor: webgpu.SurfaceDescriptor) webgpu.Instance.CreateSurfaceError!webgpu.Surface {
    var surface = try backend.Surface.create(self, descriptor);
    errdefer surface.destroy();

    return surface.surface();
}

fn processEvents(self: *Instance) void {
    _ = self;
}

fn requestAdapter(self: *Instance, options: webgpu.RequestAdapterOptions) webgpu.RequestAdapterError!webgpu.Adapter {
    switch (options.power_preference orelse .high_performance) {
        .low_power => {
            if (self.low_power_adapter == null) {
                self.low_power_adapter = try backend.Adapter.create(self, options);
            }

            return self.low_power_adapter.?.adapter();
        },
        .high_performance => {
            if (self.high_performance_adapter == null) {
                self.high_performance_adapter = try backend.Adapter.create(self, options);
            }

            return self.high_performance_adapter.?.adapter();
        },
    }
}
