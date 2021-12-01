const std = @import("std");
const aoc = @import("common.zig");
const os = std.os;

const days = @import("days.zig");

pub fn main() !void {
    const warmup_count = 100;
    const benchmark_count = 50000;

    var total_ns: u64 = 0;

    inline for (days.strs) |str, i| {
        const input_filename = days.inputs[i];
        const func = days.funcs[i];

        const file = try std.fs.cwd().openFile(
            input_filename,
            .{ .read = true },
        );
        defer file.close();

        var list = aoc.newVec(u8);
        defer list.deinit();

        try file.reader().readAllArrayList(&list, 1024 * 1024);
        const input = list.items;

        // const file = @embedFile(input_filename);
        // const input = mem.sliceAsBytes(file);

        var result: aoc.Output = undefined;
        var bench_i: usize = 0;
        var bench_tot_time: usize = 0;
        while (bench_i < benchmark_count + warmup_count) : (bench_i += 1) {
            var timer = try aoc.Timer.start();
            result = @call(.{.modifier = .never_inline}, func, .{input}) catch unreachable;
            if (bench_i > warmup_count) bench_tot_time += timer.lap();
        }
        const time = bench_tot_time / benchmark_count;
        total_ns += time;
        aoc.print("--- Day {s:2} 2021 in {:5} μs Part 1: {:15} Part 2: {:15}\n", .{str, time / std.time.ns_per_us, @intCast(u64, result.part1), @intCast(u64, result.part2)});
    }
    aoc.print("--- Total time: {} μs\n", .{total_ns / std.time.ns_per_us});
}
