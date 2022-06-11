const std = @import("std");
const aoc = @import("common.zig");

pub fn run(input: aoc.Input) anyerror!aoc.Output {
    var part1: i64 = 0;
    var part2: i64 = undefined;

    const line_width = 11;
    const passes = std.mem.bytesAsSlice([line_width]u8, input);

    var seats = [_]bool{false} ** 1024;
    for (passes) | pass | {
        var id: u32 = 0;
        for (pass[0..line_width-1]) | letter | {
            id <<= 1; // bit boop bap
            id |= @as(u32, ~(letter >> 2) & 1);
        }
        // print("{}\n", .{id});
        seats[id] = true;
        if (id > part1) part1 = id;
    }
    for (seats) | seat, c | {
        if (seat and !seats[c+1] and seats[c+2]) {
            part2 = @intCast(i64, c + 1);
            break;
        }
    }

    return aoc.Output{.part1 = part1, .part2 = part2};
}
