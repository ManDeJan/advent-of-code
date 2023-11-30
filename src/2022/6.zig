const std = @import("std");
const aoc = @import("common.zig");

pub fn run(input: aoc.Input) !aoc.Output {
    const part1: i64 = uniqueInWindow(4, input);
    const part2: i64 = uniqueInWindow(14, input);

    return aoc.Output{ .part1 = part1, .part2 = part2 };
}

const BitSet = std.bit_set.IntegerBitSet(letterToValue('z') + 1);

fn uniqueInWindow(comptime window: comptime_int, input: aoc.Input) i64 {
    var letters = BitSet.initEmpty();
    for (input[0..window]) |letter| letters.toggle(letterToValue(letter));
    {
        var i: usize = 0;
        while (true) : (i += 1) {
            if (letters.count() == window) return @intCast(i + window);
            letters.toggle(letterToValue(input[i + window]));
            letters.toggle(letterToValue(input[i]));
        }
    }
}

fn letterToValue(letter: u8) u8 {
    return letter - ('z' - 32 + 1);
}

test "2022-6" {
    try aoc.testBoth(7, 19, run("mjqjpqmgbljsphdztnvjfqwrcgsmlb\n"));
    try aoc.testBoth(5, 23, run("bvwbjplbgvbhsrlpgdmjqwftvncz\n"));
    try aoc.testBoth(6, 23, run("nppdvjthqldpwncqszvftbrmjlhg\n"));
    try aoc.testBoth(10, 29, run("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg\n"));
    try aoc.testBoth(11, 26, run("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw\n"));
}
