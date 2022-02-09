const std = @import("std");

const Allocator = std.mem.Allocator;

const webgpu = @import("../../../webgpu.zig");
const vulkan = @import("../vulkan.zig");
const vk = @import("../vk.zig");
const QueueFamilies = @import("../QueueFamilies.zig");

const Adapter = @This();

pub const vtable = webgpu.Adapter.VTable{
    .request_device_fn = requestDevice,
};

super: webgpu.Adapter,

handle: vk.PhysicalDevice,
queue_families: QueueFamilies,

pub fn create(instance: *vulkan.Instance, physical_device: vk.PhysicalDevice) !*Adapter {
    var adapter = try instance.allocator.create(Adapter);
    errdefer instance.allocator.destroy(adapter);

    adapter.super = .{
        .__vtable = &vtable,
        .instance = &instance.super,
        .features = undefined,
        .limits = undefined,
        .device_id = undefined,
        .vendor_id = undefined,
        .backend_type = .vulkan,
        .adapter_type = undefined,
        .name = undefined,
    };

    adapter.handle = physical_device;

    var properties = instance.vki.getPhysicalDeviceProperties(adapter.handle);

    const name = try instance.allocator.dupeZ(u8, std.mem.sliceTo(&properties.device_name, 0));
    errdefer instance.allocator.free(name);

    adapter.super.features = adapter.calculateSupportedFeatures();
    adapter.super.limits = adapter.calculateSupportedLimits();

    adapter.super.device_id = properties.device_id;
    adapter.super.vendor_id = properties.vendor_id;
    adapter.super.adapter_type = switch (properties.device_type) {
        .integrated_gpu => .integrated_gpu,
        .discrete_gpu => .discrete_gpu,
        .cpu => .cpu,
        else => .unknown,
    };
    adapter.super.name = name;

    adapter.queue_families = try QueueFamilies.find(adapter);

    return adapter;
}

pub fn destroy(adapter: *Adapter) void {
    var instance = @fieldParentPtr(vulkan.Instance, "super", adapter.super.instance);

    instance.allocator.free(adapter.super.name);
    instance.allocator.destroy(adapter);
}

fn requestDevice(super: *webgpu.Adapter, descriptor: webgpu.DeviceDescriptor) webgpu.Adapter.RequestDeviceError!*webgpu.Device {
    var adapter = @fieldParentPtr(Adapter, "super", super);

    var device = vulkan.Device.create(adapter, descriptor)
        catch |err| switch (err) {
            error.OutOfMemory => |_err| return _err,
            else => return error.Failed,
        };

    return &device.super;
}

fn calculateSupportedFeatures(adapter: *Adapter) webgpu.Features {
    var instance = @fieldParentPtr(vulkan.Instance, "super", adapter.super.instance);

    var _features = instance.vki.getPhysicalDeviceFeatures(adapter.handle);

    var features = webgpu.Features{};

    features.texture_compression_bc = _features.texture_compression_bc == vk.TRUE;
    features.texture_compression_etc2 = _features.texture_compression_etc2 == vk.TRUE;
    features.texture_compression_astc = _features.texture_compression_astc_ldr == vk.TRUE;
    features.timestamp_query = _features.pipeline_statistics_query == vk.TRUE and _features.occlusion_query_precise == vk.TRUE;
    features.indirect_first_instance = _features.draw_indirect_first_instance == vk.TRUE;

    return features;
}

fn calculateSupportedLimits(adapter: *Adapter) webgpu.Limits {
    var instance = @fieldParentPtr(vulkan.Instance, "super", adapter.super.instance);

    var properties = instance.vki.getPhysicalDeviceProperties(adapter.handle);

    var limits = webgpu.Limits{};

    limits.max_texture_dimension1d = properties.limits.max_image_dimension_1d;
    limits.max_texture_dimension2d = properties.limits.max_image_dimension_2d;
    limits.max_texture_dimension3d = properties.limits.max_image_dimension_3d;
    limits.max_texture_array_layers = properties.limits.max_image_array_layers;
    limits.max_bind_groups = properties.limits.max_bound_descriptor_sets;
    limits.max_dynamic_uniform_buffers_per_pipeline_layout = properties.limits.max_descriptor_set_uniform_buffers_dynamic;
    limits.max_dynamic_storage_buffers_per_pipeline_layout = properties.limits.max_descriptor_set_storage_buffers_dynamic;
    limits.max_sampled_textures_per_shader_stage = properties.limits.max_per_stage_descriptor_sampled_images;
    limits.max_samplers_per_shader_stage =  properties.limits.max_per_stage_descriptor_samplers;
    limits.max_storage_buffers_per_shader_stage =  properties.limits.max_per_stage_descriptor_storage_buffers;
    limits.max_storage_textures_per_shader_stage =  properties.limits.max_per_stage_descriptor_storage_images;
    limits.max_uniform_buffers_per_shader_stage =  properties.limits.max_per_stage_descriptor_uniform_buffers;
    limits.max_uniform_buffer_binding_size =  properties.limits.max_uniform_buffer_range;
    limits.max_storage_buffer_binding_size =  properties.limits.max_storage_buffer_range;
    limits.min_uniform_buffer_offset_alignment = @intCast(u32, properties.limits.min_uniform_buffer_offset_alignment);
    limits.min_storage_buffer_offset_alignment = @intCast(u32, properties.limits.min_storage_buffer_offset_alignment);
    limits.max_vertex_buffers = properties.limits.max_vertex_input_bindings;
    limits.max_vertex_attributes = properties.limits.max_vertex_input_attributes;
    limits.max_vertex_buffer_array_stride = properties.limits.max_vertex_input_binding_stride;
    limits.max_inter_stage_shader_components = properties.limits.max_vertex_output_components;
    limits.max_compute_workgroup_storage_size = properties.limits.max_compute_shared_memory_size;
    limits.max_compute_invocations_per_workgroup = properties.limits.max_compute_work_group_invocations;
    limits.max_compute_workgroup_size_x = properties.limits.max_compute_work_group_size[0];
    limits.max_compute_workgroup_size_y = properties.limits.max_compute_work_group_size[1];
    limits.max_compute_workgroup_size_z = properties.limits.max_compute_work_group_size[2];
    limits.max_compute_workgroups_per_dimension = std.math.min3(
        properties.limits.max_compute_work_group_count[0],
        properties.limits.max_compute_work_group_count[1],
        properties.limits.max_compute_work_group_count[2],
    );

    return limits;
}
