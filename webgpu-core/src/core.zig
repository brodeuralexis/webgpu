const std = @import("std");

pub const Adapter = @import("Adapter.zig");
pub const BindGroup = @import("BindGroup.zig");
pub const BindGroupLayout = @import("BindGroupLayout.zig");
pub const Buffer = @import("Buffer.zig");
pub const CommandBuffer = @import("CommandBuffer.zig");
pub const CommandEncoder = @import("CommandEncoder.zig");
pub const ComputePassEncoder = @import("ComputePassEncoder.zig");
pub const ComputePipeline = @import("ComputePipeline.zig");
pub const Device = @import("Device.zig");
pub const Instance = @import("Instance.zig");
pub const PipelineLayout = @import("PipelineLayout.zig");
pub const QuerySet = @import("QuerySet.zig");
pub const Queue = @import("Queue.zig");
pub const RenderBundle = @import("RenderBundle.zig");
pub const RenderBundleEncoder = @import("RenderBundleEncoder.zig");
pub const RenderPassEncoder = @import("RenderPassEncoder.zig");
pub const RenderPipeline = @import("RenderPipeline.zig");
pub const Sampler = @import("Sampler.zig");
pub const ShaderModule = @import("ShaderModule.zig");
pub const Surface = @import("Surface.zig");
pub const SwapChain = @import("SwapChain.zig");
pub const Texture = @import("Texture.zig");
pub const TextureView = @import("TextureView.zig");

pub const AdapterType = enum(u32) {
    discrete_gpu = 0x0000_0001,
    integrated_gpu = 0x0000_0002,
    cpu = 0x0000_0003,
    unknown = 0x0000_0004,
};

pub const AddressMode = enum(u32) {
    repeat = 0x0000_0000,
    mirror_repeat = 0x0000_0002,
    clamp_to_edge = 0x0000_0003,
};

pub const BackendType = enum(u32) {
    webgpu = 0x0000_0001,
    d3d11 = 0x0000_0002,
    d3d12 = 0x0000_0003,
    metal = 0x0000_0004,
    vulkan = 0x0000_0005,
    opengl = 0x0000_0006,
    opengles = 0x0000_0007,
};

pub const BlendFactor = enum(u32) {
    zero = 0x000_00000,
    one = 0x000_00001,
    src = 0x000_00002,
    one_minus_src = 0x000_00003,
    src_alpha = 0x000_00004,
    one_minus_src_alpha = 0x000_00005,
    dst = 0x000_00006,
    one_minus_dst = 0x000_00007,
    dst_alpha = 0x000_00008,
    one_minus_dst_alpha = 0x000_00009,
    src_alpha_saturated = 0x000_0000A,
    constant = 0x000_0000B,
    one_minus_constant = 0x000_0000C,
};

pub const BlendOperation = enum(u32) {
    add = 0x0000_0000,
    subtract = 0x0000_0001,
    reverse_subtract = 0x0000_0002,
    min = 0x0000_0003,
    max = 0x0000_0004,
};

pub const BufferBindingType = enum(u32) {
    uniform = 0x0000_0001,
    storage = 0x0000_0002,
    read_only_storage = 0x0000_0003,
};

pub const BufferMapAsyncError = error{
    Error,
    Unknown,
    DeviceLost,
    DestroyedBeforeCallback,
    UnmappedBeforeCallback,
};

pub const CompareFunction = enum(u32) {
    never = 0x0000_0001,
    less = 0x0000_0002,
    less_equal = 0x0000_0003,
    greater = 0x0000_0004,
    greater_equal = 0x0000_0005,
    equal = 0x0000_0006,
    not_equal = 0x0000_0007,
    always = 0x0000_0008,
};

pub const CompilationInfoRequestError = error{
    Error,
    DeviceLost,
    Unknown,
};

pub const CompilationMessageType = enum(u32) {
    err = 0x0000_0000,
    warn = 0x0000_0001,
    info = 0x0000_0002,
};

pub const ComputePassTimestampLocation = enum(u32) {
    beginning = 0x0000_0000,
    end = 0x0000_0001,
};

pub const CreatePipelineAsyncError = error{
    Error,
    DeviceLost,
    DeviceDestroyed,
    Unknown,
};

