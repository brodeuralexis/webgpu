const std = @import("std");

pub usingnamespace @import("./enums.zig");
pub usingnamespace @import("./bitmasks.zig");
pub usingnamespace @import("./structs.zig");

pub const backends = struct {
    pub const dummy = struct {
        pub const create = @import("./backends/dummy/dummy.zig").create;
    };

    pub const vulkan = struct {
        pub const create = @import("./backends/vulkan/vulkan.zig").create;
    };
};

pub usingnamespace @import("./binding_model.zig");
pub usingnamespace @import("./command.zig");
pub usingnamespace @import("./device.zig");
pub usingnamespace @import("./instance.zig");
pub usingnamespace @import("./pipeline.zig");
pub usingnamespace @import("./resource.zig");
