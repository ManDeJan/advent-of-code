const std = @import("std");
const aoc = @import("common.zig");

// Expected: Part 1: 719796 Part 2: 144554112

pub fn run(input: aoc.Input) anyerror!aoc.Output {
    const target = 2020;
    var set = [_]bool{false} ** (target + 1);

    var lines = aoc.tokenize(input, "\n");
    while (lines.next()) |line| {
        set[try std.fmt.parseInt(u32, line, 10)] = true;
    }

    var part1: i64 = undefined;
    for (set) | num, i | {
        const remainder = target - i;
        if (set[remainder] and num) {
            part1 = @intCast(i64, i * remainder);
            break;
        }
    }

    var part2: i64 = undefined;
    outer: for (set) | num1, i | {
        if (!num1) continue;
        for (set[i..target-i]) |num2, j| {
            const ij = i+j;
            const remainder = target - i - ij;
            if (set[remainder] and num2) {
                part2 = @intCast(i64, i * ij * remainder);
                break :outer;
            }
        }
    }

    return aoc.Output{.part1 = part1, .part2 = part2};
}