pub const CullMode = enum(u32) {
    none = 0x0000_0000,
    front = 0x0000_0001,
    back = 0x0000_0002,
};

pub const DeviceLostReason = enum(u32) {
    destroyed = 0x0000_0001,
};

pub const ErrorFilter = enum(u32) {
    validation = 0x0000_0000,
    out_of_memory = 0x0000_0001,
};

pub const ErrorTyoe = enum(u32) {
    validation = 0x0000_0001,
    out_of_memory = 0x0000_0002,
    unknown = 0x0000_0003,
    device_lost = 0x0000_0004,
};

pub const FeatureName = enum(u32) {
    depth_clip_control = 0x0000_0001,
    depth24_unorm_stencil8 = 0x0000_0002,
    depth32_float_stencil8 = 0x0000_0003,
    timestamp_query = 0x0000_0004,
    pipeline_statistics_query = 0x0000_0005,
    texture_compression_bc = 0x0000_0006,
    texture_compression_etc2 = 0x0000_0007,
    texture_compression_astc = 0x0000_0008,
    indirect_first_instance = 0x0000_0009,
};

pub const FilterMode = enum(u32) {
    nearest = 0x0000_0000,
    linear = 0x0000_0001,
};

pub const FrontFace = enum(u32) {
    ccw = 0x0000_0000,
    cw = 0x0000_0001,
};

pub const IndexFormat = enum(u32) {
    uint16 = 0x0000_0001,
    uint32 = 0x0000_0002,
};

pub const LoadOp = enum(u32) {
    clear = 0x0000_0001,
    load = 0x0000_0002,
};

pub const MipmapFilterMode = enum(u32) {
    nearest = 0x0000_0000,
    linear = 0x0000_0001,
};

pub const PipelineStatisticName = enum(u32) {
    vertex_shader_invocations = 0x0000_0000,
    clipper_invocations = 0x0000_0001,
    clipper_primitives_out = 0x0000_0002,
    fragment_shader_invocations = 0x0000_0003,
    compute_shader_invocations = 0x0000_0004,
};

pub const PowerPreference = enum(u32) {
    low_power = 0x0000_0001,
    high_performance = 0x0000_0002,
};

pub const PredefinedColorSpace = enum(u32) {
    srgb = 0x0000_0001,
};

pub const PresentMode = enum(u32) {
    immediate = 0x0000_0000,
    mailbox = 0x0000_0001,
    fifo = 0x0000_0002,
};

pub const PrimitiveTopology = enum(u32) {
    point_list = 0x0000_0000,
    line_list = 0x0000_0001,
    line_strip = 0x0000_0002,
    triangle_list = 0x0000_0003,
    triangle_strip = 0x0000_0004,
};

pub const QueryType = enum(u32) {
    occlusion = 0x0000_0000,
    pipeline_statistics = 0x0000_0001,
    timestamp = 0x0000_0002,
};

pub const QueueWorkDoneError = error{
    Error,
    Unknown,
    DeviceLost,
};

pub const RenderPassTiemstampLocation = enum(u32) {
    beginning = 0x0000_0000,
    end = 0x0000_0001,
};

pub const RequestAdapterError = error{
    Unavailable,
    Error,
    Unknown,
    OutOfMemory,
};

pub const RequestDeviceError = error{
    Error,
    Unknown,
};

pub const SType = enum(u32) {
    surface_descriptor_from_metal_layer = 0x0000_0001,
    surface_descriptor_from_windows_hwnd = 0x0000_0002,
    surface_descriptor_from_xlib_window = 0x0000_0003,
    surface_descriptor_from_canvas_html_selector = 0x0000_0004,
    shader_module_spirv_descriptor = 0x0000_0005,
    shader_module_wgsl_descriptor = 0x0000_0006,
    primitive_depth_clip_control = 0x0000_0007,
    surface_descriptor_from_wayland_surface = 0x0000_0008,
    surface_descriptor_from_android_native_window = 0x0000_0009,
    surface_descriptor_from_xcb_window = 0x0000_000A,
};

pub const SamplerBindingType = enum(u32) {
    filtering = 0x0000_0001,
    non_filtering = 0x0000_0002,
    comparison = 0x0000_0003,
};

