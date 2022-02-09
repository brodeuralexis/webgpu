const std = @import("std");

const Builder = std.build.Builder;
const CrossTarget = std.zig.CrossTarget;
const Mode = std.builtin.Mode;

var target: CrossTarget = undefined;
var mode: Mode = undefined;

pub fn build(b: *Builder) void {
    target = b.standardTargetOptions(.{});
    mode = b.standardReleaseOptions();

    buildExamples(b);
}

const examples = [_][]const u8{
    "hello",
};

fn buildExamples(b: *Builder) void {
    inline for (examples) |name| {
        var path = b.fmt("examples/{s}.zig", .{ name });

        const example = b.addExecutable(name, path);
        example.setTarget(target);
        example.setBuildMode(mode);
        example.install();

        example.linkLibC();

        example.addPackagePath("webgpu", "src/webgpu.zig");
    }
}
