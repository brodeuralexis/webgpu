const std = @import("std");

const webgpu = @import("../../webgpu.zig");

pub const Instance = @import("./Instance.zig");
pub const Adapter = @import("./Adapter.zig");

pub const Device = @import("./Device.zig");

pub fn create(descriptor: webgpu.InstanceDescriptor) webgpu.Instance.CreateError!*webgpu.Instance {
    return Instance.create(descriptor);
}
