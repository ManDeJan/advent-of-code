const std = @import("std");
const aoc = @import("common.zig");

pub noinline fn run(input: aoc.Input) !aoc.Output {
    var part1: i64 = undefined;
    var part2: i64 = undefined;

    var horizontal_pos: i64 = 0;
    var vertical_pos: i64 = 0;
    var aim: i64 = 0;

    var lines = aoc.tokenize(input, "\n");
    while (lines.next()) |line| {
        if (line[0] == 'f') {
            const distance = get_distance(line, "forward");
            horizontal_pos += distance;
            vertical_pos += distance * aim;
        } else if (line[0] == 'd') {
            aim += get_distance(line, "down");
        } else if (line[0] == 'u') {
            aim -= get_distance(line, "up");
        }
    }

    part1 = horizontal_pos * aim;
    part2 = horizontal_pos * vertical_pos;
    return aoc.Output{ .part1 = part1, .part2 = part2 };
}

fn get_distance(input: []const u8, comptime direction: []const u8) u8 {
    // aoc.print("direction: {s}, number: {}\n", .{direction, input[direction.len + 1] - '0'});
    return input[direction.len + 1] - '0';
}
