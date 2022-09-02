const std = @import("std");

const RenderBundleEncoder = @This();

const webgpu = @import("core.zig");

ptr: *anyopaque,
vtable: *const VTable,

pub const VTable = struct {
    draw: *const fn(*anyopaque, u32, u32, u32, u32) void,
    draw_indexed: *const fn(*anyopaque, u32, u32, u32, u32, u32) void,
    draw_indexed_indirect: *const fn(*anyopaque, webgpu.Buffer, usize) void,
    draw_indirect: *const fn(*anyopaque, webgpu.Buffer, usize) void,
    finish: *const fn(*anyopaque, ?webgpu.RenderBundleDescriptor) webgpu.RenderBundle,
    insert_debug_marker: *const fn(*anyopaque, []const u8) void,
    pop_debug_group: *const fn(*anyopaque) void,
    push_debug_group: *const fn(*anyopaque, []const u8) void,
    set_bind_group: *const fn(*anyopaque, u32, webgpu.BindGroup, []const u32) void,
    set_index_buffer: *const fn(*anyopaque, webgpu.Buffer, webgpu.IndexFormat, usize, usize) void,
    set_label: *const fn(*anyopaque, ?[]const u8) void,
    set_pipeline: *const fn(*anyopaque, webgpu.RenderPipeline) void,
    set_vertex_buffer: *const fn(*anyopaque, u32, webgpu.Buffer, usize, usize) void,
};

pub inline fn init(
    pointer: anytype,
    comptime draw_fn: *const fn(@TypeOf(pointer), u32, u32, u32, u32) void,
    comptime draw_indexed_fn: *const fn(@TypeOf(pointer), u32, u32, u32, u32, u32) void,
    comptime draw_indexed_indirect_fn: *const fn(@TypeOf(pointer), webgpu.Buffer, usize) void,
    comptime draw_indirect_fn: *const fn(@TypeOf(pointer), webgpu.Buffer, usize) void,
    comptime finish_fn: *const fn(@TypeOf(pointer), ?webgpu.RenderBundleDescriptor) webgpu.RenderBundle,
    comptime insert_debug_marker_fn: *const fn(@TypeOf(pointer), []const u8) void,
    comptime pop_debug_group_fn: *const fn(@TypeOf(pointer)) void,
    comptime push_debug_group_fn: *const fn(@TypeOf(pointer), []const u8) void,
    comptime set_bind_group_fn: *const fn(@TypeOf(pointer), u32, webgpu.BindGroup, []const u32) void,
    comptime set_index_buffer_fn: *const fn(@TypeOf(pointer), webgpu.Buffer, webgpu.IndexFormat, usize, usize) void,
    comptime set_label_fn: *const fn(@TypeOf(pointer), ?[]const u8) void,
    comptime set_pipeline_fn: *const fn(@TypeOf(pointer), webgpu.RenderPipeline) void,
    comptime set_vertex_buffer_fn: *const fn(@TypeOf(pointer), u32, webgpu.Buffer, usize, usize) void,
) RenderBundleEncoder {
    const Ptr = @TypeOf(pointer);
    const ptr_info = @typeInfo(Ptr);

    std.debug.assert(ptr_info == .Pointer);
    std.debug.assert(ptr_info.Pointer.size == .One);

    const alignment = ptr_info.Pointer.alignment;

    const gen = struct {
        fn drawImpl(ptr: *anyopaque, vertex_count: u32, instance_count: u32, first_vertex: u32, first_instance: u32) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return draw_fn(self, vertex_count, instance_count, first_vertex, first_instance);
        }

        fn drawIndexedImpl(ptr: *anyopaque, index_count: u32, instance_count: u32, first_index: u32, base_vertex: u32, first_instance: u32) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return draw_indexed_fn(self, index_count, instance_count, first_index, base_vertex, first_instance);
        }

        fn drawIndexedIndirectImpl(ptr: *anyopaque, indirect_buffer: webgpu.Buffer, indirect_offset: usize) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return draw_indexed_indirect_fn(self, indirect_buffer, indirect_offset);
        }

        fn drawIndirectImpl(ptr: *anyopaque, indirect_buffer: webgpu.Buffer, indirect_offset: usize) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return draw_indirect_fn(self, indirect_buffer, indirect_offset);
        }

        fn finishImpl(ptr: *anyopaque, descriptor: ?webgpu.RenderBundleDescriptor) webgpu.RenderBundle {
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

        fn setBindGroupImpl(ptr: *anyopaque, group_index: u32, bind_group: webgpu.BindGroup, dynamic_offsets: []const u32) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return set_bind_group_fn(self, group_index, bind_group, dynamic_offsets);
        }

        fn setIndexBufferImpl(ptr: *anyopaque, buffer: webgpu.Buffer, format: webgpu.IndexFormat, offset: usize, size: usize) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return set_index_buffer_fn(self, buffer, format, offset, size);
        }

        fn setLabelImpl(ptr: *anyopaque, label: ?[]const u8) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return set_label_fn(self, label);
        }

        fn setPipelineImpl(ptr: *anyopaque, pipeline: webgpu.RenderPipeline) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return set_pipeline_fn(self, pipeline);
        }

        fn setVertexBufferImpl(ptr: *anyopaque, slot: u32, buffer: webgpu.Buffer, offset: usize, size: usize) void {
            const self = @ptrCast(Ptr, @alignCast(alignment, ptr));
            return set_vertex_buffer_fn(self, slot, buffer, offset, size);
        }

        const vtable = VTable{
            .draw = drawImpl,
            .draw_indexed = drawIndexedImpl,
            .draw_indexed_indirect = drawIndexedIndirectImpl,
            .draw_indirect = drawIndirectImpl,
            .finish = finishImpl,
            .insert_debug_marker = insertDebugMarkerImpl,
            .pop_debug_group = popDebugGroupImpl,
            .push_debug_group = pushDebugGroupImpl,
            .set_bind_group = setBindGroupImpl,
            .set_index_buffer = setIndexBufferImpl,
            .set_label = setLabelImpl,
            .set_pipeline = setPipelineImpl,
            .set_vertex_buffer = setVertexBufferImpl,
        };
    };

    return RenderBundleEncoder{
        .ptr = pointer,
        .vtable = &gen.vtable,
    };
}

