const std = @import("std");
const webgpu = @import("./webgpu.zig");

pub const AdapterProperties = struct {
    vendor_id: u32,
    device_id: u32,
    name: [:0]const u8,
    driver_descripton: [:0]const u8,
    adapter_type: webgpu.AdapterType,
    backend_type: webgpu.BackendType,
};

pub const BufferBinding = struct {
    buffer: webgpu.Buffer,
    offset: u64 = 0,
    size: ?u64 = null,
};

pub const BindGroupResource = union {
    sampler: webgpu.Sampler,
    texture_view: webgpu.TextureView,
    buffer: BufferBinding,
};

pub const BindGroupEntry = struct {
    binding: u32,
    resource: BindGroupResource,
};

pub const BlendComponent = struct {
    operation: webgpu.BlendOperation = .add,
    src_factor: webgpu.BlendFactor = .one,
    dst_factor: webgpu.BlendFactor = .zero,
};

pub const BufferBindingLayout = struct {
    ty: webgpu.BufferBindingType = .uniform,
    has_dynamic_offset: bool = false,
    min_binding_size: u64 = 0,
};

pub const BufferDescriptor = struct {
    label: ?[:0]const u8 = null,
    usage: webgpu.BufferUsage,
    size: u64,
    mapped_at_creation: bool = false,
};

pub const Color = struct {
    r: f64,
    g: f64,
    b: f64,
    a: f64,
};

pub const CommandBufferDescriptor = struct {
    label: ?[:0]const u8 = null,
};

pub const CommandEncoderDescriptor = struct {
    label: ?[:0]const u8 = null,
};

pub const CompilationMessage = struct {
    message: [:0]const u8,
    ty: webgpu.CompilationMessageType,
    line_num: u64,
    line_pos: u64,
    offset: u64,
    length: u64,
};

pub const ComputePassTimestampWrite = struct {
    query_set: webgpu.QuerySet,
    query_index: u32,
    location: webgpu.ComputePassTimestampLocation,
};

pub const ConstantEntry = struct {
    key: [:0]const u8,
    value: f64,
};

pub const Extend3D = struct {
    width: u32,
    height: u32,
    depth_or_array_layers: u32 = 1,
};

pub const InstanceDescriptor = struct {
    allocator: std.mem.Allocator = std.heap.c_allocator,
};

pub const Limits = struct {
    max_texture_dimension1d: u32 = 8192,
    max_texture_dimension2d: u32 = 8192,
    max_texture_dimension3d: u32 = 2048,
    max_texture_array_layers: u32 = 256,
    max_bind_groups: u32 = 4,
    max_dynamic_uniform_buffers_per_pipeline_layout: u32 = 8,
    max_dynamic_storage_buffers_per_pipeline_layout: u32 = 4,
    max_sampled_textures_per_shader_stage: u32 = 16,
    max_samplers_per_shader_stage: u32 = 16,
    max_storage_buffers_per_shader_stage: u32 = 8,
    max_storage_textures_per_shader_stage: u32 = 4,
    max_uniform_buffers_per_shader_stage: u32 = 12,
    max_uniform_buffer_binding_size: u64 = 65536,
    max_storage_buffer_binding_size: u64 = 134217728,
    min_uniform_buffer_offset_alignment: u32 = 256,
    min_storage_buffer_offset_alignment: u32 = 256,
    max_vertex_buffers: u32 = 8,
    max_vertex_attributes: u32 = 16,
    max_vertex_buffer_array_stride: u32 = 2048,
    max_inter_stage_shader_components: u32 = 60,
    max_compute_workgroup_storage_size: u32 = 16352,
    max_compute_invocations_per_workgroup: u32 = 256,
    max_compute_workgroup_size_x: u32 = 256,
    max_compute_workgroup_size_y: u32 = 256,
    max_compute_workgroup_size_z: u32 = 64,
    max_compute_workgroups_per_dimension: u32 = 65535,
};

pub const MultisampleState = struct {
    count: u32 = 1,
    mask: u32 = 0xFFFFFFFF,
    alpha_to_coverage_enabled: bool = false,
};

pub const Origin3D = struct {
    x: u32 = 0,
    y: u32 = 0,
    z: u32 = 0,

    pub const zero = Origin3D{};
};

pub const PipelineLayoutDescriptor = struct {
    label: ?[:0]const u8 = null,
    bind_group_layouts: []webgpu.BindGroupLayout,
};

pub const PrimitiveState = struct {
    topology: webgpu.PrimitiveTopology = .triangle_list,
    strip_index_format: ?webgpu.IndexFormat = null,
    front_face: webgpu.FrontFace = .cww,
    cull_mode: ?webgpu.CullMode = null,
    unclipped_depth: bool = false,
};

