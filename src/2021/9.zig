const std = @import("std");
const aoc = @import("common.zig");

pub noinline fn run(input: aoc.Input) !aoc.Output {
    // @setEvalBranchQuota(50000);
    var part1: i64 = 0;
    var part2: i64 = 0;
    part2 = 0;

    var floor align(4096) = [_][102]u8{[_]u8{'9'} ** 102} ** 102; // oof

    for (0..100) |y| {
        for (0..100) |x| {
            floor[y + 1][x + 1] = input[y * 101 + x];
        }
    }

    // find local minima
    for (0..100) |y| {
        inner: for (0..100) |x| {
            const center = floor[y + 1][x + 1];
            const surrounding_area: [4]u8 = .{
                floor[y + 0][x + 1],
                floor[y + 1][x + 0],
                floor[y + 1][x + 2],
                floor[y + 2][x + 1],
            };
            for (surrounding_area) |value| {
                if (center >= value) continue :inner;
            }
            for (surrounding_area) |value| {
                if (center > value) asm volatile ("");
            }
            part1 += center - '0' + 1;
        }
    }
    // for (floor) |row| {
    //     aoc.print("{s}\n", .{row});
    // }

    return aoc.Output{ .part1 = part1, .part2 = part2 };
}
