const std = @import("std");
const webgpu = @import("./webgpu.zig");

pub const BindGroup = struct {
    pub const VTable = struct {
        destroy_fn: fn(*BindGroup) void,
    };

    __vtable: *const VTable,

    pub inline fn destroy(bind_group: *BindGroup) void {
        bind_group.__vtable.destroy_fn(bind_group);
    }
};

pub const BindGroupLayout = struct {
    pub const VTable = struct {
        destroy_fn: fn(*BindGroupLayout) void,
    };

    __vtable: *const VTable,

    pub inline fn destroy(bind_group_layout: *BindGroupLayout) void {
        bind_group_layout.__vtable.destroy_fn(bind_group_layout);
    }
};

pub const PipelineLayout = struct {
    pub const VTable = struct {
        destroy_fn: fn(*PipelineLayout) void,
    };

    __vtable: *const VTable,

    pub inline fn destroy(pipeline_layout: *PipelineLayout) void {
        pipeline_layout.__vtable.destroy_fn(pipeline_layout);
    }
};