pub const QuerySetDescriptor = struct {
    label: ?[:0]const u8 = null,
    ty: webgpu.QueryType,
    pipeline_statistics: []webgpu.PipelineStatisticName,
};

pub const RenderBundleEncoderDescriptor = struct {
    label: ?[:0]const u8 = null,
    color_formats: []webgpu.TextureFormat,
    depth_stencil_format: ?webgpu.TextureFormat = null,
    sample_count: u32 = 1,
    depth_read_only: bool = false,
    depth_write_only: bool = false,
};

pub const RenderPassDepthStencilAttachment = struct {
    view: webgpu.TextureView,

    depth_clear_value: f32 = 0,
    depth_load_op: ?webgpu.LoadOp = null,
    depth_store_op: ?webgpu.StoreOp = null,
    depth_read_only: bool = false,

    stencil_clear_value: f32 = 0,
    stencil_load_op: ?webgpu.LoadOp = null,
    stencil_store_op: ?webgpu.StoreOp = null,
    stencil_read_only: bool = false,
};

pub const RenderPassTimestampWrite = struct {
    query_set: webgpu.QuerySet,
    query_index: u32,
    location: webgpu.RenderPassTimestampLocation,
};

pub const RequestAdapterOptions = struct {
    compatible_surface: ?webgpu.Surface = null,
    power_preference: webgpu.PowerPreference = .low_power,
    force_fallback_adapter: bool = false,
};

pub const SamplerBindingLayout = struct {
    ty: webgpu.SamplerBindingType = .filtering,
};

pub const SamplerDescriptor = struct {
    label: ?[:0]const u8 = null,
    address_mode_u: webgpu.AddressMode = .clamp_to_edge,
    address_mode_v: webgpu.AddressMode = .clamp_to_edge,
    address_mode_w: webgpu.AddressMode = .clamp_to_edge,
    mag_filter: webgpu.FilterMode = .nearest,
    min_filter: webgpu.FilterMode = .nearest,
    mipmap_filter: webgpu.FilterMode = .nearest,
    lod_min_clamp: f32 = 0,
    lod_max_clamp: f32 = 32,
    compare: ?webgpu.CompareFunction = null,
    max_anisotropy: u16 = 1,
};

pub const ShaderModuleDescriptor = union {
    spirv: []const u32,
    wgsl: [:0]const u8,
};

pub const StencilFaceState = struct {
    compare: webgpu.CompareFunction = .always,
    fail_op: webgpu.StencilOperation = .keep,
    depth_fail_op: webgpu.StencilOperation = .keep,
    pass_op: webgpu.StencilOperation = .keep,
};

pub const StorageTextureBindingLayout = struct {
    access: webgpu.StorageTextureAccess = .write_only,
    format: webgpu.TextureFormat,
    view_dimension: webgpu.TextureViewDimension = .d2,
};

pub const SurfaceDescriptor = struct {
    label: ?[:0]const u8 = null,
    platform: SurfacePlatformDescriptor,
};

pub const SurfacePlatformDescriptor = union {
    canvas: struct {
        html_selector: [:0]const u8,
    },
    metal: struct {
        layer: *anyopaque,
    },
    windows: struct {
        hinstance: *anyopaque,
        hwnd: *anyopaque,
    },
    xlib: struct {
        display: *anyopaque,
        window: u32,
    },
    wayland: struct {
        display: *anyopaque,
        surface: *anyopaque,
    },
    android: struct {
        window: *anyopaque,
    },
};

pub const SwapChainDescriptor = struct {
    label: ?[:0]const u8 = null,
    usage: webgpu.TextureUsage = .render_attachment,
    format: webgpu.TextureFormat = .bgra8_unorm,
    width: u32,
    height: u32,
    present_mode: webgpu.PresentMode = .fifo,
};

pub const TextureBindingLayout = struct {
    sample_type: webgpu.TextureSampleType = .float,
    view_dimension: webgpu.TextureViewDimension = .d2,
    multisampled: bool = false,
};

pub const TextureDataLayout = struct {
    offset: u64 = 0,
    bytes_per_row: u32 = 1,
    rows_per_image: u32 = 1,
};

pub const TextureViewDescriptor = struct {
    label: ?[:0]const u8 = null,
    format: ?webgpu.TextureFormat = null,
    dimension: ?webgpu.TextureViewDimension = null,
    aspect: ?webgpu.TextureAspect = .all,
    base_mip_level: u32 = 0,
    mip_level_count: u32 = 0,
    base_array_layer: u32 = 0,
    array_layer_count: u32 = 0,
};

pub const VertexAttribute = struct {
    format: webgpu.VertexFormat,
    offset: u64,
    shader_location: u32,
};

pub const BindGroupDescriptor = struct {
    label: ?[:0]const u8 = null,
    layout: webgpu.BindGroupLayout,
    entries: []webgpu.BindGroupEntry,
};

