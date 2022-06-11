const std = @import("std");
const aoc = @import("common.zig");

pub noinline fn run(input: aoc.Input) !aoc.Output {
    var part1: i64 = 0;
    var part2: i64 = 0;

    const lookuptable_80 = comptime calculateLookupTable(80);
    const lookuptable_256 = comptime calculateLookupTable(256);

    var nums = aoc.tokenize(input, ",");
    while (nums.next()) |num_s| {
        const num = num_s[0] - '0';
        part1 += @intCast(i64, lookuptable_80[num]);
        part2 += @intCast(i64, lookuptable_256[num]);
    }
    return aoc.Output{.part1 = part1, .part2 = part2};
}

fn calculateLookupTable(comptime days: usize) [9]usize {
    @setEvalBranchQuota(8000);
    var i: usize = 0;
    var pond  = [_]usize{0} ** 9;
    var table = [_]usize{0} ** 9;
    pond[0] = 1;

    while (i < days) : (i += 1) {
        std.mem.rotate(usize, pond[0..], 1);
        pond[6] += pond[8];
        if (i >= days - 9) {
            table[8 - (i - (days-9))] = blk: {
                var sum: usize = 0; 
                for (pond) | fish | { sum += fish; }
                break :blk sum;
            };
        }
    }
    return table;
}
