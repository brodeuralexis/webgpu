const std = @import("std");

const ShaderModule = @This();

const backend = @import("backend.zig");
const webgpu = @import("webgpu-core");

device: *backend.Device,

pub fn create(device: *backend.Device, descriptor: webgpu.ShaderModuleDescriptor) !*ShaderModule {
    _ = descriptor;

    var self = try device.adapter.instance.allocator.create(ShaderModule);
    errdefer device.adapter.instance.allocator.destroy(self);

    self.device = device;

    return self;
}

pub inline fn shaderModule(self: *ShaderModule) webgpu.ShaderModule {
    return webgpu.ShaderModule.init(
        self,
        getCompilationInfo,
        setLabel,
    );
}

pub inline fn from(ptr: *anyopaque) *ShaderModule {
    return @ptrCast(*ShaderModule, @alignCast(@alignOf(ShaderModule), ptr));
}

pub fn destroy(self: *ShaderModule) void {
    self.device.adapter.instance.allocator.destroy(self);
}

fn getCompilationInfo(self: *ShaderModule) webgpu.CompilationInfo {
    _  = self;

    return webgpu.CompilationInfo{
        .messages = &[0]webgpu.CompilationMessage{},
    };
}

fn setLabel(self: *ShaderModule, label: ?[]const u8) void {
    _ = self;
    _ = label;
}
