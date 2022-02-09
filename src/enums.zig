const std = @import("std");

pub const AdapterType = enum {
    discrete_gpu,
    integrated_gpu,
    cpu,
    unknown,
};

pub const AddressMode = enum {
    repeat,
    mirror_repeat,
    clamp_to_edge,
};

pub const BackendType = enum {
    webgpu,
    d3d11,
    d3d12,
    metal,
    vulkan,
    opengl,
    opengl_es,
    unknown,
};

pub const BlendFactor = enum {
    zero,
    one,
    src,
    one_minus_src,
    src_alpha,
    one_minus_src_alpha,
    dst,
    one_minus_dst,
    dst_alpha,
    one_minus_dst_alpha,
    src_alpha_saturated,
    constant,
    one_minus_constant,
};

pub const BlendOperation = enum {
    add,
    subtract,
    reverse_subtract,
    min,
    max,
};

pub const BufferBindingType = enum {
    uniform,
    storage,
    read_only_storage,
};

pub const CompareFunction = enum {
    never,
    less,
    less_equal,
    greater,
    greater_equal,
    equal,
    not_equal,
    always,
};

pub const CompilationMessageType = enum {
    err,
    warn,
    info,
};

pub const ComputePassTimestampLocation = enum {
    beginning,
    end,
};

pub const CullMode = enum {
    none,
    front,
    back,
};

pub const DeviceLostReason = enum {
    destroyed,
};

pub const ErrorFilter = enum {
    validation,
    out_of_memory,
};

pub const ErrorType = enum {
    no_error,
    validation,
    out_of_memory,
    unknown,
    device_lost,
};

pub const FilterMode = enum {
    nearest,
    linear,
};

pub const FrontFace = enum {
    ccw,
    cw,
};

pub const IndexFormat = enum {
    uint16,
    uint32,
};

pub const LoadOp = enum {
    clear,
    load,
};

pub const PipelineStatisticName = enum {
    vertex_shader_invocations,
    clipper_invocations,
    clipper_primitives_out,
    fragment_shader_invocations,
    compute_shader_invocations,
};

pub const PowerPreference = enum {
    low_power,
    high_performance,
};

pub const PresentMode = enum {
    immediate,
    mailbox,
    fifo,
};

pub const PrimitiveTopology = enum {
    point_list,
    line_list,
    list_strip,
    triangle_list,
    triangle_strip,
};

pub const QueryType = enum {
    occlusion,
    pipeline_statistics,
    timestamp,
};

pub const RenderPassTimestampLocation = enum {
    beginning,
    end,
};

pub const SamplerBindingType = enum {
    filtering,
    non_filtering,
    comparison,
};

pub const StencilOperation = enum {
    keep,
    zero,
    replace,
    invert,
    increment_clamp,
    decrement_clamp,
    increment_wrap,
    decrement_wrap,
};

pub const StorageTextureAccess = enum {
    write_only,
};

pub const StoreOp = enum {
    store,
    discard,
};

pub const TextureAspect = enum {
    all,
    stencil_only,
    depth_only,
};

pub const TextureComponentType = enum {
    float,
    sint,
    uint,
    depth_comparison,
};

pub const TextureDimension = enum {
    d1,
    d2,
    d3,
};

pub const TextureFormat = enum {
    r8_unorm,
    r8_snorm,
    r8_uint,
    r8_sint,
    r16_uint,
    r16_sint,
    r16_float,
    rg8_unorm,
    rg8_snorm,
    rg8_uint,
    rg8_sint,
    r32_float,
    r32_uint,
    r32_sint,
    rg16_uint,
    rg16_sint,
    rg16_float,
    rgba8_unorm,
    rgba8_unorm_srgb,
    rgba8_snorm,
    rgba8_uint,
    rgba8_sint,
    bgra8_unorm,
    bgra8_unorm_srgb,
    rgb10a2_unorm,
    rg11b10_ufloat,
    rgb9e5_ufloat,
    rg32_float,
    rg32_uint,
    rg32_sint,
    rgba16_uint,
    rgba16_sint,
    rgba16_float,
    rgba32_float,
    rgba32_uint,
    rgba32_sint,
    stencil8,
    depth16_unorm,
    depth24_plus,
    depth24_plus_stencil8,
    depth24_unorm_stencil8,
    depth32_float,
    depth32_float_stencil8,
    bc1rgba_unorm,
    bc1rgba_unorm_srgb,
    bc2rgba_unorm,
    bc2rgba_unorm_srgb,
    bc3rgba_unorm,
    bc3rgba_unorm_srgb,
    bc4r_unorm,
    bc4r_snorm,
    bc5rg_unorm,
    bc5rg_snorm,
    bc6hrgb_ufloat,
    bc6hrgb_float,
    bc7rgba_unorm,
    bc7rgba_unorm_srgb,
    etc2rgb8_unorm,
    etc2rgb8_unorm_srgb,
    etc2rgb8a1_unorm,
    etc2rgb8a1_unorm_srgb,
    etc2rgba8_unorm,
    etc2rgba8_unorm_srgb,
    eacr11_unorm,
    eacr11_snorm,
    eacrg11_unorm,
    eacrg11_snorm,
    astc4x4_unorm,
    astc4x4_unorm_srgb,
    astc5x4_unorm,
    astc5x4_unorm_srgb,
    astc5x5_unorm,
    astc5x5_unorm_srgb,
    astc6x5_unorm,
    astc6x5_unorm_srgb,
    astc6x6_unorm,
    astc6x6_unorm_srgb,
    astc8x5_unorm,
    astc8x5_unorm_srgb,
    astc8x6_unorm,
    astc8x6_unorm_srgb,
    astc8x8_unorm,
    astc8x8_unorm_srgb,
    astc10x5_unorm,
    astc10x5_unorm_srgb,
    astc10x6_unorm,
    astc10x6_unorm_srgb,
    astc10x8_unorm,
    astc10x8_unorm_srgb,
    astc10x10_unorm,
    astc10x10_unorm_srgb,
    astc12x10_unorm,
    astc12x10_unorm_srgb,
    astc12x12_unorm,
    astc12x12_unorm_srgb,
};

pub const TextureSampleType = enum {
    float,
    unfilterable_float,
    depth,
    sint,
    uint,
};

pub const TextureViewDimension = enum {
    d1,
    d2,
    d2_array,
    cube,
    cube_array,
    d3,
};

pub const VertexFormat = enum {
    uint8x2,
    uint8x4,
    sint8x2,
    sint8x4,
    unorm8x2,
    unorm8x4,
    snorm8x2,
    snorm8x4,
    uint16x2,
    uint16x4,
    sint16x2,
    sint16x4,
    unorm16x2,
    unorm16x4,
    snorm16x2,
    snorm16x4,
    float16x2,
    float16x4,
    float32,
    float32x2,
    float32x3,
    float32x4,
    uint32,
    uint32x2,
    uint32x3,
    uint32x4,
    sint32,
    sint32x2,
    sint32x3,
    sint32x4,
};

pub const VertexStepMode = enum {
    vertex,
    instance,
};
