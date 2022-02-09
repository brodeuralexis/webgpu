const std = @import("std");
const builtin = @import("builtin");

const Allocator = std.mem.Allocator;

pub fn load(allocator: Allocator, path: [:0]const u8) ?*anyopaque {
    switch (builtin.os.tag) {
        .windows => {
            const LoadLibraryW = std.os.windows.LoadLibraryW;

            const path_w = std.unicode.utf8ToUtf16LeWithNull(allocator, path) catch return null;
            defer allocator.free(path_w);

            return @ptrCast(*anyopaque, LoadLibraryW(path_w.ptr) catch return null);
        },
        else => {
            return std.c.dlopen(path, 0x2);
        },
    }
}

pub fn free(module: *anyopaque) void {
    switch (builtin.os.tag) {
        .windows => {
            const HMODULE = std.os.windows.HMODULE;

            const FreeLibrary = std.os.windows.FreeLibrary;

            FreeLibrary(@ptrCast(HMODULE, module));
        },
        else => {
            _ = std.c.dlclose(module);
        },
    }
}

pub fn getProcAddress(module: *anyopaque, symbol: [:0]const u8) ?*anyopaque {
    switch (builtin.os.tag) {
        .windows => {
            const HMODULE = std.os.windows.HMODULE;

            const GetProcAddress = std.os.windows.kernel32.GetProcAddress;
            const GetLastError = std.os.windows.kernel32.GetLastError;

            return GetProcAddress(@ptrCast(HMODULE, module), symbol.ptr) orelse {
                return switch (GetLastError()) {
                    .PROC_NOT_FOUND => null,
                    else => unreachable,
                };
            };
        },
        else => {
            return std.c.dlsym(module, symbol.ptr);
        },
    }
}