fn draw(render_bundle_encoder: RenderBundleEncoder, vertex_count: u32, instance_count: u32, first_vertex: u32, first_instance: u32) void {
    return render_bundle_encoder.vtable.draw(render_bundle_encoder.ptr, vertex_count, instance_count, first_vertex, first_instance);
}

fn drawIndexed(render_bundle_encoder: RenderBundleEncoder, index_count: u32, instance_count: u32, first_index: u32, base_vertex: u32, first_instance: u32) void {
    return render_bundle_encoder.vtable.draw_indexed(render_bundle_encoder.ptr, index_count, instance_count, first_index, base_vertex, first_instance);
}

fn drawIndexedIndirect(render_bundle_encoder: RenderBundleEncoder, indirect_buffer: webgpu.Buffer, indirect_offset: usize) void {
    return render_bundle_encoder.vtable.draw_indexed_indirect(render_bundle_encoder.ptr, indirect_buffer, indirect_offset);
}

fn drawIndirect(render_bundle_encoder: RenderBundleEncoder, indirect_buffer: webgpu.Buffer, indirect_offset: usize) void {
    return render_bundle_encoder.vtable.draw_indexed(render_bundle_encoder.ptr, indirect_buffer, indirect_offset);
}

fn finish(render_bundle_encoder: RenderBundleEncoder, descriptor: ?webgpu.RenderBundleDescriptor) webgpu.RenderBundle {
    return render_bundle_encoder.vtable.finish(render_bundle_encoder.ptr, descriptor);
}

fn insertDebugMarker(render_bundle_encoder: RenderBundleEncoder, marker_label: []const u8) void {
    return render_bundle_encoder.vtable.insert_debug_marker(render_bundle_encoder.ptr, marker_label);
}

fn popDebugGroup(render_bundle_encoder: RenderBundleEncoder) void {
    return render_bundle_encoder.vtable.pop_debug_group(render_bundle_encoder.ptr);
}

fn pushDebugGroup(render_bundle_encoder: RenderBundleEncoder, group_label: []const u8) void {
    return render_bundle_encoder.vtable.push_debug_group(render_bundle_encoder.ptr, group_label);
}

fn setBindGroup(render_bundle_encoder: RenderBundleEncoder, group_index: u32, bind_group: webgpu.BindGroup, dynamic_offsets: []const u32) void {
    return render_bundle_encoder.vtable.set_bind_group(render_bundle_encoder.ptr, group_index, bind_group, dynamic_offsets);
}

fn setIndexBuffer(render_bundle_encoder: RenderBundleEncoder, buffer: webgpu.Buffer, format: webgpu.IndexFormat, offset: usize, size: usize) void {
    return render_bundle_encoder.vtable.set_index_buffer(render_bundle_encoder.ptr, buffer, format, offset, size);
}

fn setLabel(render_bundle_encoder: RenderBundleEncoder, label: ?[]const u8) void {
    return render_bundle_encoder.vtable.set_label(render_bundle_encoder.ptr, label);
}

fn setPipeline(render_bundle_encoder: RenderBundleEncoder, pipeline: webgpu.RenderPipeline) void {
    return render_bundle_encoder.vtable.set_pipeline(render_bundle_encoder.ptr, pipeline);
}

fn setVertexBuffer(render_bundle_encoder: RenderBundleEncoder, slot: u32, buffer: webgpu.Buffer, offset: usize, size: usize) void {
    return render_bundle_encoder.vtable.set_vertex_buffer(render_bundle_encoder.ptr, slot, buffer, offset, size);
}
