const std = @import("std");
const aoc = @import("common.zig");

//   0:      1:      2:      3:      4:     5:      6:      7:      8:      9:
//  aaaa    ....    aaaa    aaaa    ....    aaaa    aaaa    aaaa    aaaa    aaaa
// b    c  .    c  .    c  .    c  b    c  b    .  b    .  .    c  b    c  b    c
// b    c  .    c  .    c  .    c  b    c  b    .  b    .  .    c  b    c  b    c
//  ....    ....    dddd    dddd    dddd    dddd    dddd    ....    dddd    dddd
// e    f  .    f  e    .  .    f  .    f  .    f  e    f  .    f  e    f  .    f
// e    f  .    f  e    .  .    f  .    f  .    f  e    f  .    f  e    f  .    f
//  gggg    ....    gggg    gggg    ....   gggg     gggg    ....    gggg    gggg

// number : segments - note
// 1 : 2 - unique
// 7 : 3 - unique
// 4 : 4 - unique
// 8 : 7 - unique

// shared  1 4-1
// 3 : 5 - 2   1
// 2 : 5 - 1   1
// 5 : 5 - 1   2

// shared  1 4-1
// 0 : 6 - 2   1
// 6 : 6 - 1   2
// 9 : 6 - 2   2
// we only need to match with 1 and 4 to get a unique set of segments

pub noinline fn run(input: aoc.Input) !aoc.Output {
    var part1: i64 = 0;
    var part2: i64 = 0;

    var lines = aoc.tokenize(input, "\n");
    while (lines.next()) |line| {
        var output_digits = aoc.tokenize(line[61..], " ");
        const outputs = [_][]const u8{
            output_digits.next().?,
            output_digits.next().?,
            output_digits.next().?,
            output_digits.next().?,
        };
        for (outputs) |output| {
            inline for (.{ 2, 3, 4, 7 }) |unique_len| {
                if (@as(u8, @intCast(output.len)) == unique_len) part1 += 1;
            }
        }
        var input_digits = aoc.tokenize(line[0..58], " ");
        var one_string: *const [2]u8 = undefined;
        var four_string: *const [4]u8 = undefined;
        var four_min_one_string: [2]u8 = undefined;

        var found_one = false;
        var found_four = false;
        for (0..10) |_| {
            const next_input = input_digits.next().?;
            if (next_input.len == 2) {
                one_string = next_input[0..2];
                found_one = true;
            } else if (next_input.len == 4) {
                four_string = next_input[0..4];
                found_four = true;
            }
            if (found_one and found_four) break;
        }

        var found_one_match = false;
        for (0..4) |i| {
            if (four_string[i] != one_string[0] and
                four_string[i] != one_string[1])
            {
                four_min_one_string[@intFromBool(found_one_match)] = four_string[i];
                found_one_match = true;
            }
        }
        for ([_]u32{ 1000, 100, 10, 1 }, 0..) |order, i| {
            part2 += order * @as(u32, switch (outputs[i].len) {
                2 => 1,
                3 => 7,
                4 => 4,
                7 => 8,

                5 => @as(u32, blk: {
                    var one_matches: u32 = 0;
                    for (0..5) |j| {
                        if (outputs[i][j] == one_string[0] or outputs[i][j] == one_string[1])
                            one_matches += 1;
                    }
                    if (one_matches == 2) break :blk 3;
                    var four_matches: u32 = 0;
                    for (0..5) |j| {
                        if (outputs[i][j] == four_min_one_string[0] or outputs[i][j] == four_min_one_string[1])
                            four_matches += 1;
                    }
                    if (four_matches == 2) break :blk 5;
                    break :blk 2;
                }),
                6 => @as(u32, blk: {
                    var one_matches: u32 = 0;
                    for (0..6) |j| {
                        if (outputs[i][j] == one_string[0] or outputs[i][j] == one_string[1])
                            one_matches += 1;
                    }
                    if (one_matches == 1) break :blk 6;
                    var four_matches: u32 = 0;
                    for (0..6) |j| {
                        if (outputs[i][j] == four_min_one_string[0] or outputs[i][j] == four_min_one_string[1])
                            four_matches += 1;
                    }
                    if (four_matches == 1) break :blk 0;
                    break :blk 9;
                }),
                else => unreachable,
            });
        }
    }
    return aoc.Output{ .part1 = part1, .part2 = part2 };
}
