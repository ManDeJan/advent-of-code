const std = @import("std");
const aoc = @import("common.zig");

pub fn run(input: aoc.Input) !aoc.Output {
    var part1: i64 = 0;
    var part2: i64 = 0;

    const lines = std.mem.bytesAsSlice([4]u8, input);
    for (lines) |line| {
        const a: u8 = line[0];
        const b: u8 = line[2];
        // Help out the optimizer by asserting our input is always constrained
        std.debug.assert(a >= 'A' and a <= 'C' and b >= 'X' and b <= 'Z');
        part1 += 1 + (b - 'X') + 3 * ((b - a - 1) % 3);
        part2 += 1 + (b - 'X') * 3 + ((a + b - 1) % 3);
    }

    return aoc.Output{ .part1 = part1, .part2 = part2 };
}

test "2022-2" {
    try aoc.testBoth(15, 12, run(
        \\A Y
        \\B X
        \\C Z
        \\
    ));
}
