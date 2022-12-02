const std = @import("std");
const aoc = @import("common.zig");

pub fn run(input: aoc.Input) !aoc.Output {
    var part1: i64 = 0;
    var part2: i64 = 0;

    const lines = std.mem.bytesAsSlice([4]u8, input);
    for (lines) |line| {
        switch (matchToInt(line[0], line[2])) {
            //                               W/L Shp         W/L Shp
            matchToInt('B', 'X') => {part1 += 0 + 1; part2 += 0 + 1;},
            matchToInt('C', 'Y') => {part1 += 0 + 2; part2 += 3 + 3;},
            matchToInt('A', 'Z') => {part1 += 0 + 3; part2 += 6 + 2;},
            matchToInt('A', 'X') => {part1 += 3 + 1; part2 += 0 + 3;},
            matchToInt('B', 'Y') => {part1 += 3 + 2; part2 += 3 + 2;},
            matchToInt('C', 'Z') => {part1 += 3 + 3; part2 += 6 + 1;},
            matchToInt('C', 'X') => {part1 += 6 + 1; part2 += 0 + 2;},
            matchToInt('A', 'Y') => {part1 += 6 + 2; part2 += 3 + 1;},
            matchToInt('B', 'Z') => {part1 += 6 + 3; part2 += 6 + 3;},
            else => unreachable,
        }
    }

    return aoc.Output{.part1 = part1, .part2 = part2};
}

fn matchToInt(a: u8, b: u8) u4 {
    if (a == 'B' and b == 'X') return 1;
    if (a == 'C' and b == 'Y') return 2;
    if (a == 'A' and b == 'Z') return 3;
    if (a == 'A' and b == 'X') return 4;
    if (a == 'B' and b == 'Y') return 5;
    if (a == 'C' and b == 'Z') return 6;
    if (a == 'C' and b == 'X') return 7;
    if (a == 'A' and b == 'Y') return 8;
    if (a == 'B' and b == 'Z') return 9;
    unreachable;
}

test "2022-2" {
    try aoc.testBoth(15, 12, run(
        \\A Y
        \\B X
        \\C Z
        \\
    ));
}
