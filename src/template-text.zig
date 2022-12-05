const std = @import("std");
const aoc = @import("common.zig");

pub fn run(input: aoc.Input, part1: []u8, part2: []u8) !void {
    _ = input;
    std.mem.copy(u8, part1, "Hallo");
    std.mem.copy(u8, part2, "Wereld");
}

test "20xx-x" {
    try aoc.testBothText("Hallo", "Wereld", run,
        \\
    );
}