pub const BindGroupLayoutEntry = struct {
    binding: u32 = null,
    visibility: webgpu.ShaderStage,

    buffer: ?webgpu.BufferBindingLayout = null,
    sampler: ?webgpu.SamplerBindingLayout = null,
    texture: ?webgpu.TextureBindingLayout = null,
    storage_texture: ?webgpu.StorageTextureBindingLayout = null,
};

pub const BlendState = struct {
    color: webgpu.BlendComponent,
    alpha: webgpu.BlendComponent,
};

pub const CompilationInfo = struct {
    messages: []webgpu.CompilationMessage,
};

pub const ComputePassDescriptor = struct {
    label: ?[:0]const u8 = null,
    timestamp_writes: []webgpu.ComputePassTimestampWrite = &.{},
};

pub const DepthStencilState = struct {
    format: webgpu.TextureFormat,

    depth_write_enabled: bool = false,
    depth_compare: webgpu.CompareFunction = .always,

    stencil_front: webgpu.StencilFaceState = .{},
    stencil_back: webgpu.StencilFaceState = .{},

    stencil_read_mask: u32 = 0xFFFFFFFF,
    stencil_write_mask: u32 = 0xFFFFFFFF,

    depth_bias: i32 = 0,
    depth_bias_slope_scale: f32 = 0,
    depth_bias_clamp: f32 = 0,
};

pub const ImageCopyBuffer = struct {
    layout: webgpu.TextureDataLayout = .{},
    buffer: webgpu.Buffer,
};

pub const ImageCopyTexture = struct {
    texture: webgpu.Texture,
    mip_level: u32 = 0,
    origin: webgpu.Origin3D = .{},
    aspect: webgpu.TextureAspect = .all,
};

pub const ProgrammableStageDescriptor = struct {
    module: webgpu.ShaderModule,
    entry_point: [:0]const u8,
    constants: []webgpu.ConstantEntry = &.{},
};

pub const RenderPassColorAttachment = struct {
    view: webgpu.TextureView,
    resolve_target: ?webgpu.TextureView = null,
    load_op: webgpu.LoadOp,
    store_op: webgpu.StoreOp,
    clear_color: ?webgpu.Color = null,
};

pub const TextureDescriptor = struct {
    label: ?[:0]const u8 = null,
    usage: webgpu.TextureUsage,
    dimension: webgpu.TextureDimension = .d2,
    size: u32,
    format: webgpu.TextureFormat,
    mip_level_count: u32 = 1,
    sample_count: u32 = 1,
};

pub const VertexBufferLayout = struct {
    array_stride: u64 = 0,
    step_mode: webgpu.VertexStepMode = .vertex,
    attributes: []webgpu.VertexAttribute,
};

pub const BindGroupLayoutDescriptor = struct {
    label: ?[:0]const u8 = null,
    entries: []webgpu.BindGroupLayoutEntry,
};

pub const ColorTargetState = struct {
    format: webgpu.TextureFormat,
    blend: ?webgpu.BlendState = null,
    write_mask: webgpu.ColorWriteMask = webgpu.ColorWriteMask.all,
};

pub const ComputePipelineDescriptor = struct {
    label: ?[:0]const u8 = null,
    layout: ?webgpu.PipelineLayout = null,
    compute: webgpu.ProgrammableStageDescriptor,
};

pub const DeviceDescriptor = struct {
    label: ?[:0]const u8 = null,
    required_features: webgpu.Features = .{},
    required_limits: webgpu.Limits = .{},
};

pub const RenderPassDescriptor = struct {
    label: ?[:0]const u8 = null,
    color_attachments: []webgpu.RenderPassColorAttachment,
    depth_stencil_attachment: ?webgpu.RenderPassDepthStencilAttachment = null,
    occlusion_query_set: ?webgpu.QuerySet = null,
    timestamp_writes: []webgpu.RenderPassTimestampWrite = &.{},
};

pub const VertexState = struct {
    module: webgpu.ShaderModule,
    entry_point: [:0]const u8,
    constants: []webgpu.ConstantEntry = &.{},
    buffers: []webgpu.VertexBufferLayout = &.{},
};

pub const FragmentState = struct {
    module: webgpu.ShaderModule,
    entry_point: [:0]const u8,
    constants: []webgpu.ConstantEntry = &.{},
    targets: []webgpu.ColorTargetState = &.{},
};

pub const RenderPipelineDescriptor = struct {
    label: ?[:0]const u8 = null,
    vertex: webgpu.VertexState,
    primitive: webgpu.PrimitiveState = .{},
    depth_stencil: ?webgpu.DepthStencilState = null,
    multisample: webgpu.MultisampleState = .{},
    fragment: ?webgpu.FragmentState = null,
};
