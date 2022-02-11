const std = @import("std");
const builtin = @import("builtin");

const root = @import("root");

pub const LIBVULKAN_NAME = if (@hasDecl(root, "webgpu_libvulkan_name"))
    @field(root, "webgpu_libvulkan_name")
else switch (builtin.os.tag) {
    .windows => "vulkan-1.dll",
    .macos => "libvulkan.1.dylib",
    .freebsd, .openbsd => "libvulkan.so",
    else => "libvulkan.so.1",
};

pub const ENABLE_VALIDATION_LAYER = if (@hasDecl(root, "webgpu_vulkan_validation_layer"))
    @field(root, "webgpu_vulkan_validation_layer")
else switch (builtin.mode) {
    .ReleaseSafe, .Debug => true,
    else => false,
};

pub const VALIDATION_LAYERS = if (ENABLE_VALIDATION_LAYER)
    [_][*:0]const u8{"VK_LAYER_KHRONOS_validation"}
else
    [_][*:0]const u8{};

const SWAP_CHAIN_EXTENSION: [*:0]const u8 = "VK_KHR_swapchain";

const SURFACE_EXTENSION: [*:0]const u8 = "VK_KHR_surface";

pub const SURFACE_PLATFORM_EXTENSIONS = switch (builtin.os.tag) {
    .windows => [_][*:0]const u8{ "VK_KHR_win32_surface" },
    .linux => [_][*:0]const u8{ "VK_KHR_wayland_surface", "VK_KHR_xlib_surface" },
    .macos => [_][*:0]const u8{ "VK_EXT_metal_surface" },
    else => |os_tag| @compileError(
        std.fmt.comptimePrint("{s] does not have a known platform surface extension", .{ @tagName(os_tag) })
    ),
};

pub const INSTANCE_LAYERS = VALIDATION_LAYERS;

pub const INSTANCE_EXTENSIONS =  [_][*:0]const u8{ SURFACE_EXTENSION }
    ++ SURFACE_PLATFORM_EXTENSIONS;

pub const DEVICE_LAYERS = VALIDATION_LAYERS;

pub const DEVICE_EXTENSIONS = [_][*:0]const u8{ SWAP_CHAIN_EXTENSION };
