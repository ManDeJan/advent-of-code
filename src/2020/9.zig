const std = @import("std");
const aoc = @import("common.zig");

pub fn run(input: aoc.Input) anyerror!aoc.Output {
    var part1: i64 = undefined;
    var part2: i64 = undefined;

    var lines = aoc.tokenize(input, "\n");
    const window_size = 25;
    var window = [_]u64{undefined} ** window_size;
    // fill window
    var nums = [_]u64{undefined} ** 1000; // preallocated
    for (&window, 0..) |*num, i| {
        num.* = try std.fmt.parseInt(u64, lines.next().?, 10);
        nums[i] = num.*;
    }

    var offset: usize = window_size;
    var new_num: u64 = undefined;
    while (lines.next()) |line| : (offset += 1) {
        @setEvalBranchQuota(5000);
        new_num = try std.fmt.parseInt(u64, line, 10);
        // print("{}, {}\n", .{window[0], new_num});
        // combinations
        comptime var i = 0;
        outer: inline while (i < window_size) : (i += 1) {
            comptime var j = i + 1;
            inline while (j < window_size) : (j += 1) {
                const sum = window[(i + offset) % window_size] + window[(j + offset) % window_size];
                if (new_num == sum) break :outer;
            }
        } else {
            part1 = @intCast(new_num);
            break;
        }
        window[offset % window_size] = new_num;
        nums[offset] = new_num;
    }

    var small: usize = 0;
    var big: usize = 1;
    var sum: usize = nums[small];

    while (big <= offset) : (big += 1) {
        while (sum > new_num and small < big - 1) : (small += 1) {
            sum -= nums[small];
        }
        if (sum == new_num) break;
        if (big < offset) sum += nums[big];
    }

    var min: usize = nums[small];
    var max: usize = nums[small];
    for (nums[small + 1 .. big]) |num| {
        min = if (num < min) num else min;
        max = if (num > max) num else max;
    }
    part2 = @intCast(min + max);
    return aoc.Output{ .part1 = part1, .part2 = part2 };
}
