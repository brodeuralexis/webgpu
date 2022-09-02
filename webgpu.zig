const std = @import("std");
const builtin = @import("builtin");

pub usingnamespace @import("webgpu-core");

pub const backends = switch (builtin.target.os.tag) {
    .linux => struct {
        pub const dummy = @import("webgpu-backend-dummy");
    },
    .windows => struct {
        pub const dummy = @import("webgpu-backend-dummy");
    },
    else => |os_tag| @compileError(
        std.fmt.comptimePrint(
            "{s} is not yet a supported platform",
            .{ @tagName(os_tag) }
        )
    ),
};
