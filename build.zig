const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .target = target,
        .optimize = optimize,
        .name = "vis",
        // .root_source_file = b.path("src/main.zig"),
    });
    exe.addCSourceFiles(.{
        .files = &.{
            "array.c",
            "buffer.c",
            "event-basic.c",
            "libutf.c",
            "main.c",
            "map.c",
            "sam.c",
            "text-common.c",
            "text-io.c",
            "text-iterator.c",
            "text-motions.c",
            "text-objects.c",
            "text-util.c",
            "text.c",
            "ui-terminal.c",
            "view.c",
            "vis-lua.c",
            "vis-marks.c",
            "vis-modes.c",
            "vis-motions.c",
            "vis-operators.c",
            "vis-prompt.c",
            "vis-registers.c",
            "vis-subprocess.c",
            "vis-text-objects.c",
            "vis.c",
            "text-regex.c",
        },
        .flags = &.{
            "-std=c99",
            "-U_XOPEN_SOURCE",
            "-D_XOPEN_SOURCE=700",
            "-DNDEBUG",
            "-DVERSION=\"v0.9-git\"",
            "-DCONFIG_HELP=1",
            "-DCONFIG_CURSES=0",
            "-DCONFIG_LUA=0",
            "-DCONFIG_LPEG=0",
            "-DCONFIG_TRE=0",
            "-DCONFIG_ACL=0",
            "-DCONFIG_SELINUX=0",
            "-DHAVE_MEMRCHR=1",
        },
    });
    exe.linkLibC();
    exe.linkSystemLibrary("termkey");
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const exe_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_exe_unit_tests.step);
}
