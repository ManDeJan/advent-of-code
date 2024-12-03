const std = @import("std");
const aoc = @import("common.zig");

pub fn run(input: aoc.Input) !aoc.Output {
    var part1: aoc.OutputPart1 = 0;
    var part2: aoc.OutputPart2 = 0;

    var left_list = try aoc.newVecCap(i32, 1024);
    var rght_list = try aoc.newVecCap(i32, 1024);
    defer left_list.deinit();
    defer rght_list.deinit();

    var lines = aoc.splitLines(input);
    while (lines.next()) |line| {
        var numbers = aoc.tokenizeScalar(line, ' ');
        left_list.appendAssumeCapacity(try aoc.parseInt(i32, numbers.next().?));
        rght_list.appendAssumeCapacity(try aoc.parseInt(i32, numbers.next().?));
    }

    aoc.sort(i32, left_list.items, {}, std.sort.asc(i32));
    aoc.sort(i32, rght_list.items, {}, std.sort.asc(i32));

    for (left_list.items, rght_list.items) |left, right| {
        part1 += if (left < right) right - left else left - right;
    }

    aoc.assert(left_list.items.len == rght_list.items.len);
    const len = left_list.items.len;

    var i: u32 = 0;
    var j: u32 = 0;
    while (i < len) : (i += 1) {
        while (j < len and left_list.items[i] > rght_list.items[j]) {
            j += 1;
        }

        // This code assumes the left column has unique numbers, otherwise use code below:
        // while (j < len and left_list.items[i] == rght_list.items[j]) : (j += 1) {
        //     part2 += rght_list.items[j];
        // }

        // Use this if left has duplicate numbers:
        var right_count: i32 = 0;
        while (left_list.items[i] == rght_list.items[j] and j < len) {
            j += 1;
            right_count += 1;
        }

        part2 += left_list.items[i] * right_count;
        while (i + 1 < len and left_list.items[i] == left_list.items[i + 1]) : (i += 1) {
            part2 += left_list.items[i] * right_count;
        }
    }

    return aoc.Output{ .part1 = part1, .part2 = part2 };
}

test "2024-1" {
    try aoc.testBoth(11, 31, run(
        \\3   4
        \\4   3
        \\2   5
        \\1   3
        \\3   9
        \\3   3
        \\
    ));
}
