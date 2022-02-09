const std = @import("std");
const builtin = @import("builtin");

const root = @import("root");

pub const LIBVULKAN_NAME = if (@hasDecl(root, "webgpu_libvulkan_name"))
    @field(root, "webgpu_libvulkan_name")
else switch (builtin.os.tag) {
    .windows => "vulkan-1.dll",
    .macos => "libvulkan.1.dylib",
    .freebsd, .openbsd => "libvulkan.so",
    else => "libvulkan.1.so",
};
