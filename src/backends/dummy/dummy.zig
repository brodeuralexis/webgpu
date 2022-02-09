const std = @import("std");

const webgpu = @import("../../webgpu.zig");

pub usingnamespace @import("./binding_model.zig");
pub usingnamespace @import("./command.zig");
pub usingnamespace @import("./device.zig");
pub usingnamespace @import("./instance.zig");
pub usingnamespace @import("./pipeline.zig");
pub usingnamespace @import("./resource.zig");

const instance = @import("./instance.zig");

pub fn create(descriptor: webgpu.InstanceDescriptor) webgpu.Instance.CreateError!*webgpu.Instance {
    var impl = try instance.Instance.create(descriptor);
    errdefer impl.super.destroy();

    return &impl.super;
}
