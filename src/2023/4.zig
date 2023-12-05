const std = @import("std");
const aoc = @import("common.zig");

pub fn run(input: aoc.Input) !aoc.Output {
    const part1: i64 = 0;
    _ = part1;
    const part2: i64 = 0;
    _ = part2;
    const params = ScratchCardParams.fromInput(input);
    const test_params = comptime ScratchCardParams.fromInput("Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53\n");
    const real_params = comptime ScratchCardParams.fromInput("Card   1: 44 22 11 15 37 50  3 90 60 34 | 35 60 76  3 21 84 45 52 15 72 13 31 90  6 37 44 34 53 68 22 50 38 67 11 55\n");

    // hardcoded cases for test & input parameters
    const output = if (std.meta.eql(params, test_params))
        scratchCards(test_params, input)
    else if (std.meta.eql(params, real_params))
        scratchCards(real_params, input)
    else
        unreachable;

    return output;
}

const ScratchCardParams = struct {
    lucky_start: usize,
    scratch_start: usize,
    length: usize,

    const Self = @This();

    pub fn fromInput(input: aoc.Input) ScratchCardParams {
        const lucky_start = std.mem.indexOfScalarPos(u8, input, "Card X".len, ':').? + 1;
        const scratch_start = std.mem.indexOfScalarPos(u8, input, lucky_start, '|').? + 1;
        const length = std.mem.indexOfScalarPos(u8, input, scratch_start, '\n').? + 1;
        return ScratchCardParams{ .lucky_start = lucky_start, .scratch_start = scratch_start, .length = length };
    }
};

fn scratchCards(
    comptime params: ScratchCardParams,
    input: aoc.Input,
) !aoc.Output {
    const lucky_start = params.lucky_start;
    const scratch_start = params.scratch_start;
    const length = params.length;
    const lucky_n = (scratch_start - lucky_start) / 3;
    const scratch_n = (length - scratch_start) / 3;

    var card_counts = aoc.newVec(u32);
    try card_counts.appendNTimes(1, input.len / length);

    var part1: i64 = 0;
    var i: usize = length;
    while (i <= input.len) : (i += length) {
        const card = input[i - length .. i];
        const lucky_nums = blk: {
            var lucky_nums: [lucky_n]u16 = undefined;
            inline for (0..lucky_n) |n| {
                lucky_nums[n] = std.mem.readInt(u16, card[lucky_start + n * 3 + 1 .. lucky_start + n * 3 + 3], aoc.native);
            }
            break :blk lucky_nums;
        };
        const scratch_nums = blk: {
            var scratch_nums: [scratch_n]u16 = undefined;
            inline for (0..scratch_n) |n| {
                scratch_nums[n] = std.mem.readInt(u16, card[scratch_start + n * 3 + 1 .. scratch_start + n * 3 + 3], aoc.native);
            }
            break :blk scratch_nums;
        };

        var matching: u32 = 0;
        // const scratch_vec: @Vector(scratch_n, u16) = scratch_nums;
        // for (lucky_nums) |l| {
        //     const lucky_vec: @Vector(scratch_n, u16) = @splat(l);
        //     matching += @intFromBool(@reduce(.Or, scratch_vec == lucky_vec));
        // }

        for (lucky_nums) |l| {
            inline for (scratch_nums) |s| {
                if (l == s) matching += 1;
            }
        }

        part1 += if (matching > 0) std.math.pow(i64, 2, matching - 1) else 0;
        for (i / length..matching + i / length) |j|
            card_counts.items[j] += card_counts.items[i / length - 1];
    }
    var part2: i64 = 0;
    for (card_counts.items) |c| part2 += c;
    return aoc.Output{ .part1 = part1, .part2 = part2 };
}

test "2023-4" {
    try aoc.testBoth(13, 30, run(
        \\Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
        \\Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
        \\Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
        \\Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
        \\Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
        \\Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
        \\
    ));
}
