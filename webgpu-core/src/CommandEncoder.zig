const std = @import("std");

const CommandEncoder = @This();

const webgpu = @import("core.zig");

ptr: *anyopaque,
vtable: *const VTable,

pub const VTable = struct {
    deinit: *const fn(*anyopaque) void,
    begin_compute_pass: *const fn(*anyopaque, ?webgpu.ComputePassDescriptor) BeginComputePassError!webgpu.ComputePassEncoder,
    begin_render_pass: *const fn(*anyopaque, webgpu.RenderPassDescriptor) BeginRenderPassError!webgpu.RenderPassEncoder,
    clear_buffer: *const fn(*anyopaque, webgpu.Buffer, usize, ?usize) void,
    copy_buffer_to_buffer: *const fn(*anyopaque, webgpu.Buffer, usize, webgpu.Buffer, usize, usize) void,
    copy_buffer_to_texture: *const fn(*anyopaque, webgpu.ImageCopyBuffer, webgpu.ImageCopyTexture, webgpu.Extent3D) void,
    copy_texture_to_buffer: *const fn(*anyopaque, webgpu.ImageCopyTexture, webgpu.ImageCopyTexture, webgpu.Extent3D) void,
    copy_texture_to_texture: *const fn(*anyopaque, webgpu.ImageCopyTexture, webgpu.ImageCopyTexture, webgpu.Extent3D) void,
    finish: *const fn(*anyopaque, ?webgpu.CommandBufferDescriptor) webgpu.CommandBuffer,
    insert_debug_marker: *const fn(*anyopaque, []const u8) void,
    pop_debug_group: *const fn(*anyopaque) void,
    push_debug_group: *const fn(*anyopaque, []const u8) void,
    resolve_query_set: *const fn(*anyopaque, webgpu.QuerySet, u32, u32, webgpu.Buffer, usize) void,
    set_label: *const fn(*anyopaque, ?[]const u8) void,
    write_timestamp: *const fn(*anyopaque, webgpu.QuerySet, u32) void,
};

