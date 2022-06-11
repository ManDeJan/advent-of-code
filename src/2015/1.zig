const std = @import("std");
const aoc = @import("common.zig");

pub fn run(input: aoc.Input) !aoc.Output {
    var part1: i64 = 0;
    var part2: i64 = 0;

    for (input) |c, i| {
        if (c == '(') part1 += 1 else part1 -= 1;
        if (part2 == 0 and part1 == -1) part2 = @intCast(i64, i) + 1;
    }

    return aoc.Output{.part1 = part1, .part2 = part2};
}
