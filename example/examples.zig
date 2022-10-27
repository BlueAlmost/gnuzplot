const std = @import("std");
const gnuzplot = @import("gnuzplot");
const Gnuzplot = gnuzplot.Gnuzplot;

const fs = std.fs;
const stdout = std.io.getStdOut().writer();
const process = std.process;
const child = std.child_process;
const Allocator = std.mem.Allocator;

const PlotData = struct {
    bx: []f64,
    by: []f64,
    c: []f64,
    n: []f64,
    s: []f64,
    spx1: []f64,
    spy1: []f64,
    spx2: []f64,
    spy2: []f64,
    x: []f64,
    y: []f64,
    z: []f64,
};

pub fn readJSON(comptime T: type, allocator: Allocator, filename: []const u8, filled_struct: *T) !void {

    // open file
    const file = std.fs.cwd().openFile( filename, .{ .mode = .read_only },) catch |err| {
        std.log.err("Could not open file \"{s}\"\n", .{filename});
        return(err);
    };
    defer file.close();

    // read file into char array (maximum tolerable file size is set to 100 MB)
    var input_chars: []const u8 = undefined;
    
    input_chars = file.readToEndAlloc(allocator, 100 * 1024 * 1024) catch |err| {
        std.log.err("Could not read file \"{s}: \n", .{filename});
        return(err);
    };
    defer allocator.free(input_chars);

    // parse json input characters, filling struct
    const opts = std.json.ParseOptions{ .allocator = allocator, .ignore_unknown_fields = true };
    filled_struct.* = tmp: {
         @setEvalBranchQuota(11_000);
         var stream = std.json.TokenStream.init(input_chars);
         break :tmp try std.json.parse(T, &stream, opts);
    };
}



pub fn main() anyerror!void {
    
    const filename = "data/example.json";

    // Allocator
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var plot_data: PlotData = undefined;
    try readJSON(PlotData, allocator, filename, &plot_data);

    // Gnuzplot
    var plt = try Gnuzplot().init(allocator);

    // single plot
    try plt.gridOn();
    try plt.title("A simple signal from JSON data file");
    try plt.plot( .{plot_data.s, "title 'sin pulse' with lines ls 5 lw 1"} );
    try plt.pause(3);

    // single plot with marker
    try plt.gridOn();
    try plt.title("now with line and point");
    try plt.plot( .{plot_data.c, "title 'sin pulse' with linespoints ls 3 lw 2 pt 7 ps 2"} );
    try plt.pause(3);

    // double plot
    try plt.gridOff();
    try plt.title("Two other signals with transparency");
    try plt.plot(.{
        plot_data.s,"title 'sin' with lines ls 14 lw 2",
        plot_data.n,"title 'sin in noise' with lines ls 25 lw 2"
    });
    try plt.pause(3);

    // // x vs. y line plot
    try plt.title("x vs y line plot");
    try plt.plotXY(.{
        plot_data.spx1,plot_data.spy1,"title 'x' with linespoints lw 1 pt 9 ps 2.3",
        plot_data.spx2,plot_data.spy2,"title 'x' with linespoints lw 2 pt 7 ps 2.3",
    });
    try plt.pause(3);

    // x vs. y scatter plot
    try plt.title("x vs y scatter plot with transparency");
    try plt.plotXY(.{plot_data.bx,plot_data.by,"title 'x' with points ls 28 pt 7 ps 5"});
    try plt.pause(3);

    // simple bar plot
    try plt.gridOn();
    try plt.title("bar plot");
    try plt.bar( .{plot_data.x, 0.75, "title 'x' ls 7 "} );
    try plt.pause(3);
    try plt.gridOn();
   
    // shared bar plot 
    try plt.title("shared bar plot with three vectors");
    try plt.bar( .{
        plot_data.x, 0.5, "title 'x' ls 33 ",
        plot_data.y, 0.5, "title 'y' ls 44 ",
        plot_data.z, 0.5, "title 'z' ls 55 "
    } );
    try plt.pause(5);

    try plt.exit();
}
