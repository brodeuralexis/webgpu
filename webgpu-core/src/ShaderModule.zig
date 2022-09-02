const std = @import("std");

const ShaderModule = @This();

const webgpu = @import("core.zig");

ptr: *anyopaque,
vtable: *const VTable,

pub const VTable = struct {
    get_compilation_info: *const fn(*anyopaque) webgpu.CompilationInfo,
    set_label: *const fn(*anyopaque, ?[]const u8) void,
};

pub inline fn init(
    pointer: anytype,
    comptime get_compilation_info_fn: *const fn(@TypeOf(pointer)) webgpu.CompilationInfo,
    comptime set_label_fn: *const fn(@TypeOf(pointer), ?[]const u8) void,
) ShaderModule {
    const Ptr = @TypeOf(pointer);
    const ptr_info = @typeInfo(Ptr);

    std.debug.assert(ptr_info == .Pointer);
    std.debug.assert(ptr_info.Pointer.size == .One);

    const alignment = ptr_info.Pointer.alignment;

    const gen = struct {
        fn getCompilationInfoImpl(ptr: *anyopaque) webgpu.CompilationInfo {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return get_compilation_info_fn(self);
        }

        fn setLabelImpl(ptr: *anyopaque, label: ?[]const u8) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return set_label_fn(self, label);
        }

        const vtable = VTable{
            .get_compilation_info = getCompilationInfoImpl,
            .set_label = setLabelImpl,
        };
    };

    return ShaderModule{
        .ptr = pointer,
        .vtable = &gen.vtable,
    };
}

pub inline fn getCompilationInfo(shader_module: ShaderModule) webgpu.CompilationInfo {
    return shader_module.vtable.get_compilation_info(shader_module.ptr);
}

pub inline fn setLabel(shader_module: ShaderModule, label: ?[]const u8) void {
    return shader_module.vtable.set_label(shader_module.ptr, label);
}
