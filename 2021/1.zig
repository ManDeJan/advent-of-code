const std = @import("std");
const aoc = @import("common.zig");

pub inline fn run(input: aoc.Input) !aoc.Output {
    var part1: i64 = 0;
    var part2: i64 = 0;

    var nums = try aoc.input_as_ints(u32, input);

    for (nums.items[0..nums.items.len-1]) | num, i | {
        if (num < nums.items[i + 1]) { part1 += 1; }
    }

    for (nums.items[0..nums.items.len-3]) | num, i | {
        if (num < nums.items[i + 3]) { part2 += 1; }
    }

    return aoc.Output{.part1 = part1, .part2 = part2};
}

// below is a jank version that skips the allocation, it isn't meaningfully faster tho
// var window1 = try std.fmt.parseInt(u32, lines.next().?, 10);
// var window2 = try std.fmt.parseInt(u32, lines.next().?, 10);
// var window3 = try std.fmt.parseInt(u32, lines.next().?, 10);
// var window4 = try std.fmt.parseInt(u32, lines.next().?, 10);

// while (lines.next()) |line| {
//     if (window1 < window2) { part1 += 1; }
//     if (window1 < window4) { part2 += 1; }

//     window1 = window2;
//     window2 = window3;
//     window3 = window4;
//     window4 = try std.fmt.parseInt(u32, line, 10);
// }

// if (window1 < window2) { part1 += 1; }
// if (window2 < window3) { part1 += 1; }
// if (window3 < window4) { part1 += 1; }
// if (window1 < window4) { part2 += 1; }
