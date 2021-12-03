const std = @import("std");
const aoc = @import("common.zig");

pub noinline fn run(input: aoc.Input) !aoc.Output {
    var part1: i64 = 0;
    var part2: i64 = 0;

    // var timer = try aoc.Timer.start(); // DEBUG
    // var time: u64 = 0; // DEBUG
    // var init_time: u64 = 0; // DEBUG
    // var part1_time: u64 = 0; // DEBUG
    // var part2_time: u64 = 0; // DEBUG

    // time = timer.lap(); // DEBUG

    var nums = try aoc.inputAsInts(u12, input, 2);
    defer nums.deinit();

    // time = timer.lap(); // DEBUG
    // init_time = time; // DEBUG
    // time = timer.lap(); // DEBUG

    var bit_counts = [_]u32{0} ** 12;
    for (nums.items) |num| {
        for (bit_counts) |*bit_count, i| {
            bit_count.* += @boolToInt(num & @as(u12, 1) << @intCast(u4, i) != 0);
        }
    }

    var gamma_rate: u12 = 0;
    for (bit_counts) |bit_count, i| {
        gamma_rate |= @as(u12, @boolToInt(bit_count > nums.items.len / 2)) << @intCast(u4, i);
    }
    part1 = @as(u32, gamma_rate) * ~gamma_rate;

    // time = timer.lap(); // DEBUG
    // part1_time = time; // DEBUG
    // time = timer.lap(); // DEBUG

    const oxygen_rating = try filter_nums(nums.items, false);
    const co2_rating    = try filter_nums(nums.items, true);

    part2 = @as(u32, oxygen_rating) * co2_rating;

    // time = timer.lap(); // DEBUG
    // part2_time = time; // DEBUG
    // aoc.print("Init:  {d:7} μs\nPart1: {d:7} μs\nPart2: {d:7} μs\n", .{init_time/1000, part1_time/1000, part2_time/1000}); // DEBUG

    return aoc.Output{.part1 = part1, .part2 = part2};
}

inline fn filter_nums(nums: []u12, comptime inv: bool) !u12 {
    var set = try aoc.allocator.alloc(bool, 1024);
    defer aoc.allocator.free(set);
    std.mem.set(bool, set, false); // this 

    var filtered_out: u32 = 0;

    for (aoc.range(12)) |_, i| {
        var bit_counts = [_]u32{0} ** 12;
        for (nums) |num, j| {
            if (set[j]) continue;
            bit_counts[i] += @boolToInt(num & @as(u12, 1) << @intCast(u4, 12 - (i + 1)) != 0);
        }

        const majority = (nums.len - filtered_out) / 2 +
                         (nums.len - filtered_out) % 2;

        for (nums) |num, j| {
            if (set[j]) continue;
            if (inv != ((bit_counts[i] >= majority) != (num & @as(u12, 1) << @intCast(u4, 12 - (i + 1)) != 0))) {
                set[j] = true;
                filtered_out += 1;
            }
        }

        if (filtered_out == nums.len - 1) break;
    }

    const rating = blk: {
        for (set) |value, i| {
            if (!value) break :blk nums[i];
        }
        unreachable;
    };
    return rating;
}
