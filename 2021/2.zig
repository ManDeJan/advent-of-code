const std = @import("std");
const aoc = @import("common.zig");

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
