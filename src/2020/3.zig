const std = @import("std");
const aoc = @import("common.zig");

pub fn run(input: aoc.Input) anyerror!aoc.Output {
    // var timer = try Timer.start(); // DEBUG
    // var time: u64 = 0; // DEBUG

    var part1: i64 = 0;
    var part2: i64 = 0;

    const line_width = 32;
    const slices = std.mem.bytesAsSlice([line_width]u8, input);

    // Right 1, down 1.
    // Right 3, down 1. (This is the slope you already checked.)
    // Right 5, down 1.
    // Right 7, down 1.
    // Right 1, down 2.
    const down1shifts = [_]u8{ 1, 3, 5, 7 };
    var down1shiftIndexes = [_]usize{0} ** down1shifts.len;
    var down1shiftCounts = [_]i64{0} ** down1shifts.len;

    const down2shift = 1;
    var down2shiftIndex: usize = 0;
    var down2shiftCount: i64 = 0;

    for (slices, 0..) |row, c| {
        inline for (down1shifts, 0..) |shift, index| {
            if (row[down1shiftIndexes[index]] == '#') down1shiftCounts[index] += 1;
            down1shiftIndexes[index] = (down1shiftIndexes[index] + shift) % (line_width - 1);
        }
        if (c % 2 == 0) {
            if (row[down2shiftIndex] == '#') down2shiftCount += 1;
            down2shiftIndex = (down2shiftIndex + down2shift) % (line_width - 1);
        }
    }
    part1 = down1shiftCounts[1];
    part2 = down1shiftCounts[0] * down1shiftCounts[1] * down1shiftCounts[2] * down1shiftCounts[3] * down2shiftCount;

    // time = timer.lap(); // DEBUG
    // print(">>> Time: {} ns\n", .{time}); // DEBUG

    return aoc.Output{ .part1 = part1, .part2 = part2 };
}