pub const StencilOperation = enum(u32) {
    keep = 0x0000_0000,
    zero = 0x0000_0001,
    replace = 0x0000_0002,
    invert = 0x0000_0003,
    increment_clamp = 0x0000_0004,
    decrement_clamp = 0x0000_0005,
    increment_wrap = 0x0000_0006,
    decrement_wrap = 0x0000_0007,
};

pub const StorageTextureAccess = enum(u32) {
    write_only = 0x0000_0001,
};

pub const StoreOp = enum(u32) {
    store = 0x0000_0001,
    discard = 0x0000_0002,
};

pub const TextureAspect = enum(u32) {
    all = 0x0000_0000,
    stencil_only = 0x0000_0001,
    depth_only = 0x0000_0002,
};

pub const TextureComponentType = enum(u32) {
    float = 0x0000_0000,
    sint = 0x0000_0001,
    uint = 0x0000_0002,
    depth_comparison = 0x0000_0003,
};

pub const TextureDimension = enum(u32) {
    d1 = 0x0000_0000,
    d2 = 0x0000_0001,
    d3 = 0x0000_0002,
};

pub const TextureFormat = enum(u32) {
    r8_unorm = 0x0000_0001,
    r8_snorm = 0x0000_0002,
    r8_uint = 0x0000_0003,
    r8_sint = 0x0000_0004,
    r16_uint = 0x0000_0005,
    r16_sint = 0x0000_0006,
    r16_float = 0x0000_0007,
    rg8_unorm = 0x0000_0008,
    rg8_snorm = 0x0000_0009,
    rg8_uint = 0x0000_000A,
    rg8_sint = 0x0000_000B,
    r32_float = 0x0000_000C,
    r32_uint = 0x0000_000D,
    r32_sint = 0x0000_000E,
    rg16_uint = 0x0000_000F,
    rg16_sint = 0x0000_0010,
    rg16_float = 0x0000_0011,
    rgba8_unorm = 0x0000_0012,
    rgba8_unorm_srgb = 0x0000_0013,
    rgba8_snorm = 0x0000_0014,
    rgba8_uint = 0x0000_0015,
    rgba8_sint = 0x0000_0016,
    bgra8_unorm = 0x0000_0017,
    bgra8_unorm_srgb = 0x0000_0018,
    rgb10a2_unorm = 0x0000_0019,
    rg11b10_ufloat = 0x0000_001A,
    rgb9e5_ufloat = 0x0000_001B,
    rg32_float = 0x0000_001C,
    rg32_uint = 0x0000_001D,
    rg32_sint = 0x0000_001E,
    rgba16_uint = 0x0000_001F,
    rgba16_sint = 0x0000_0020,
    rgba16_float = 0x0000_0021,
    rgba32_float = 0x0000_0022,
    rgba32_uint = 0x0000_0023,
    rgba32_sint = 0x0000_0024,
    stencil8 = 0x0000_0025,
    depth16_unorm = 0x0000_0026,
    depth24_plus = 0x0000_0027,
    depth24_plus_stencil8 = 0x0000_0028,
    depth24_unorm_stencil8 = 0x0000_0029,
    depth32_float = 0x0000_002A,
    depth32_float_stencil8 = 0x0000_002B,
    bc1rgba_unorm = 0x0000_002C,
    bc1rgba_unorm_srgb = 0x0000_002D,
    bc2rgba_unorm = 0x0000_002E,
    bc2rgba_unorm_srgb = 0x0000_002F,
    bc3rgba_unorm = 0x0000_0030,
    bc3rgba_unorm_srgb = 0x0000_0031,
    bc4r_unorm = 0x0000_0032,
    bc4r_snorm = 0x0000_0033,
    bc5rg_unorm = 0x0000_0034,
    bc5rg_snorm = 0x0000_0035,
    bc6hrgb_ufloat = 0x0000_0036,
    bc6hrgb_float = 0x0000_0037,
    bc7rgba_unorm = 0x0000_0038,
    bc7rgba_unorm_srgb = 0x0000_0039,
    etc2rgb8_unorm = 0x0000_003A,
    etc2rgb8_unorm_srgb = 0x0000_003B,
    etc2rgb8a1_unorm = 0x0000_003C,
    etc2rgb8a1_unorm_srgb = 0x0000_003D,
    etc2rgba8_unorm = 0x0000_003E,
    etc2rgba8_unorm_srgb = 0x0000_003F,
    eacr11_unorm = 0x0000_0040,
    eacr11_snorm = 0x0000_0041,
    eacrg11_unorm = 0x0000_0042,
    eacrg11_snorm = 0x0000_0043,
    astc4x4_unorm = 0x0000_0044,
    astc4x4_unorm_srgb = 0x0000_0045,
    astc5x4_unorm = 0x0000_0046,
    astc5x4_unorm_srgb = 0x0000_0047,
    astc5x5_unorm = 0x0000_0048,
    astc5x5_unorm_srgb = 0x0000_0049,
    astc6x5_unorm = 0x0000_004A,
    astc6x5_unorm_srgb = 0x0000_004B,
    astc6x6_unorm = 0x0000_004C,
    astc6x6_unorm_srgb = 0x0000_004D,
    astc8x5_unorm = 0x0000_004E,
    astc8x5_unorm_srgb = 0x0000_004F,
    astc8x6_unorm = 0x0000_0050,
    astc8x6_unorm_srgb = 0x0000_0051,
    astc8x8_unorm = 0x0000_0052,
    astc8x8_unorm_srgb = 0x0000_0053,
    astc10x5_unorm = 0x0000_0054,
    astc10x5_unorm_srgb = 0x0000_0055,
    astc10x6_unorm = 0x0000_0056,
    astc10x6_unorm_srgb = 0x0000_0057,
    astc10x8_unorm = 0x0000_0058,
    astc10x8_unorm_srgb = 0x0000_0059,
    astc10x10_unorm = 0x0000_005A,
    astc10x10_unorm_srgb = 0x0000_005B,
    astc12x10_unorm = 0x0000_005C,
    astc12x10_unorm_srgb = 0x0000_005D,
    astc12x12_unorm = 0x0000_005E,
    astc12x12_unorm_srgb = 0x0000_005F,
};

