const std = @import("std");

const Queue = @This();

const webgpu = @import("core.zig");

ptr: *anyopaque,
vtable: *const VTable,

pub const VTable = struct {
    set_label: *const fn(*anyopaque, ?[]const u8) void,
    submit: *const fn(*anyopaque, []const webgpu.CommandBuffer) void,
    write_buffer: *const fn(*anyopaque, webgpu.Buffer, usize, []const u8) void,
    write_texture: *const fn(*anyopaque, webgpu.ImageCopyTexture, []const u8, webgpu.TextureDataLayout, webgpu.Extent3D) void,
};

pub inline fn init(
    pointer: anytype,
    comptime set_label_fn: *const fn(@TypeOf(pointer), ?[]const u8) void,
    comptime submit_fn: *const fn(@TypeOf(pointer), []const webgpu.CommandBuffer) void,
    comptime write_buffer_fn: *const fn(@TypeOf(pointer), webgpu.Buffer, usize, []const u8) void,
    comptime write_texture_fn: *const fn(@TypeOf(pointer), webgpu.ImageCopyTexture, []const u8, webgpu.TextureDataLayout, webgpu.Extent3D) void,
) Queue {
    const Ptr = @TypeOf(pointer);
    const ptr_info = @typeInfo(Ptr);

    std.debug.assert(ptr_info == .Pointer);
    std.debug.assert(ptr_info.Pointer.size == .One);

    const alignment = ptr_info.Pointer.alignment;

    const gen = struct {
        fn setLabelImpl(ptr: *anyopaque, label: ?[]const u8) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return set_label_fn(self, label);
        }

        fn submitImpl(ptr: *anyopaque, command_buffers: []const webgpu.CommandBuffer) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return submit_fn(self, command_buffers);
        }

        fn writeBufferImpl(ptr: *anyopaque, buffer: webgpu.Buffer, buffer_offset: usize, data: []const u8) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return write_buffer_fn(self, buffer, buffer_offset, data);
        }

        fn writeTextureImpl(ptr: *anyopaque, destination: webgpu.ImageCopyTexture, data: []const u8, data_layout: webgpu.TextureDataLayout, write_size: webgpu.Extent3D) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return write_texture_fn(self, destination, data, data_layout, write_size);
        }

        const vtable = VTable{
            .set_label = setLabelImpl,
            .submit = submitImpl,
            .write_buffer = writeBufferImpl,
            .write_texture = writeTextureImpl,
        };
    };

    return Queue{
        .ptr = pointer,
        .vtable = &gen.vtable,
    };
}

pub inline fn setLabel(queue: Queue, label: ?[]const u8) void {
    return queue.vtable.set_label(queue.ptr, label);
}

pub inline fn submit(queue: Queue, command_buffers: []const webgpu.CommandBuffer) void {
    return queue.vtable.submit(queue.ptr, command_buffers);
}

pub inline fn writeBuffer(queue: Queue, buffer: webgpu.Buffer, buffer_offset: usize, data: []const u8) void {
    return queue.vtable.write_buffer(queue.ptr, buffer, buffer_offset, data);
}

pub inline fn writeTexture(queue: Queue, destination: webgpu.ImageCopyTexture, data: []const u8, data_layout: webgpu.TextureDataLayout, write_size: webgpu.Extent3D) void {
    return queue.vtable.write_texture(queue.ptr, destination, data, data_layout, write_size);
}
