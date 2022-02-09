const std = @import("std");

const Allocator = std.mem.Allocator;

const webgpu = @import("../../../webgpu.zig");
const vulkan = @import("../vulkan.zig");
const vk = @import("../vk.zig");
const queue_families = @import("../queue_families.zig");

const Adapter = @This();

pub const vtable = webgpu.Adapter.VTable{
    .request_device_fn = requestDevice,
};

super: webgpu.Adapter,

instance: *vulkan.Instance,

handle: vk.PhysicalDevice,

features: webgpu.Features,
limits: webgpu.Limits,
properties: webgpu.AdapterProperties,

families: queue_families.QueueFamilies,


pub fn create(instance: *vulkan.Instance, physical_device: vk.PhysicalDevice) !*Adapter {
    var adapter = try instance.allocator.create(Adapter);
    errdefer instance.allocator.destroy(adapter);

    adapter.super.__vtable = &vtable;

    adapter.instance = instance;

    adapter.handle = physical_device;

    var features = instance.vki.getPhysicalDeviceFeatures(physical_device);

    var driver: vk.PhysicalDeviceDriverProperties = undefined;
    driver.s_type = .physical_device_driver_properties;
    driver.p_next = null;

    var properties2: vk.PhysicalDeviceProperties2 = undefined;
    properties2.s_type = .physical_device_properties_2;
    properties2.p_next = &driver;

    instance.vki.getPhysicalDeviceProperties2(physical_device, &properties2);

    adapter.features = calculateSupportedFeatures(features);
    adapter.super.features = &adapter.features;
    adapter.limits = calculateSupportedLimits(properties2.properties);
    adapter.super.limits = &adapter.limits;
    adapter.properties = try calculateProperties(adapter, properties2.properties, driver);
    errdefer {
        instance.allocator.free(adapter.properties.name);
        instance.allocator.free(adapter.properties.driver_descripton);
    }
    adapter.super.properties = &adapter.properties;

    adapter.families = try queue_families.find(instance, physical_device);

    return adapter;
}

pub fn destroy(adapter: *Adapter) void {
    adapter.instance.allocator.free(adapter.properties.name);
    adapter.instance.allocator.free(adapter.properties.driver_descripton);
    adapter.instance.allocator.destroy(adapter);
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

fn calculateSupportedFeatures(_features: vk.PhysicalDeviceFeatures) webgpu.Features {
    var features = webgpu.Features{};

    features.texture_compression_bc = _features.texture_compression_bc == vk.TRUE;
    features.texture_compression_etc2 = _features.texture_compression_etc2 == vk.TRUE;
    features.texture_compression_astc = _features.texture_compression_astc_ldr == vk.TRUE;
    features.timestamp_query = _features.pipeline_statistics_query == vk.TRUE and _features.occlusion_query_precise == vk.TRUE;
    features.indirect_first_instance = _features.draw_indirect_first_instance == vk.TRUE;

    return features;
}

fn calculateSupportedLimits(properties: vk.PhysicalDeviceProperties) webgpu.Limits {
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

fn calculateProperties(adapter: *Adapter, properties: vk.PhysicalDeviceProperties, driver: vk.PhysicalDeviceDriverProperties) !webgpu.AdapterProperties {
    const name = try adapter.instance.allocator.dupeZ(u8, std.mem.sliceTo(&properties.device_name, 0));
    errdefer adapter.instance.allocator.free(name);

    const driver_descripton = try adapter.instance.allocator.dupeZ(u8, std.mem.sliceTo(&driver.driver_info, 0));
    errdefer adapter.instance.allocator.free(driver_descripton);

    return webgpu.AdapterProperties{
        .device_id = properties.device_id,
        .vendor_id = properties.vendor_id,
        .name = name,
        .driver_descripton = driver_descripton,
        .adapter_type = switch (properties.device_type) {
            .integrated_gpu => .integrated_gpu,
            .discrete_gpu => .discrete_gpu,
            .cpu => .cpu,
            else => .unknown,
        },
        .backend_type = .vulkan,
    };
}
