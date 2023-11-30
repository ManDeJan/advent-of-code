const std = @import("std");
const aoc = @import("common.zig");

pub fn run(input: aoc.Input) !aoc.Output {
    var part1: i64 = undefined;
    var part2: i64 = undefined;

    return aoc.Output{ .part1 = part1, .part2 = part2 };
}

test "20xx-x" {
    try aoc.testPart1(0, run(""));
    try aoc.testPart2(0, run(""));
}
