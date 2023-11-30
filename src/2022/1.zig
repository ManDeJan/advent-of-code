const std = @import("std");
const aoc = @import("common.zig");

pub fn run(input: aoc.Input) !aoc.Output {
    var part1: i64 = undefined;
    var part2: i64 = undefined;

    var elf_segments = aoc.split(input, "\n\n");

    var top1: u32 = 0;
    var top2: u32 = 0;
    var top3: u32 = 0;

    while (elf_segments.next()) |elf_segment| {
        var calorie_lines = aoc.tokenize(elf_segment, "\n");
        var total_calories: u32 = 0;

        while (calorie_lines.next()) |calorie_line| {
            total_calories += try std.fmt.parseInt(u32, calorie_line, 10);
        }

        insertInTop3(&top1, &top2, &top3, total_calories);
    }

    part1 = top1;
    part2 = top1 + top2 + top3;
    return aoc.Output{ .part1 = part1, .part2 = part2 };
}

inline fn insertInTop3(top1: *u32, top2: *u32, top3: *u32, new: u32) void {
    if (new > top1.*) {
        top3.* = top2.*;
        top2.* = top1.*;
        top1.* = new;
    } else if (new > top2.*) {
        top3.* = top2.*;
        top2.* = new;
    } else if (new > top3.*) {
        top3.* = new;
    }
}

test "2022-1" {
    try aoc.testBoth(24000, 45000, run(
        \\1000
        \\2000
        \\3000
        \\
        \\4000
        \\
        \\5000
        \\6000
        \\
        \\7000
        \\8000
        \\9000
        \\
        \\10000
    ));
}
