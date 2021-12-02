const std = @import("std");
const aoc = @import("common.zig");

// It seems like the submarine can take a series of commands like forward 1, down 2, or up 3:

// forward X increases the horizontal position by X units.
// down X increases the depth by X units.
// up X decreases the depth by X units.
// Note that since you're on a submarine, down and up affect your depth, and so they have the opposite result of what you might expect.

// The submarine seems to already have a planned course (your puzzle input). You should probably figure out where it's going. For example:

// forward 5
// down 5
// forward 8
// up 3
// down 8
// forward 2
// Your horizontal position and depth both start at 0. The steps above would then modify them as follows:

// forward 5 adds 5 to your horizontal position, a total of 5.
// down 5 adds 5 to your depth, resulting in a value of 5.
// forward 8 adds 8 to your horizontal position, a total of 13.
// up 3 decreases your depth by 3, resulting in a value of 2.
// down 8 adds 8 to your depth, resulting in a value of 10.
// forward 2 adds 2 to your horizontal position, a total of 15.
// After following these instructions, you would have a horizontal position of 15 and a depth of 10. (Multiplying these together produces 150.)

// Calculate the horizontal position and depth you would have after following the planned course. What do you get if you multiply your final horizontal position by your final depth?

pub fn run(input: aoc.Input) !aoc.Output {
    var part1: i64 = undefined;
    var part2: i64 = undefined;

    var part_1_horizontal_pos: i64 = 0;
    var part_1_depth: i64 = 0;

    var part_2_horizontal_pos: i64 = 0;
    var part_2_depth: i64 = 0;
    var part_2_aim: i64 = 0;

    var lines = aoc.tokenize(input, "\n");
    while (lines.next()) |line| {
        if (line[0] == 'f') {
            const distance = get_distance(line, "forward");
            part_1_horizontal_pos += distance;
            part_2_horizontal_pos += distance;
            part_2_depth += part_2_aim * distance;
        } else if (line[0] == 'd') {
            const distance = get_distance(line, "down");
            part_1_depth += distance;
            part_2_aim += distance;
        } else if (line[0] == 'u') {
            const distance = get_distance(line, "up");
            part_1_depth -= distance;
            part_2_aim -= distance;
        }
    }

    part1 = part_1_horizontal_pos * part_1_depth;
    part2 = part_2_horizontal_pos * part_2_depth;
    return aoc.Output{.part1 = part1, .part2 = part2};
}

fn get_distance(input: []const u8, comptime direction: []const u8) u8 {
    // aoc.print("direction: {s}, number: {}\n", .{direction, input[direction.len + 1] - '0'});
    return input[direction.len + 1] - '0';
}
