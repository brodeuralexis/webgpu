const std = @import("std");
const deps = @import("deps.zig");

const Builder = std.build.Builder;
const CrossTarget = std.zig.CrossTarget;
const LibExeObjStep = std.build.LibExeObjStep;
const Mode = std.builtin.Mode;

var target: CrossTarget = undefined;
var mode: Mode = undefined;

const examples = &[_][]const u8{
    "simple"
};

pub fn build(b: *Builder) void {
    target = b.standardTargetOptions(.{});
    mode = b.standardReleaseOptions();

    inline for (examples) |example| {
        const example_path = b.fmt("examples/{s}/main.zig", .{ example });

        const exe = b.addExecutable(example, example_path);
        exe.setTarget(target);
        exe.setBuildMode(mode);
        exe.linkLibC();
        exe.addPackage(deps.exports.webgpu);

        const run_cmd = exe.run();
        run_cmd.expected_exit_code = null;
        if (b.args) |args| run_cmd.addArgs(args);

        const run_step_name = b.fmt("run-{s}", .{ example });
        const run_step_desc = b.fmt("runs the {s} example", .{ example });
        const run_step = b.step(run_step_name, run_step_desc);
        run_step.dependOn(&run_cmd.step);
    }
}
