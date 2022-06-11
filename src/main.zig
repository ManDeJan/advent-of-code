const std = @import("std");
const aoc = @import("common.zig");
const os = std.os;

const solutions = @import("solutions.zig").solutions;

pub fn main() !void {
    // const warmup_count = 100;
    // const benchmark_count = 10000;
    const warmup_count = 0;
    const benchmark_count = 1;
    // const warmup_count = 10;
    // const benchmark_count = 100;

    var total_ns: u64 = 0;

    for (solutions) |solution_year, i| {
        var year_ns: u64 = 0;
        if (i != 0) aoc.print("\n", .{});
        aoc.print("\x1B[1;4mYear {s}\x1B[0m\n", .{solution_year.year});
        for (solution_year.days) |day, day_idx| {
            const input_filename = aoc.printToString("inputs/{s}/{s}.txt", .{ solution_year.year, day });
            const func = solution_year.funcs[day_idx];

            const input = try std.fs.cwd().readFileAlloc(aoc.allocator, input_filename, 1024 * 1024);

            var result: aoc.Output = undefined;
            var bench_i: usize = 0;
            var bench_tot_time: usize = 0;
            while (bench_i < benchmark_count + warmup_count) : (bench_i += 1) {
                var timer = try aoc.Timer.start();
                result = func(input) catch unreachable;
                // result = try func(input);
                // below does not work because https://github.com/ziglang/zig/issues/5170
                // result = callWrapper(.{.modifier = .always_inline}, func, .{input}) catch unreachable;
                if (bench_i >= warmup_count) bench_tot_time += timer.lap();
            }
            const time = bench_tot_time / benchmark_count;
            year_ns += time;
            aoc.print("Day {s:2} in {:7} μs Part 1: {:15} Part 2: {:15}\n", .{ day, time / std.time.ns_per_us, @intCast(u64, result.part1), @intCast(u64, result.part2) });
        }
        total_ns += year_ns;
        aoc.print("Year time:\x1B[1m {:6} μs\x1B[0m\n", .{year_ns / std.time.ns_per_us});
    }
    aoc.print("-------------------\n", .{});
    aoc.print("Total time:\x1B[1m {:5} μs\x1B[0m\n", .{total_ns / std.time.ns_per_us});
}
