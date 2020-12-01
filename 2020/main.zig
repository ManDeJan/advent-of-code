usingnamespace @import("common.zig");
const os = std.os;

const days = @import("days.zig");

pub fn main() anyerror!void {

    var total_us: u64 = 0;

    for (days.funcs) |f, i| {
        const input_filename = days.inputs[i];
        const open_result  = os.open(input_filename, os.O_RDONLY, 0) catch unreachable;
        const fstat_result = os.fstat(open_result) catch unreachable;
        const input        = os.mmap(null, @intCast(u64, fstat_result.size),
                                    os.PROT_READ, os.MAP_PRIVATE, open_result, 0) catch unreachable;
                                    
        var timer = try Timer.start();
        const result = try f(input);
        const time = timer.lap();
        try print("--- Day {:2} 2020 in {:10}μs Part 1: {}\tPart 2: {}\n", .{days.strs[i], time, result.part1, result.part2});
    }
}