pub const TextureSampleType = enum(u32) {
    float = 0x0000_0001,
    unfilterable_float = 0x0000_0002,
    depth = 0x0000_0003,
    sint = 0x0000_0004,
    uint = 0x0000_0005,
};

pub const TextureViewDimension = enum(u32) {
    d1 = 0x00000001,
    d2 = 0x00000002,
    d2_array = 0x00000003,
    cube = 0x00000004,
    cube_array = 0x00000005,
    d3 = 0x00000006,
};

pub const VertexFormat = enum(u32) {
    uint8x2 = 0x0000_0001,
    uint8x4 = 0x0000_0002,
    sint8x2 = 0x0000_0003,
    sint8x4 = 0x0000_0004,
    unorm8x2 = 0x0000_0005,
    unorm8x4 = 0x0000_0006,
    snorm8x2 = 0x0000_0007,
    snorm8x4 = 0x0000_0008,
    uint16x2 = 0x0000_0009,
    uint16x4 = 0x0000_000A,
    sint16x2 = 0x0000_000B,
    sint16x4 = 0x0000_000C,
    unorm16x2 = 0x0000_000D,
    unorm16x4 = 0x0000_000E,
    snorm16x2 = 0x0000_000F,
    snorm16x4 = 0x0000_0010,
    float16x2 = 0x0000_0011,
    float16x4 = 0x0000_0012,
    float32 = 0x0000_0013,
    float32x2 = 0x0000_0014,
    float32x3 = 0x0000_0015,
    float32x4 = 0x0000_0016,
    uint32 = 0x0000_0017,
    uint32x2 = 0x0000_0018,
    uint32x3 = 0x0000_0019,
    uint32x4 = 0x0000_001A,
    sint32 = 0x0000_001B,
    sint32x2 = 0x0000_001C,
    sint32x3 = 0x0000_001D,
    sint32x4 = 0x0000_001E,
};

pub const VertexStepMode = enum(u32) {
    vertex = 0x0000_0000,
    instance = 0x0000_0001,
};

pub const BufferUsage = struct {
    map_read: bool = false,
    map_write: bool = false,
    copy_src: bool = false,
    copy_dst: bool = false,
    index: bool = false,
    vertex: bool = false,
    uniform: bool = false,
    storage: bool = false,
    indirect: bool = false,
    query_resolve: bool = false,
};

