const std = @import("std");
const aoc = @import("common.zig");

pub fn run(input: aoc.Input) !aoc.Output {
    var part1: i64 = undefined;
    var part2: i64 = undefined;
    var part2_found = false;

    var lines = aoc.tokenize(input, ", \n");
    var x: i16 = 0;
    var y: i16 = 0;
    const direction_vector = [4][2]i8{
        // X   Y
        .{ 0, 1 }, // North
        .{ 1, 0 }, // East
        .{ 0, -1 }, // South
        .{ -1, 0 }, // West
    };
    var direction: u2 = 0;
    var past_dirs = std.AutoHashMap([2]i16, void).init(aoc.allocator);
    defer past_dirs.deinit();
    try past_dirs.ensureTotalCapacity(256);
    try past_dirs.put(.{ 0, 0 }, {});
    while (lines.next()) |line| {
        if (line[0] == 'L') {
            direction -%= 1;
        } else if (line[0] == 'R') {
            direction +%= 1;
        }
        const current_direction_vector = direction_vector[direction];
        const distance: i16 = try std.fmt.parseInt(u8, line[1..], 10);

        {
            var i: i16 = 1;
            while (!part2_found and i <= distance) : (i += 1) {
                if (try past_dirs.fetchPut(.{ x + i * current_direction_vector[0], y + i * current_direction_vector[1] }, {})) |kv| {
                    part2 = @abs(kv.key[0]) + @abs(kv.key[1]);
                    part2_found = true;
                }
            }
        }

        x += distance * current_direction_vector[0];
        y += distance * current_direction_vector[1];
    }
    part1 = @abs(x) + @abs(y);
    return aoc.Output{ .part1 = part1, .part2 = part2 };
}

test "2016-1" {
    try aoc.testPart1(5, run("R2, L3"));
    try aoc.testPart1(2, run("R2, R2, R2"));
    try aoc.testPart1(12, run("R5, L5, R5, R3"));

    try aoc.testPart2(4, run("R8, R4, R4, R8"));
}
