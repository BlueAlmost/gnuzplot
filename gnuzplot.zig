const std = @import("std");
const print = std.debug.print;

const Allocator = std.mem.Allocator;
const stdout = std.io.getStdOut().writer();

const child = std.child_process;
const fields = std.meta.fields;
const colors = @import("matplotlib_colors.zig");

pub fn Gnuzplot() type {
    return struct {
        const Self = @This();

        g: std.ChildProcess,
        writer: std.fs.File.Writer,

        pub fn init(allocator: Allocator) !Self {
            const child_name = "gnuplot";
            var g = std.ChildProcess.init(&[_][]const u8{child_name}, allocator);

            g.stdin_behavior = .Pipe;
            g.spawn() catch |err| {
                std.log.err("Could not spawn child process: {s}\n", .{child_name});
                return err;
            };

            // // ideally would like to verify if pid is up and running, but unclear how just now

            var writer = g.stdin.?.writer();

            try writer.print("set term qt size 1200, 900 position 20, 30\n", .{});
            try writer.print("set title font ',16'\n", .{});
            try writer.print("set grid\n", .{});
            try writer.print("{s}\n", .{colors.matplotlib_colors});

            return Self{
                .g = g,
                .writer = writer,
            };
        }

        // manually execute any gnuplot command does not have an existing wrapper
        pub fn cmd(self: Self, c: [*:0]const u8) !void {
            try self.writer.print("{s}\n", .{c});
        }

        // clear the plot figure
        pub fn clear(self: Self) !void {
            try self.writer.print("clear\n", .{});
        }

        // close gnuplot child process
        pub fn exit(self: Self) !void {
            try self.writer.print("exit\n", .{});
        }

        // place figure window on screen
        pub fn figPos(self: Self, x: i64, y: i64) !void {
            try self.writer.print("set term qt position {d} , {d} \n", .{ x, y });
        }

        // size figure window
        pub fn figSize(self: Self, wid: i64, ht: i64) !void {
            try self.writer.print("set term qt size {d} , {d} \n", .{ wid, ht });
        }

        // remove grid from the plot
        pub fn gridOff(self: Self) !void {
            try self.writer.print("unset grid\n", .{});
        }

        // place a grid on the plot
        pub fn gridOn(self: Self) !void {
            try self.writer.print("set grid\n", .{});
        }

        // pause both parent zig process and child gnuplot process (maintain sync)
        // prints a message to stdout terminal
        pub fn pause(self: Self, secs: f64) !void {
            try stdout.print("pausing {d} s\n", .{secs}); //
            try self.writer.print("pause {d}\n", .{secs}); //gnu
            const nanosecs: u64 = @floatToInt(u64, secs * 1.0e9);
            std.time.sleep(nanosecs); // std.time.sleep expects nanoseconds
        }

        // pause both parent zig process and child gnuplot process (maintain sync)
        // without terminal message
        pub fn pauseQuiet(self: Self, secs: f64) !void {
            try self.writer.print("pause {d}\n", .{secs}); //gnu
            const nanosecs: u64 = @floatToInt(u64, secs * 1.0e9);
            std.time.sleep(nanosecs); // std.time.sleep expects nanoseconds
        }

        // plot a single vector (values over each index) use:
        //
        // plt.plot( .{x, "title 'x' with lines ls 5 lw 1"});
        //
        // to plot multiple vector in same plot (values over each index) use:
        //
        //  plt.plot( .{
        //          x, "title 'x' with lines ls 2 lw 1",
        //          y, "title 'x' with lines ls 2 lw 1",
        //          z, "title 'x' with lines ls 2 lw 1",
        //          });

        pub fn plot(self: Self, argstruct: anytype) !void {
            const argvec = fields(@TypeOf(argstruct));
            comptime var i = 0;
            var vlen: usize = 0;

            const preamble = "plot ";
            const plotline_pre = " '-' u 1:2 ";
            const plotline_post = ", ";

            try self.writer.print("{s}", .{preamble});

            // write command string
            inline while (i < argvec.len) : (i += 2) {
                try self.writer.print("{s}", .{plotline_pre});
                try self.writer.print("{s}", .{@field(argstruct, argvec[i + 1].name)});
                try self.writer.print("{s}", .{plotline_post});
            }
            try self.writer.print("\n", .{});

            i = 0;
            inline while (i < argvec.len) : (i += 2) {
                vlen = @field(argstruct, argvec[i].name).len;
                var j: usize = 0;
                while (j < vlen) : (j += 1) {
                    try self.writer.print("{d}  {e:10.4}\n", .{ j, @field(argstruct, argvec[i].name)[j] });
                }
                try self.writer.print("e\n", .{});
            }
        }

        // plot the graph of vector x vs. vector y using:
        //
        // plt.plotXY( .{x, y, "title 'y vs. x' with lines lw 3"});
        //
        pub fn plotXY(self: Self, argstruct: anytype) !void {
            const argvec = fields(@TypeOf(argstruct));
            comptime var i = 0;
            var vlen: usize = 0;
            const preamble = "plot ";
            const plotline_pre = " '-' u 1:2 ";
            const plotline_post = ", ";

            try self.writer.print("{s}", .{preamble});

            // write command string
            inline while (i < argvec.len) : (i += 3) {
                try self.writer.print("{s}", .{plotline_pre});
                try self.writer.print("{s}", .{@field(argstruct, argvec[i + 2].name)});
                try self.writer.print("{s}", .{plotline_post});
            }
            try self.writer.print("\n", .{});

            i = 0;
            inline while (i < argvec.len) : (i += 3) {
                vlen = @field(argstruct, argvec[i].name).len;
                var j: usize = 0;
                while (j < vlen) : (j += 1) {
                    try self.writer.print("{e:10.4}   {e:10.4}\n", .{ @field(argstruct, argvec[i].name)[j], @field(argstruct, argvec[i + 1].name)[j] });
                }
                try self.writer.print("e\n", .{});
            }
        }

        // set the figure title
        pub fn title(self: Self, title_str: [*:0]const u8) !void {
            try self.writer.print("set title '{s}'\n", .{title_str});
        }

        // put label on x-axis
        pub fn xLabel(self: Self, c: [*:0]const u8) !void {
            try self.writer.print("set xlabel '{s}'\n", .{c});
        }

        // put label on y-axis
        pub fn yLabel(self: Self, c: [*:0]const u8) !void {
            try self.writer.print("set ylabel '{s}'\n", .{c});
        }

        // bar graph of a single vector, specifying the width
        //
        // plt.bar( .{x, width, "title 'x'"});
        //
        // a width must be specified
        //
        pub fn bar(self: Self, argstruct: anytype) !void {
            const num_args_per = 3;
            const argvec = fields(@TypeOf(argstruct));
            var num_vars: usize = argvec.len / num_args_per;
            var vlen: usize = 0;
            var width: f64 = @floatCast(f64, @field(argstruct, argvec[1].name));
            width = @intToFloat(f64, num_args_per) * width / @intToFloat(f64, argvec.len);

            vlen = @field(argstruct, argvec[0].name).len;

            try self.writer.print("set xrange [-1:{d}]\n", .{vlen + 1});

            const preamble = "set style fill solid 0.5 \n plot ";
            const plotline_pre = " '-' u 1:2:3 with boxes ";
            const plotline_post = ", ";
            try self.writer.print("{s}", .{preamble});

            // write command string
            comptime var i = 0;
            inline while (i < argvec.len) : (i += 3) {
                try self.writer.print("{s}", .{plotline_pre});
                try self.writer.print("{s}", .{@field(argstruct, argvec[i + 2].name)});
                try self.writer.print("{s}", .{plotline_post});
            }
            try self.writer.print("\n", .{});

            i = 0;
            inline while (i < argvec.len) : (i += 3) {
                vlen = @field(argstruct, argvec[i].name).len;
                var j: usize = 0;

                while (j < vlen) : (j += 1) {
                    try self.writer.print("{d}   {e:10.4} {e:10.4}\n", .{
                        @intToFloat(f64, j) + @intToFloat(f64, i) * width / @intToFloat(f64, num_vars),
                        @field(argstruct, argvec[i].name)[j],
                        // @field(argstruct, argvec[i+1].name)
                        width,
                    });
                }
                try self.writer.print("e\n", .{});
            }
        }
    };
}
