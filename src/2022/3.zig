const std = @import("std");
const aoc = @import("common.zig");

const BitSet = std.bit_set.IntegerBitSet(letterToValue('Z') + 1);

pub fn run(input: aoc.Input) !aoc.Output {
    var part1: i64 = 0;
    var part2: i64 = 0;

    var rucksacks = aoc.tokenize(input, "\n");
    var last_three_sets = [_]BitSet{BitSet.initEmpty()} ** 3;
    var set1 = BitSet.initEmpty();
    {var i: usize = 0; while (rucksacks.next()) |rucksack| : (i += 1) {
        set1.mask = 0;
        last_three_sets[i % 3].mask = 0;

        const len = rucksack.len;
        for (rucksack[0..len/2]) |letter| {
            const value = letterToValue(letter);
            last_three_sets[i % 3].set(value);
            set1.set(value);
        }
        var part1_found = false;
        for (rucksack[len/2..]) |letter| {
            const value = letterToValue(letter);
            last_three_sets[i % 3].set(value);
            if (!part1_found and set1.isSet(value)) {
                part1 += 1 + value; part1_found = true;
            }
        }

        if (i % 3 == 2) {
            last_three_sets[0].setIntersection(last_three_sets[1]);
            last_three_sets[0].setIntersection(last_three_sets[2]);
            part2 += 1 + @intCast(i64, last_three_sets[0].findFirstSet().?);
        }
    }}

    return aoc.Output{.part1 = part1, .part2 = part2};
}

fn letterToValue(letter: u8) u6 {
    const mod = 'z' - 'A' + 1;
    const shift = 'a' % mod;
    return @truncate(u6, (letter - shift) % mod);
}

test "2022-3" {
    try aoc.testBoth(157, 70, run(
        \\vJrwpWtwJgWrhcsFMMfFFhFp
        \\jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
        \\PmmdzqPrVvPwwTWBwg
        \\wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
        \\ttgJtRGJQctTZtZT
        \\CrZsJsPPZsGzwwsLwLmpwMDw
        \\
    ));
}
