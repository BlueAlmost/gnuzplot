const std = @import("std");

pub fn build(b: *std.build.Builder) void {

    const target = b.standardTargetOptions(.{});

    // available options: Debug, ReleaseSafe, ReleaseFast, ReleaseSmall

    const optimize = b.standardOptimizeOption(.{});
    // const optimize = std.builtin.Mode.Debug;
    // const optimize = std.builtin.Mode.ReleaseSafe;
    // const optimize = std.builtin.Mode.ReleaseFast;
    // const optimize = std.builtin.Mode.ReleaseSmall;

    // example executable --------------------------------------------

    const exe_example = b.addExecutable(.{
        .name = "examples",
        .root_source_file = .{.path = "./example/examples.zig"},
        .target = target,
        .optimize = optimize,
    });

    exe_example.addAnonymousModule("gnuzplot", .{
        .source_file = .{.path = "./gnuzplot.zig"},
    });

    b.exe_dir = b.pathFromRoot("./example");
    exe_example.install();

    // unit tests ----------------------------------------------------
    const unit_tests = b.addTest(.{
        .root_source_file = .{.path = "./main_test.zig"},
        .target = target,
        .optimize = optimize,
    });

    unit_tests.addAnonymousModule("gnuzplot", .{
        .source_file = .{.path = "./gnuzplot.zig"},
    });

    const unit_tests_step = b.step("test", "Run unit tests");
    unit_tests_step.dependOn(&unit_tests.step);

}
