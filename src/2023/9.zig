const std = @import("std");
const aoc = @import("common.zig");

pub fn run(input: aoc.Input) !aoc.Output {
    var part1: i64 = 0;
    var part2: i64 = 0;

    var lines = aoc.splitLines(input);
    var nums = try aoc.newVecCap(i32, 21);
    defer nums.deinit();
    while (lines.next()) |line| {
        nums.clearRetainingCapacity();
        var num_strs = aoc.tokenizeScalar(line, ' ');
        while (num_strs.next()) |num_str| try nums.append(try aoc.parseInt(i32, num_str));
        var pair = Pair{
            .next = nums.items[nums.items.len-1],
            .prev = nums.items[0],
        };
        pair = pair.add(switch (nums.items.len) {
            inline 6, 21 => |len| completeSequence(len, nums.items[0..len]),
            else => unreachable
        });
        // aoc.print("Next: {}\n", .{next});
        part1 += pair.next;
        part2 += pair.prev;
    }
    return aoc.Output{ .part1 = part1, .part2 = part2 };
}

const Pair = struct {
    next: i32,
    prev: i32,
    pub fn add(self: Pair, other: Pair) Pair {
        return Pair {
            .next = self.next + other.next,
            .prev = self.prev - other.prev,
        };
    }
};

inline fn completeSequence(comptime size: comptime_int, items: *const [size]i32) Pair {
    if (size <= 2) return Pair{.next=0, .prev=0};
    var diffs = [_]i32{0} ** (size - 1);
    var all_zeroes = true;
    inline for (0..diffs.len, 1..) |i, j| {
        diffs[i] = items[j] - items[i];
        all_zeroes = all_zeroes and diffs[i] == 0;
    }
    if (all_zeroes) return Pair{.next=0, .prev=0};
    const pair = Pair{
        .next = diffs[diffs.len - 1],
        .prev = diffs[0],
    };
    return pair.add(completeSequence(diffs.len, &diffs));
}

fn completeSequenceVec(comptime size: comptime_int, items: @Vector(size, i32)) Pair {
    if (size <= 2) return Pair{.next=0, .prev=0};

    const items_arr: [size]i32 = items;
    const items_start: @Vector(size - 1, i32) = items_arr[0..size-1].*;
    const items_end: @Vector(size - 1, i32) = items_arr[1..size].*;
    const diffs = items_end - items_start;
    const all_zeroes = @reduce(.Or, diffs) == 0;

    if (all_zeroes) return Pair{.next=0, .prev=0};
    const pair = Pair{
        .next = diffs[size - 2],
        .prev = diffs[0],
    };
    return pair.add(completeSequence(size - 1, &diffs));
}


test "2023-9" {
    try aoc.testBoth(114, 2, run(
        \\0 3 6 9 12 15
        \\1 3 6 10 15 21
        \\10 13 16 21 30 45
    ));
}
