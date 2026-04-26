const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const render_core_dep = b.dependency("howl_render_core", .{
        .target = target,
        .optimize = optimize,
    });
    const render_core_mod = render_core_dep.module("howl_render_core");

    const mod = b.addModule("howl_render_vulkan", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });
    mod.addImport("howl_render_core", render_core_mod);

    const mod_tests = b.addTest(.{ .root_module = mod });
    const run_mod_tests = b.addRunArtifact(mod_tests);

    const test_step = b.step("test", "Run module tests");
    test_step.dependOn(&run_mod_tests.step);
}
