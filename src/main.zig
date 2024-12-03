const std = @import("std");
const aoc = @import("common.zig");
const os = std.os;

const solutions = @import("solutions.zig").solutions;

pub fn main() !void {
    var warmup_count: u64 = 0;
    var benchmark_count: u64 = 1;
    var arg_year: ?[]u8 = null;
    var arg_day: ?[]u8 = null;

    const arg_list = try std.process.argsAlloc(aoc.allocator);
    defer std.process.argsFree(aoc.allocator, arg_list);

    for (arg_list, 0..) |arg, i| {
        if (std.mem.eql(u8, arg, "-h")) {
            std.debug.print("Usage: -y <year> -d <day> -w <warmup-count> -b <benchmark-count>\n", .{});
        }
        if (i == arg_list.len - 1) {
            break;
        } else if (std.mem.eql(u8, arg, "-y")) {
            arg_year = arg_list[i + 1];
        } else if (std.mem.eql(u8, arg, "-d")) {
            arg_day = arg_list[i + 1];
        } else if (std.mem.eql(u8, arg, "-w")) {
            warmup_count = try std.fmt.parseInt(u64, arg_list[i + 1], 10);
        } else if (std.mem.eql(u8, arg, "-b")) {
            benchmark_count = try std.fmt.parseInt(u64, arg_list[i + 1], 10);
            if (benchmark_count == 0) {
                std.debug.print("Benchmark count can't be zero, defaulting to 1\n", .{});
                benchmark_count = 1;
            }
        }
    }

    var total_ns: u64 = 0;

    for (solutions, 0..) |solution_year, i| {
        if (arg_year) |year| {
            if (!std.mem.eql(u8, year, solution_year.year)) {
                continue;
            }
        }

        if (i != 0) aoc.print("\n", .{});
        aoc.print("┌─────────┐\n", .{});
        aoc.print("│\x1B[1mYear {s}\x1B[0m│\n", .{solution_year.year});
        aoc.print("├───┬─────┴──────────┬────────────────┬──────────────┐\n", .{});
        aoc.print("│\x1B[1mDay\x1B[0m│\x1B[1m{s: ^16}\x1B[0m│\x1B[1m{s: ^16}\x1B[0m│\x1B[1m{s: ^14}\x1B[0m│\n", .{"Part 1", "Part 2", "Time"});

        var year_ns: u64 = 0;
        for (solution_year.days, 0..) |solution_day, day_idx| {
            if (arg_day) |day| {
                if (!std.mem.eql(u8, day, solution_day)) {
                    continue;
                }
            }
            const input_filename = aoc.printToString("inputs/{s}/{s}.txt", .{ solution_year.year, solution_day });
            defer aoc.allocator.free(input_filename);
            const func_type = solution_year.funcs[day_idx];
            const input align(1 << 21) = try std.fs.cwd().readFileAlloc(aoc.allocator, input_filename, 1024 * 1024);
            defer aoc.allocator.free(input);

            var result: aoc.Output = undefined;
            var result_text_1 = std.mem.zeroes([15:0]u8);
            var result_text_2 = std.mem.zeroes([15:0]u8);

            var bench_i: usize = 0;
            var bench_tot_time: usize = 0;
            var timer = try aoc.Timer.start();
            while (bench_i < warmup_count) : (bench_i += 1) {
                switch (func_type) {
                    .outputAsInt => |func| result = func(input) catch unreachable,
                    .outputAsIntText => |func| result.part1 = func(input, &result_text_2) catch unreachable,
                    .outputAsText => |func| func(input, &result_text_1, &result_text_2) catch unreachable,
                }
            }
            bench_i = 0;
            timer.reset();
            while (bench_i < benchmark_count) : (bench_i += 1) {
                switch (func_type) {
                    .outputAsInt => |func| result = func(input) catch unreachable,
                    .outputAsIntText => |func| result.part1 = func(input, &result_text_2) catch unreachable,
                    .outputAsText => |func| func(input, &result_text_1, &result_text_2) catch unreachable,
                }
            }
            bench_tot_time = timer.read();
            // @fence(.Acquire);
            const time = bench_tot_time / benchmark_count;
            year_ns += time;
            switch (func_type) {
                .outputAsInt => {
                    _ = std.fmt.formatIntBuf(&result_text_1, result.part1, 10, .lower, .{});
                    _ = std.fmt.formatIntBuf(&result_text_2, result.part2, 10, .lower, .{});
                },
                .outputAsIntText => {
                    _ = std.fmt.formatIntBuf(&result_text_1, result.part1, 10, .lower, .{});
                },
                else => {},
            }
            aoc.print("│{s:>3}│{s: >15} │{s: >15} │{d:>11.3} μs│\n", .{
                solution_day,
                @as([*:0]u8, @ptrCast(&result_text_1)),
                @as([*:0]u8, @ptrCast(&result_text_2)),
                @as(f64, @floatFromInt(time)) / std.time.ns_per_us,
            });
        }

        aoc.print("└───┴────────────────┴──────┬─────────┼─────────── + ┤\n", .{});
        total_ns += year_ns;
        aoc.print("                            │\x1B[1mYear time│{d:>11.3} μs\x1B[0m│\n", .{@as(f64, @floatFromInt(year_ns)) / std.time.ns_per_us});
        aoc.print("                            └─────────┴──────────────┘", .{});
    }
    aoc.print("\nTotal time:\x1B[1m {d:.3} ms\x1B[0m\n", .{@as(f64, @floatFromInt(total_ns)) / std.time.ns_per_ms});
}

test {
    std.testing.refAllDecls(@This());
}
