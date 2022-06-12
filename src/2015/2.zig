const std = @import("std");
const aoc = @import("common.zig");

pub fn run(input: aoc.Input) !aoc.Output {
    var part1: i64 = 0;
    var part2: i64 = 0;

    var lines = aoc.tokenize(input, "\n");
    while (lines.next()) |line| {
        var dims_s = aoc.tokenize(line, "x");
        var dims: [3]u8 = undefined;
        inline for (aoc.range(3)) |_, i| {
            dims[i] = try std.fmt.parseInt(u5, dims_s.next().?, 10);
        }
        partialSort3Numbers(&dims); // slightly faster then std.sort.sort
        part1 += 2 * @as(u16, dims[2]) * (dims[0] + dims[1]) + 3 * @as(u16, dims[0]) * dims[1];
        part2 += 2 * @as(u16, (dims[0] + dims[1])) + @as(u16, dims[0]) * dims[1] * dims[2];
    }

    return aoc.Output{.part1 = part1, .part2 = part2};
}

fn partialSort3Numbers(dims: *[3]u8) void {
    if (dims[0] > dims[1]) std.mem.swap(u8, &dims[0], &dims[1]);
    if (dims[1] > dims[2]) std.mem.swap(u8, &dims[1], &dims[2]);
    // if (dims[0] > dims[1]) std.mem.swap(u8, &dims[0], &dims[1]);
}

test "2015-2" {
    try aoc.testBoth(58, 34, run("2x3x4"));
    try aoc.testBoth(43, 14, run("1x1x10"));
}
