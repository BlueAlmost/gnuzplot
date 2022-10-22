const gnuzplot = @import("gnuzplot");
const std = @import("std");
const print = std.debug.print;
const Gnuzplot = gnuzplot.Gnuzplot;

test "\t methods, \t .init \n" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    print("Apparently, at present, there is no way to failure to spawn\n", .{});
    var plt = try Gnuzplot().init(allocator);
    _ = plt;
}

test "\t methods, \t .cmd (print help help message and exists\n" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    var plt = try Gnuzplot().init(allocator);
    try plt.cmd("help help");
    try plt.exit();
}


test "\t methods, \t .exit \n" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    var plt = try Gnuzplot().init(allocator);
    try plt.exit();
}


test "\t methods, \t .figpos \n" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    var plt = try Gnuzplot().init(allocator);
    try plt.figpos(40, 40);
    try plt.exit();
}

test "\t methods, \t .figsize \n" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    var plt = try Gnuzplot().init(allocator);
    try plt.figsize(40, 40);
    try plt.exit();
}

test "\t methods, \t .grid_off \n" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    var plt = try Gnuzplot().init(allocator);
    try plt.grid_off();
    try plt.exit();
}

test "\t methods, \t .grid_on \n" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    var plt = try Gnuzplot().init(allocator);
    try plt.grid_on();
    try plt.exit();
}


test "\t methods, \t .pause \n" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    var plt = try Gnuzplot().init(allocator);
    try plt.pause(0.5);
    try plt.exit();
}

test "\t methods, \t .pause_quiet \n" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    var plt = try Gnuzplot().init(allocator);
    try plt.pause_quiet(0.5);
    try plt.exit();
}


test "\t methods, \t .plot (single vector) \n" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();

    const x = [_]f32{1.1, -0.3, 2.2, -0.1};

    const allocator = arena.allocator();
    var plt = try Gnuzplot().init(allocator);
    try plt.pause_quiet(0.2);

    try plt.plot( .{x, "title 'x' with lines ls 4 lw 3"});
    try plt.pause_quiet(1.0);
    try plt.exit();
}

test "\t methods, \t .plot (multiple vectors) \n" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();

    const x = [_]f32{ 1.1, -0.3,  2.2, -0.1};
    const y = [_]f32{-1.3,  0.2,  1.2,  0.1};
    const z = [_]f32{ 1.7, -0.9, -2.2, -0.3};

    const allocator = arena.allocator();
    var plt = try Gnuzplot().init(allocator);
    try plt.pause_quiet(0.2);

    try plt.plot( .{
        x, "title 'x' with lines ls 1 lw 1",
        y, "title 'y' with lines ls 2 lw 2",
        z, "title 'z' with lines ls 3 lw 3",
    });
    try plt.pause_quiet(1.0);
    try plt.exit();
}



test "\t methods, \t .plotxy (y vs. x) \n" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();

    const x = [_]f32{1.1, -0.3, 2.2, 0.1};
    const y = [_]f32{-1.3, 0.2, 1.2, 0.1};

    const allocator = arena.allocator();
    var plt = try Gnuzplot().init(allocator);
    try plt.pause_quiet(0.2);

    try plt.plotxy( .{ x, y, "title 'y vs. x' with lines lw 5", });
    try plt.pause_quiet(1.0);
    try plt.exit();
}


test "\t methods, \t .title, .xlabel, .ylabel (with a sample plot) \n" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();

    const x = [_]f32{1.1, -0.3, 2.2, -0.1};

    const allocator = arena.allocator();
    var plt = try Gnuzplot().init(allocator);
    try plt.pause_quiet(0.2);

    try plt.title("This is the title");
    try plt.xlabel("This is the xlabel");
    try plt.ylabel("This is the ylabel");
    try plt.plot( .{x, "title 'x' with lines ls 4 lw 3"});
    try plt.pause_quiet(2.0);
    try plt.exit();
}

test "\t methods, \t .bar (of single vector) \n" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();

    const x = [_]f32{1.1, -0.3, 2.2, -0.1};
    const width = 0.8;

    const allocator = arena.allocator();
    var plt = try Gnuzplot().init(allocator);
    try plt.pause_quiet(0.2);

    try plt.bar( .{x, width, "title 'x'"});
    try plt.pause_quiet(1.0);
    try plt.exit();
}

test "\t methods, \t .bar (shared bar plot - multiple vectors) \n" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();

    const x = [_]f32{ 1.1, -0.3,  2.2, -0.1};
    const y = [_]f32{-1.3,  0.2,  1.2,  0.1};
    const z = [_]f32{ 1.7, -0.9, -2.2, -0.3};
    const width = 0.5;

    const allocator = arena.allocator();
    var plt = try Gnuzplot().init(allocator);
    try plt.pause_quiet(0.2);

    try plt.bar( .{
        x, width, "title 'x' ls 33 ",
        y, width, "title 'y' ls 44 ",
        z, width, "title 'z' ls 55 ",
    });

    try plt.pause_quiet(2.0);
    try plt.exit();
}


