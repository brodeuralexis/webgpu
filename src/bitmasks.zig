const std = @import("std");

pub const Features = struct {
    depth_clip_control: bool = false,
    depth24unorm_stencil8: bool = false,
    depth32float_stencil8: bool = false,
    timestamp_query: bool = false,
    pipeline_statistics_query: bool = false,
    texture_compression_bc: bool = false,
    texture_compression_etc2: bool = false,
    texture_compression_astc: bool = false,
    indirect_first_instance: bool = false,
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

    pub const all = ColorWriteMask{
        .red = true,
        .green = true,
        .blue = true,
        .alpha = true,
    };
};

pub const MapMode = struct {
    read: bool = false,
    write: bool = false,
};

pub const ShaderStage = struct {
    vertex: bool = false,
    fragment: bool = false,
    compute: bool = false,
};

pub const TextureUsage = struct {
    copy_src: bool = false,
    copy_dst: bool = false,
    texture_binding: bool = false,
    storage_binding: bool = false,
    render_attachment: bool = false,
};
