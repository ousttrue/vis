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
            "main.c",
        },
        .flags = &.{
            "-std=c99",
            "-U_XOPEN_SOURCE",
            "-D_XOPEN_SOURCE=700",
            "-DNDEBUG",
            "-DVERSION=\"v0.9-git\"",
            "-DCONFIG_HELP=1",
            "-DCONFIG_CURSES=1",
            "-DCONFIG_LUA=0",
            "-DCONFIG_LPEG=0",
            "-DCONFIG_TRE=0",
            "-DCONFIG_ACL=0",
            "-DCONFIG_SELINUX=0",
        },
    });
    exe.linkLibC();
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