//const std = @import("std");
//// const gnuzplot = @import("gnuzplot");
//const fs = std.fs;
//const stdout = std.io.getStdOut().writer();
//const process = std.process;
//const child = std.child_process;
//const Allocator = std.mem.Allocator;

//const PlotData = struct {
//    bx: []f64,
//    by: []f64,
//    c: []f64,
//    n: []f64,
//    s: []f64,
//    spx1: []f64,
//    spy1: []f64,
//    spx2: []f64,
//    spy2: []f64,
//    x: []f64,
//    y: []f64,
//    z: []f64,
//};


//pub fn readJSON(comptime T: type, allocator: Allocator, filename: []const u8, filled_struct: *T) !void {

//    // open file
//    const file = std.fs.cwd().openFile( filename, .{ .mode = .read_only },) catch |err| {
//        std.log.err("Could not open file \"{s}\"\n", .{filename});
//        return(err);
//    };
//    defer file.close();

//    // read file into char array (maximum tolerable file size is set to 100 MB)
//    var input_chars: []const u8 = undefined;
    
//    input_chars = file.readToEndAlloc(allocator, 100 * 1024 * 1024) catch |err| {
//        std.log.err("Could not read file \"{s}: \n", .{filename});
//        return(err);
//    };
//    defer allocator.free(input_chars);

//    // // parse json input characters, filling struct
//    const opts = std.json.ParseOptions{ .allocator = allocator, .ignore_unknown_fields = true };
//    filled_struct.* = tmp: {
//         @setEvalBranchQuota(11_000);
//         var stream = std.json.TokenStream.init(input_chars);
//         break :tmp try std.json.parse(T, &stream, opts);
//    };
//}



//// pub fn main() anyerror!void {
//test "\n testing testing testing gnuplot \n" {

//    const print = std.debug.print;

//    print("I AM HERE!\n", .{});
    
//    const filename = "data/example.json";

//    // Allocator
//    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
//    defer arena.deinit();
//    const allocator = arena.allocator();

//    var plot_data: PlotData = undefined;
//    try readJSON(PlotData, allocator, filename, &plot_data);

//    // Gnuzplot


//    //var plt = gnuzplot.G{.alloc = allocator};



//    var plt = G{.alloc = allocator};
//    try plt.init();


//    // single plot
//    try plt.grid_on();
//    try plt.title("A simple signal from JSON data file");
//    try plt.plot( .{plot_data.s, "title 'sin pulse' with lines ls 5 lw 1"} );
//    try plt.pause(3);

//    // single plot with marker
//    try plt.grid_on();
//    try plt.title("now with line and point");
//    try plt.plot( .{plot_data.c, "title 'sin pulse' with linespoints ls 3 lw 2 pt 7 ps 2"} );
//    try plt.pause(3);

//    // double plot
//    try plt.grid_off();
//    try plt.title("Two other signals with transparency");
//    try plt.plot(.{
//        plot_data.s,"title 'sin' with lines ls 14 lw 2",
//        plot_data.n,"title 'sin in noise' with lines ls 25 lw 2"
//    });
//    try plt.pause(3);

//    // // x vs. y line plot
//    try plt.title("x vs y line plot");
//    try plt.plotxy(.{
//        plot_data.spx1,plot_data.spy1,"title 'x' with linespoints lw 1 pt 9 ps 2.3",
//        plot_data.spx2,plot_data.spy2,"title 'x' with linespoints lw 2 pt 7 ps 2.3",
//    });
//    try plt.pause(3);

//    // x vs. y scatter plot
//    try plt.title("x vs y scatter plot with transparency");
//    try plt.plotxy(.{plot_data.bx,plot_data.by,"title 'x' with points ls 28 pt 7 ps 5"});
//    try plt.pause(3);

//    // simple bar plot
//    try plt.grid_on();
//    try plt.title("bar plot");
//    try plt.bar( .{plot_data.x, 0.75, "title 'x' ls 7 "} );
//    try plt.pause(3);
//    try plt.grid_on();
   
//    // shared bar plot 
//    try plt.title("shared bar plot with three vectors");
//    try plt.bar( .{
//        plot_data.x, 0.5, "title 'x' ls 33 ",
//        plot_data.y, 0.5, "title 'y' ls 44 ",
//        plot_data.z, 0.5, "title 'z' ls 55 "
//    } );
//    try plt.pause(5);

//    try plt.exit();
//}