pub const ColorWriteMask = struct {
    red: bool = false,
    green: bool = false,
    blue: bool = false,
    alpha: bool = false,

    pub const all = ColorWriteMask{ .red = true, .green = true, .blue = true, .alpha = true };
};

pub const MapMode = packed struct {
    read: bool = false,
    write: bool = false,
    _padding: u30 = 0,
};

pub const ShaderStage = packed struct {
    vertex: bool = false,
    fragment: bool = false,
    compute: bool = false,
    _padding: u29 = 0,
};

pub const TextureUsage = struct {
    copy_src: bool = false,
    copy_dst: bool = false,
    texture_binding: bool = false,
    storage_binding: bool = false,
    render_attachment: bool = false,
};

pub const AdapterProperties = struct {
    vendor_id: u32,
    device_id: u32,
    name: [:0]const u8,
    driver_descriptor: [:0]const u8,
    adapter_type: AdapterType,
    backend_type: BackendType,
};

pub const BindGroupEntry = struct {
    binding: u32,
    buffer: ?Buffer,
    offset: u64,
    size: u64,
    sampler: ?Sampler,
    texture_view: ?TextureView,
};

pub const BlendComponent = struct {
    operation: BlendOperation,
    src_factor: BlendFactor,
    dst_factor: BlendFactor,
};

pub const BufferBindingLayout = struct {
    label: ?[:0]const u8 = null,
    has_dynamic_offset: bool,
    min_binding_size: u64,
};

pub const BufferDescriptor = struct {
    label: ?[:0]const u8 = null,
    usage: BufferUsage,
    size: u64,
    mapped_at_creation: bool,
};

pub const Color = struct {
    r: f64 = 0,
    g: f64 = 0,
    b: f64 = 0,
    a: f64 = 0,
};

pub const CommandBufferDescriptor = struct {
    label: ?[:0]const u8 = null,
};

pub const CommandEncoderDescriptor = struct {
    label: ?[:0]const u8 = null,
};

pub const CompilationMessage = struct {
    message: ?[:0]const u8,
    message_type: CompilationMessageType,
    line_num: u64,
    line_pos: u64,
    offset: u64,
    length: u64,
};

pub const ComputePassTimestampWrite = struct {
    query_set: QuerySet,
    query_index: u32,
    location: ComputePassTimestampLocation,
};

pub const ConstantEntry = struct {
    key: [:0]const u8,
    value: f64,
};

pub const Extent3D = struct {
    width: u32,
    height: u32,
    depth_or_array_layers: u32 = 0,
};

pub const InstanceDescriptor = struct {};

pub const Limits = struct {
    max_texture_dimension1d: u32,
    max_texture_dimension2d: u32,
    max_texture_dimension3d: u32,
    max_texture_array_layers: u32,
    max_bind_groups: u32,
    max_dynamic_uniform_buffers_per_pipeline_layout: u32,
    max_dynamic_storage_buffers_per_pipeline_layout: u32,
    max_sampled_textures_per_shader_stage: u32,
    max_samplers_per_shader_stage: u32,
    max_storage_buffers_per_shader_stage: u32,
    max_storage_textures_per_shader_stage: u32,
    max_uniform_buffers_per_shader_stage: u32,
    max_uniform_buffer_binding_size: u64,
    max_storage_buffer_binding_size: u64,
    min_uniform_buffer_offset_alignment: u32,
    min_storage_buffer_offset_alignment: u32,
    max_vertex_buffers: u32,
    max_vertex_attributes: u32,
    max_vertex_buffer_array_stride: u32,
    max_inter_stage_shader_components: u32,
    max_compute_workgroup_storage_size: u32,
    max_compute_invocations_per_workgroup: u32,
    max_compute_workgroup_size_x: u32,
    max_compute_workgroup_size_y: u32,
    max_compute_workgroup_size_z: u32,
    max_compute_workgroups_per_dimension: u32,
};

pub const MultisampleState = struct {
    count: u32,
    mask: u32,
    alpha_to_coverage_enabled: bool,
};

pub const Origin3D = struct {
    x: u32 = 0,
    y: u32 = 0,
    z: u32 = 0,
};

pub const PipelineLayoutDescriptor = struct {
    label: ?[:0]const u8 = null,
    bind_group_layouts: []const BindGroupLayout,
};

