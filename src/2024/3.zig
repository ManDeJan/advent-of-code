const std = @import("std");
const aoc = @import("common.zig");

const Pair = [2]u32;

fn findEnd(haystack: []const u8) ?usize {
    return std.mem.indexOfScalarPos(u8, haystack, 0, ')');
}

fn parsePair(pair: []const u8) !Pair {
    aoc.assert(pair.len >= "0,0".len);
    aoc.assert(pair.len <= "000,000".len);
    var idxcomma: ?usize = null;
    for (pair, 0..) |c, i| {
        if (!std.ascii.isDigit(c) and c != ',') return .{ 0, 0 };
        if (c == ',') {
            if (idxcomma != null) return .{ 0, 0 };
            idxcomma = i;
        }
    }
    if (idxcomma == null) return .{ 0, 0 };
    return .{
        try aoc.parseInt(u16, pair[0..idxcomma.?]),
        try aoc.parseInt(u16, pair[idxcomma.? + 1 ..]),
    };
}

pub fn run(input: aoc.Input) !aoc.Output {
    var part1: aoc.OutputPart1 = 0;
    var part2: aoc.OutputPart2 = 0;

    const min_mul = "mul(0,0)".len;
    const max_mul = "mul(000,000)".len;

    var enable_mul: bool = true;

    var i: usize = 0;
    while (i < input.len - min_mul) {
        const rem = input[i..];

        if (std.mem.startsWith(u8, rem[0..], "do()")) {
            enable_mul = true;
        }

        if (std.mem.startsWith(u8, rem[0..], "don't()")) {
            enable_mul = false;
        }

        if (std.mem.startsWith(u8, rem[0..], "mul(")) {
            const start = "mul(".len;
            const end = findEnd(rem[start..max_mul]);
            if (end == null) {
                i += start;
                continue;
            }
            const pair: Pair = try parsePair(rem[start .. start + end.?]);
            // aoc.print("{s} {any}\n", .{ rem[start .. start + end.?], pair });
            part1 += pair[0] * pair[1];
            if (enable_mul) part2 += pair[0] * pair[1];
        }

        i += 1;
    }

    return aoc.Output{ .part1 = part1, .part2 = part2 };
}

test "2024-3" {
    // try aoc.testPart1(0, run(""));
    // try aoc.testPart2(0, run(""));
}
