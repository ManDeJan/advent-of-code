const std = @import("std");
const aoc = @import("common.zig");

pub noinline fn run(input: aoc.Input) !aoc.Output {
    var part1: i64 = 0;
    var part2: i64 = 0;

    var nums_s = aoc.tokenize(input, ",\n");
    var nums = aoc.newVec(u16);
    var sum: u32 = 0;
    while (nums_s.next()) |num_s| {
        const num = try std.fmt.parseInt(u16, num_s, 10);
        try nums.append(num);
        sum += num;
    }
    // std.sort.sort(u16, nums.items, {}, comptime std.sort.asc(u16));

    const len = @intCast(u32, nums.items.len);
    const mean1 = sum / len;
    const mean2 = mean1 + 1;
    const median = if (nums.items[len / 2] % 2 == 0) (nums.items[len / 2 - 1] + nums.items[len / 2]) / 2
                   else nums.items[len / 2];
    var part2_1: u32 = 0;
    var part2_2: u32 = 0;
    for (nums.items) |num| {
        part1 += if (num < median) median - num else num - median;
        
        const distance1 = if (num < mean1) mean1 - num else num - mean1;
        const distance2 = if (num < mean2) mean2 - num else num - mean2;
        part2_1 += distance1 * (distance1 + 1) / 2;
        part2_2 += distance2 * (distance2 + 1) / 2;
    }
    part2 = std.math.min(part2_1, part2_2);
    return aoc.Output{.part1 = part1, .part2 = part2};
}