pub const PrimitiveDepthClipControl = struct {
    unclipped_depth: bool,
};

pub const PrimitiveState = struct {
    topology: PrimitiveTopology,
    strip_index_format: IndexFormat,
    front_face: FrontFace,
    cull_mode: CullMode,
};

pub const QuerySetDescriptor = struct {
    label: ?[:0]const u8 = null,
    query_type: QueryType,
    count: u32,
    pipeline_statistics: []const PipelineStatisticName,
};

pub const QueueDescriptor = struct {
    label: ?[:0]const u8 = null,
};

pub const RenderBundleDescriptor = struct {
    label: ?[:0]const u8 = null,
};

pub const RenderBundleEncoderDescriptor = struct {
    label: ?[:0]const u8 = null,
    color_formats: []const TextureFormat,
    depth_stencil_format: TextureFormat,
    sample_count: u32,
    depth_read_only: bool,
    stencil_read_only: bool,
};

pub const RenderPassDepthStencilAttachment = struct {
    view: TextureView,
    depth_load_op: LoadOp,
    depth_store_op: StoreOp,
    depth_clear_value: f32,
    depth_read_only: bool,
    stencil_load_op: LoadOp,
    stencil_store_op: StoreOp,
    stencil_clear_value: u32,
    stencil_read_only: bool,
};

pub const RenderPassTimestampWrite = struct {
    query_set: QuerySet,
    query_index: u32,
    location: RenderPassTiemstampLocation,
};

pub const RequestAdapterOptions = struct {
    compatible_surface: ?Surface = null,
    power_preference: ?PowerPreference = null,
    force_fallback_adapter: bool = false,
};

pub const SamplerBindingLayout = struct {
    sampler_binding_type: SamplerBindingType,
};

pub const SamplerDescriptor = struct {
    label: ?[:0]const u8 = null,
    address_mode_u: AddressMode = .repeat,
    address_mode_v: AddressMode = .repeat,
    address_mode_w: AddressMode = .repeat,
    mag_filter: FilterMode = .linear,
    min_filter: FilterMode = .linear,
    mipmap_filter: MipmapFilterMode = .linear,
    lod_min_clamp: f32,
    lod_max_clamp: f32,
    compare: CompareFunction,
    max_anisotropy: u16 = 0,
};

pub const ShaderModuleCompilationHint = struct {
    entry_point: [:0]const u8,
    layout: PipelineLayout,
};

pub const StencilFaceState = struct {
    compare: CompareFunction,
    fail_op: StencilOperation,
    depth_fail_op: StencilOperation,
    pass_op: StencilOperation,
};

pub const StorageTextureBindingLayout = struct {
    access: StorageTextureAccess,
    format: TextureFormat,
    view_dimension: TextureViewDimension,
};

pub const SurfaceDescriptor = struct {
    label: ?[:0]const u8 = null,
    from: ?union(enum) {
        android_native_window: *anyopaque,
        canvas_html_selector: [:0]const u8,
        metal_layer: *anyopaque,
        wayland_surface: struct {
            display: *anyopaque,
            surface: *anyopaque,
        },
        windows_hwnd: struct {
            hinstance: *anyopaque,
            hwnd: *anyopaque,
        },
        xcb_window: struct {
            connection: *anyopaque,
            window: u32,
        },
        xlib_window: struct {
            display: *anyopaque,
            window: u32,
        },
    } = null,
};

pub const SwapChainDescriptor = struct {
    label: ?[:0]const u8 = null,
    usage: TextureUsage,
    format: TextureFormat,
    width: u32,
    height: u32,
    present_mode: PresentMode,
};

pub const TextureBindingLayout = struct {
    sample_type: TextureSampleType,
    view_dimension: TextureViewDimension,
    multisampled: bool,
};

pub const TextureDataLayout = struct {
    offset: u64,
    bytes_per_row: u32,
    rows_per_image: u32,
};

pub const TextureViewDescriptor = struct {
    label: ?[:0]const u8 = null,
    format: TextureFormat,
    dimension: TextureViewDimension,
    base_mip_level: u32,
    mip_level_count: u32,
    base_array_layer: u32,
    array_layer_count: u32,
    aspect: TextureAspect,
};