pub inline fn init(
    pointer: anytype,
    comptime deinit_fn: *const fn(@TypeOf(pointer)) void,
    comptime begin_compute_pass_fn: *const fn(@TypeOf(pointer), ?webgpu.ComputePassDescriptor) BeginComputePassError!webgpu.ComputePassEncoder,
    comptime begin_render_pass_fn: *const fn(@TypeOf(pointer), webgpu.RenderPassDescriptor) BeginRenderPassError!webgpu.RenderPassEncoder,
    comptime clear_buffer_fn: *const fn(@TypeOf(pointer), webgpu.Buffer, usize, ?usize) void,
    comptime copy_buffer_to_buffer_fn: *const fn(@TypeOf(pointer), webgpu.Buffer, usize, webgpu.Buffer, usize, usize) void,
    comptime copy_buffer_to_texture_fn: *const fn(@TypeOf(pointer), webgpu.ImageCopyBuffer, webgpu.ImageCopyTexture, webgpu.Extent3D) void,
    comptime copy_texture_to_buffer_fn: *const fn(@TypeOf(pointer), webgpu.ImageCopyTexture, webgpu.ImageCopyTexture, webgpu.Extent3D) void,
    comptime copy_texture_to_texture_fn: *const fn(@TypeOf(pointer), webgpu.ImageCopyTexture, webgpu.ImageCopyTexture, webgpu.Extent3D) void,
    comptime finish_fn: *const fn(@TypeOf(pointer), ?webgpu.CommandBufferDescriptor) webgpu.CommandBuffer,
    comptime insert_debug_marker_fn: *const fn(@TypeOf(pointer), []const u8) void,
    comptime pop_debug_group_fn: *const fn(@TypeOf(pointer)) void,
    comptime push_debug_group_fn: *const fn(@TypeOf(pointer), []const u8) void,
    comptime resolve_query_set_fn: *const fn(@TypeOf(pointer), webgpu.QuerySet, u32, u32, webgpu.Buffer, usize) void,
    comptime set_label_fn: *const fn(@TypeOf(pointer), ?[]const u8) void,
    comptime write_timestamp_fn: *const fn(@TypeOf(pointer), webgpu.QuerySet, u32) void,
) CommandEncoder {
    const Ptr = @TypeOf(pointer);
    const ptr_info = @typeInfo(Ptr);

    std.debug.assert(ptr_info == .Pointer);
    std.debug.assert(ptr_info.Pointer.size == .One);

    const alignment = ptr_info.Pointer.alignment;

    const gen = struct {
        fn deinitImpl(ptr: *anyopaque) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return deinit_fn(self);
        }

        fn beginComputePassImpl(ptr: *anyopaque, descriptor: ?webgpu.ComputePassDescriptor) BeginComputePassError!webgpu.ComputePassEncoder {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return begin_compute_pass_fn(self, descriptor);
        }

        fn beginRenderPassImpl(ptr: *anyopaque, descriptor: webgpu.RenderPassDescriptor) BeginRenderPassError!webgpu.RenderPassEncoder {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return begin_render_pass_fn(self, descriptor);
        }

        fn clearBufferImpl(ptr: *anyopaque, buffer: webgpu.Buffer, offset: usize, size: ?usize) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return clear_buffer_fn(self, buffer, offset, size);
        }

        fn copyBufferToBufferImpl(ptr: *anyopaque, source: webgpu.Buffer, source_offset: usize, destination: webgpu.Buffer, destination_offset: usize, size: usize) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return copy_buffer_to_buffer_fn(self, source, source_offset, destination, destination_offset, size);
        }

        fn copyBufferToTextureImpl(ptr: *anyopaque, source: webgpu.ImageCopyBuffer, destination: webgpu.ImageCopyTexture, extent: webgpu.Extent3D) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return copy_buffer_to_texture_fn(self, source, destination, extent);
        }

        fn copyTextureToBufferImpl(ptr: *anyopaque, source: webgpu.ImageCopyTexture, destination: webgpu.ImageCopyTexture, extent: webgpu.Extent3D) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return copy_texture_to_buffer_fn(self, source, destination, extent);
        }

        fn copyTextureToTextureImpl(ptr: *anyopaque, source: webgpu.ImageCopyTexture, destination: webgpu.ImageCopyTexture, extent: webgpu.Extent3D) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return copy_texture_to_texture_fn(self, source, destination, extent);
        }

        fn finishImpl(ptr: *anyopaque, descriptor: ?webgpu.CommandBufferDescriptor) webgpu.CommandBuffer {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return finish_fn(self, descriptor);
        }

        fn insertDebugMarkerImpl(ptr: *anyopaque, marker_label: []const u8) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return insert_debug_marker_fn(self, marker_label);
        }

        fn popDebugGroupImpl(ptr: *anyopaque) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return pop_debug_group_fn(self);
        }

        fn pushDebugGroupImpl(ptr: *anyopaque, group_label: []const u8) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return push_debug_group_fn(self, group_label);
        }

        fn resolveQuerySetImpl(ptr: *anyopaque, query_set: webgpu.QuerySet, first_query: u32, query_count: u32, destination: webgpu.Buffer, destination_offset: usize) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return resolve_query_set_fn(self, query_set, first_query, query_count, destination, destination_offset);
        }

        fn setLabelImpl(ptr: *anyopaque, label: ?[]const u8) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return set_label_fn(self, label);
        }

        fn writeTimestampImpl(ptr: *anyopaque, query_set: webgpu.QuerySet, query_index: u32) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return write_timestamp_fn(self, query_set, query_index);
        }

        const vtable = VTable{
            .deinit = deinitImpl,
            .begin_compute_pass = beginComputePassImpl,
            .begin_render_pass = beginRenderPassImpl,
            .clear_buffer = clearBufferImpl,
            .copy_buffer_to_buffer = copyBufferToBufferImpl,
            .copy_buffer_to_texture = copyBufferToTextureImpl,
            .copy_texture_to_buffer = copyTextureToBufferImpl,
            .copy_texture_to_texture = copyTextureToTextureImpl,
            .finish = finishImpl,
            .insert_debug_marker = insertDebugMarkerImpl,
            .pop_debug_group = popDebugGroupImpl,
            .push_debug_group = pushDebugGroupImpl,
            .resolve_query_set = resolveQuerySetImpl,
            .set_label = setLabelImpl,
            .write_timestamp = writeTimestampImpl,
        };
    };

    return CommandEncoder{
        .ptr = pointer,
        .vtable = &gen.vtable,
    };
}

