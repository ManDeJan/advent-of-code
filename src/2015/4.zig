const std = @import("std");
const aoc = @import("common.zig");
const Md5 = @import("md5.zig").Md5;
// const Md5 = std.crypto.hash.Md5;

pub fn run(input: aoc.Input) !aoc.Output {
    var part1: i64 = 0;
    var part2: i64 = 0;
    var count: i64 = 0;
    var part1found: bool = false;
    var part2found: bool = false;

    var input_hash = Md5.init(.{});
    input_hash.update(input);
    while (true) {
        var buf align(16) = [_]u8{undefined} ** 8;
        var out align(16) = [_]u8{undefined} ** 16;
        const len = std.fmt.formatIntBuf(buf[0..], count, 10, .lower, .{}); // 50.000 μs

        var final_hash = input_hash;
        final_hash.update(buf[0..len]);
        final_hash.final(out[0..]);

        if (!part1found and std.mem.readInt(u24, out[0..3], .big) >> 4 == 0) {
            part1found = true;
            part1 = count;
        }
        if (!part2found and std.mem.readInt(u24, out[0..3], .little) == 0) {
            part2found = true;
            part2 = count;
        }
        if (part1found and part2found) break;
        count += 1;
    }
    return aoc.Output{ .part1 = part1, .part2 = part2 };
}

test "2015-4" {
    // currently disabled because they're so slow
    try aoc.testPart1(609043, run("abcdef"));
    try aoc.testPart1(1048970, run("pqrstuv"));
}
