const std = @import("std");
const aoc = @import("common.zig");
const md5 = @import("md5.zig");

pub fn run(input: aoc.Input) !aoc.Output {
    var part1: i64 = 0;
    var part2: i64 = 0;
    var count: i64 = 0;
    var part1found: bool = false;
    var part2found: bool = false;
    // const input = "bgvyzdsv";
    var input_hash = md5.Md5.init(.{});
    input_hash.update(input);
    while (true) {
        var buf align(16) = [_]u8{undefined} **  8;
        var out align(16) = [_]u8{undefined} ** 16;
        const len = std.fmt.formatIntBuf(buf[0..], count, 10, .lower, .{}); // 50.000 μs
        // var out: [16]u8 = undefined;
        var final_hash = input_hash;
        final_hash.update(buf[0..len]);
        final_hash.final(out[0..]);
        // aoc.print("{s}\n", .{std.fmt.fmtSliceHexLower(out[0..])});
        // if (std.mem.eql(u40, @as(u40, "00000"), @as(u40, out[0..5]))) aoc.print("bingo");
        // if (count == 3938038) break;
        if (!part1found and std.mem.readIntSliceBig(u24, out[0..3]) >> 4 == 0) {part1found = true; part1 = count;}
        if (!part2found and std.mem.readIntSliceNative(u24, out[0..3]) == 0) {part2found = true; part2 = count;}
        if (part1found and part2found) break;
        count += 1;
    }
    return aoc.Output{.part1 = part1, .part2 = part2};
}
