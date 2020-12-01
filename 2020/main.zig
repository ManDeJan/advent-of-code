usingnamespace @import("common.zig");
const os = std.os;

const days = @import("days.zig");

pub fn main() anyerror!void {

    var total_us: u64 = 0;

    for (days.strs) |str, i| {
        const input_filename = days.inputs[i];
        const func = days.funcs[i];

        const file = try std.fs.cwd().openFile(
            input_filename,
            .{ .read = true },
        );
        defer file.close();

        var list = newVec(u8);
        defer list.deinit();

        try file.reader().readAllArrayList(&list, 16 * 1024);
        const input = list.items;

        var timer = try Timer.start();
        const result = func(input) catch unreachable;
        const time = timer.lap();
        print("--- Day {:2} 2020 in {:10} μs Part 1: {}\tPart 2: {}\n", .{str, time / 1000, result.part1, result.part2});
        
        // print("Hello, {}!\n", .{"world"});
    }
}
