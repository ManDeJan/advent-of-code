const std = @import("std");
const aoc = @import("common.zig");

pub fn run(input: aoc.Input) anyerror!aoc.Output {
    var part1: i64 = undefined;
    var part2: i64 = undefined;

    var joltages = [_]bool{false} ** 256; // preallocated
    var lines = aoc.tokenize(input, "\n");

    var max_joltage: u8 = 0;
    while (lines.next()) |line| {
        const joltage = try std.fmt.parseInt(u8, line, 10);
        joltages[joltage] = true;
        max_joltage = if (max_joltage < joltage) joltage else max_joltage;
    }

    var i: usize = 1;
    var diff1: i64 = 1;
    var diff3: i64 = 0;
    var connected1s = [_]usize{0} ** 6;
    var cons: usize = 1;
    while (i < max_joltage + 2) {
        // print("{:3}: {}\n", .{i, joltages[i]});
        if (joltages[i]) {
            diff1 += 1;
            i += 1;
            cons += 1;
            // if (cons > 1) print("{} ", .{1});
        } else {
            diff1 -= 1;
            diff3 += 1;
            i += 2;
            // print("{} ", .{3});
            if (cons > 2) connected1s[cons] += 1;
            cons = 0;
        }
    }
    part1 = diff1 * diff3;
    // print("\n{}, {}\n", .{diff1, diff3});
    // for (connected1s) |s, c| {
    //     print("{}: {}\n", .{c, s});
    // }
    const pow = std.math.pow; // permutations per consecutive ones ^ times they occured
    part2 = @intCast(pow(usize, 7, connected1s[5]) *
        pow(usize, 4, connected1s[4]) *
        pow(usize, 2, connected1s[3]));

    return aoc.Output{ .part1 = part1, .part2 = part2 };
}
