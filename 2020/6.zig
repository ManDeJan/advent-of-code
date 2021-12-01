const std = @import("std");
const aoc = @import("common.zig");

pub inline fn run(input: aoc.Input) anyerror!aoc.Output {
    var part1: i64 = 0;
    var part2: i64 = 0;

    var groups = aoc.split(input, "\n\n");
    const questions_len = 26;
    while (groups.next()) | group | {
        var answered = [_]u8{0} ** questions_len;
        var group_size: u8 = 1;
        for (group) | letter, c | {
            if (letter == '\n') { if (c != group.len - 1) group_size += 1; continue; }
            answered[letter - 'a'] += 1;
        }
        for (answered) | answer | {
            if (answer != 0)          part1 += 1;
            if (answer == group_size) part2 += 1;
        }
    }

    return aoc.Output{.part1 = part1, .part2 = part2};
}
