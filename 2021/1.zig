const std = @import("std");
const aoc = @import("common.zig");

pub inline fn run(input: aoc.Input) anyerror!aoc.Output {
    var part1: i64 = 0;
    var part2: i64 = 0;

    var lines = aoc.tokenize(input, "\n");
    var nums = aoc.newVec(u32);
    while (lines.next()) |line| {
        try nums.append(try std.fmt.parseInt(u32, line, 10));
    }

    for (nums.items[0..nums.items.len-1]) | num, i | {
        if (num < nums.items[i + 1]) { part1 += 1; }
    }

    for (nums.items[0..nums.items.len-3]) | num, i | {
        if (num < nums.items[i + 3]) { part2 += 1; }
    }

    return aoc.Output{.part1 = part1, .part2 = part2};
}