pub inline fn deinit(command_encoder: CommandEncoder) void {
    return command_encoder.vtable.deinit(command_encoder.ptr);
}

pub const BeginComputePassError = error {
    OutOfMemory,
};

pub inline fn beginComputePass(command_encoder: CommandEncoder, descriptor: ?webgpu.ComputePassDescriptor) BeginComputePassError!webgpu.ComputePassEncoder {
    return command_encoder.vtable.begin_compute_pass(command_encoder.ptr, descriptor);
}

pub const BeginRenderPassError = error {
    OutOfMemory,
};

pub inline fn beginRenderPass(command_encoder: CommandEncoder, descriptor: webgpu.RenderPassDescriptor) BeginRenderPassError!webgpu.RenderPassEncoder {
    return command_encoder.vtable.begin_compute_pass(command_encoder.ptr, descriptor);
}

pub inline fn clearBuffer(command_encoder: CommandEncoder, buffer: webgpu.Buffer, offset: usize, size: ?usize) void {
    return command_encoder.vtable.clear_buffer(command_encoder.ptr, buffer, offset, size);
}

pub inline fn copyBufferToBuffer(command_encoder: CommandEncoder, source: webgpu.Buffer, source_offset: usize, destination: webgpu.Buffer, destination_offset: usize, size: usize) void {
    return command_encoder.vtable.copy_buffer_to_buffer(command_encoder.ptr, source, source_offset, destination, destination_offset, size);
}

pub inline fn copyBufferToTexture(command_encoder: CommandEncoder, source: webgpu.ImageCopyBuffer, destination: webgpu.ImageCopyTexture, extent: webgpu.Extent3D) void {
    return command_encoder.vtable.copy_buffer_to_texture(command_encoder.ptr, source, destination, extent);
}

pub inline fn copyTextureToBuffer(command_encoder: CommandEncoder, source: webgpu.ImageCopyTexture, destination: webgpu.ImageCopyTexture, extent: webgpu.Extent3D) void {
    return command_encoder.vtable.copy_texture_to_buffer(command_encoder.ptr, source, destination, extent);
}

pub inline fn copyTextureToTexture(command_encoder: CommandEncoder, source: webgpu.ImageCopyTexture, destination: webgpu.ImageCopyTexture, extent: webgpu.Extent3D) void {
    return command_encoder.vtable.copy_texture_to_texture(command_encoder.ptr, source, destination, extent);
}

pub inline fn finish(command_encoder: CommandEncoder, descriptor: ?webgpu.CommandBufferDescriptor) webgpu.CommandBuffer {
    return command_encoder.vtable.finish(command_encoder.ptr, descriptor);
}

pub inline fn insertDebugMarker(command_encoder: CommandEncoder, marker_label: []const u8) void {
    return command_encoder.vtable.insert_debug_marker(command_encoder.ptr, marker_label);
}

pub inline fn popDebugGroup(command_encoder: CommandEncoder) void {
    return command_encoder.vtable.pop_debug_group(command_encoder.ptr);
}

pub inline fn pushDebugGroup(command_encoder: CommandEncoder, group_label: []const u8) void {
    return command_encoder.vtable.push_debug_group(command_encoder.ptr, group_label);
}

pub inline fn resolveQuerySet(command_encoder: CommandEncoder, query_set: webgpu.QuerySet, first_query: u32, query_count: u32, destination: webgpu.Buffer, destination_offset: usize) void {
    return command_encoder.vtable.resolve_query_set(command_encoder.ptr, query_set, first_query, query_count, destination, destination_offset);
}

pub inline fn setLabel(command_encoder: CommandEncoder, label: ?[]const u8) void {
    return command_encoder.vtable.set_label(command_encoder.ptr, label);
}

pub inline fn writeTimestamp(command_encoder: CommandEncoder, query_set: webgpu.QuerySet, query_index: u32) void {
    return command_encoder.vtable.write_timestamp(command_encoder.ptr, query_set, query_index);
}
