const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // example executable --------------------------------------------

    const exe_example = b.addExecutable(.{
        .name = "examples",
        .root_source_file = b.path("./example/examples.zig"),
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(exe_example);

    b.getInstallStep().dependOn(&b.addInstallArtifact(exe_example, .{
            .dest_dir = .{ .override = .{ .custom = "../example"}}}).step);

    exe_example.root_module.addAnonymousImport("gnuzplot", .{
        // .source_file = b.path("./gnuzplot.zig"),
        .root_source_file = b.path("./gnuzplot.zig"),
    });

    // unit tests ----------------------------------------------------
    const unit_tests = b.addTest(.{
        .root_source_file = b.path("./main_test.zig"),
        .target = target,
        .optimize = optimize,
    });

    unit_tests.root_module.addAnonymousImport("gnuzplot", .{
        .root_source_file = b.path("./gnuzplot.zig" ),
    });

    const unit_tests_step = b.step("test", "Run unit tests");
    unit_tests_step.dependOn(&unit_tests.step);
}