pub const VertexAttribute = struct {
    format: VertexFormat,
    offset: u64,
    shader_location: u32,
};

pub const BindGroupDescriptor = struct {
    label: ?[:0]const u8 = null,
    layout: BindGroupLayout,
    entries: []const BindGroupEntry,
};

pub const BindGroupLayoutEntry = struct {
    binding: u32,
    visibility: ShaderStage,
    buffer: BufferBindingLayout,
    sampler: SamplerBindingLayout,
    texture: TextureBindingLayout,
    storage_texture: StorageTextureBindingLayout,
};

pub const BlendState = struct {
    color: BlendComponent,
    alpha: BlendComponent,
};

pub const CompilationInfo = struct {
    messages: []const CompilationMessage,
};

pub const ComputePassDescriptor = struct {
    label: ?[:0]const u8 = null,
    timestamp_writes: []const ComputePassTimestampWrite,
};

pub const DepthStencilState = struct {
    format: TextureFormat,
    depth_write_enabled: bool,
    depth_compare: CompareFunction,
    stencil_front: StencilFaceState,
    stencil_back: StencilFaceState,
    stencil_read_mask: u32,
    stencil_write_mask: u32,
    depth_bias: i32,
    depth_bias_slope_scale: f32,
    depth_bias_clamp: f32,
};

pub const ImageCopyBuffer = struct {
    layout: TextureDataLayout,
    buffer: Buffer,
};

pub const ImageCopyTexture = struct {
    texture: Texture,
    mip_level: u32,
    origin: Origin3D,
    aspect: TextureAspect,
};

pub const ProgrammableStageDescriptor = struct {
    module: ShaderModule,
    entry_point: [:0]const u8,
    constants: []const ConstantEntry,
};

pub const RenderPassColorAttachment = struct {
    view: ?TextureView,
    resolve_target: ?TextureView,
    load_op: LoadOp,
    store_op: StoreOp,
    clear_value: Color,
};

pub const ShaderModuleDescriptor = struct {
    label: ?[:0]const u8 = null,
    hints: []const ShaderModuleCompilationHint,
};

pub const TextureDescriptor = struct {
    label: ?[:0]const u8 = null,
    usage: TextureUsage,
    dimension: TextureDimension,
    size: Extent3D,
    format: TextureFormat,
    mip_level_count: u32,
    sample_count: u32,
    view_formats: []const TextureFormat,
};

pub const VertexBufferLayout = struct {
    array_stride: u64,
    step_mode: VertexStepMode,
    attributes: []const VertexAttribute,
};

pub const BindGroupLayoutDescriptor = struct {
    label: ?[:0]const u8 = null,
    entries: []const BindGroupLayoutEntry,
};

pub const ColorTargetState = struct {
    format: TextureFormat,
    blend: ?BlendState = null,
    write_mask: ColorWriteMask,
};

pub const ComputePipelineDescriptor = struct {
    label: ?[:0]const u8 = null,
    layout: ?PipelineLayout = null,
    compute: ProgrammableStageDescriptor,
};

pub const DeviceDescriptor = struct {
    label: ?[:0]const u8 = null,
    required_features: []const FeatureName = &[0]FeatureName{},
    required_limits: ?Limits = null,
    default_queue: QueueDescriptor = .{}
};

pub const RenderPassDescriptor = struct {
    label: ?[:0]const u8 = null,
    color_attachments: []const RenderPassColorAttachment,
    depth_stencil_attachment: ?RenderPassDepthStencilAttachment = null,
    occlusion_query_set: ?QuerySet = null,
    timestamp_writes: []const RenderPassTimestampWrite,
};

pub const VertexState = struct {
    module: ShaderModule,
    entry_point: [:0]const u8,
    constants: []const ConstantEntry,
    buffers: []const VertexBufferLayout,
};

pub const FragmentState = struct {
    module: ShaderModule,
    entry_point: [:0]const u8,
    constants: []const ConstantEntry,
    targets: []const ColorTargetState,
};

pub const RenderPipelineDescriptor = struct {
    label: ?[:0]const u8 = null,
    layout: ?PipelineLayout = null,
    vertex: VertexState,
    primitive: PrimitiveState,
    depth_stencil: ?DepthStencilState = null,
    multisample: MultisampleState,
    fragment: ?FragmentState = null,
};
