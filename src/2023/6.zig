const std = @import("std");
const aoc = @import("common.zig");

pub fn run(input: aoc.Input) !aoc.Output {
    var lines =  aoc.tokenizeScalar(input, '\n');
    var timing_line = aoc.tokenizeScalar(lines.next().?["Distance:".len..], ' ');
    var distance_line = aoc.tokenizeScalar(lines.next().?["Distance:".len..], ' ');
    var timings = aoc.newVec(u64);
    var distances = aoc.newVec(u64);
    var kerned_time: u64 = 0;
    var kerned_distance: u64 = 0;
    while (timing_line.next()) |timing| {
        try timings.append(try aoc.parseInt(u64, timing));
        for (timing) |c| kerned_time = kerned_time * 10 + (c - '0');
    }
    while (distance_line.next()) |distance| {
        try distances.append(try aoc.parseInt(u64, distance));
        for (distance) |c| kerned_distance = kerned_distance * 10 + (c - '0');
    }

    var part1: i64 = 1;
    for (timings.items, distances.items) |time, distance|
        part1 *= @intCast(solve_quadratic2(time, distance));
    const part2: i64 = @intCast(solve_quadratic2(kerned_time, kerned_distance));


    return aoc.Output{ .part1 = part1, .part2 = part2 };
}

fn solve_quadratic2(time: u64, distance: u64) u64 {
    const t_f: f64 = @floatFromInt(time);
    const d_f: f64 = @floatFromInt(distance);
    const discriminant_root = std.math.sqrt(t_f * t_f - 4 * d_f);
    const diff = @ceil((t_f + discriminant_root) / 2 - 1) -
                 @floor((t_f - discriminant_root) / 2 + 1);
    const result = @as(u64, @intFromFloat(diff)) + 1;
    return result;
}


fn solve_quadratic(time: u64, distance: u64) u64 {
    const t_f: f64 = @floatFromInt(time);
    const d_f: f64 = @floatFromInt(distance);
    const discriminant_root = std.math.sqrt(t_f * t_f - 4 * d_f);
    const diff = fixFloor((t_f + discriminant_root) / 2) -
                 fixCeil((t_f - discriminant_root) / 2);
    const result = @as(u64, @intFromFloat(diff)) + 1;
    return result;
}

// We have to *beat* the time, not just tie it, so in case we land a tie we
// have to round up to the next integer.
fn fixFloor(x: f64) f64 {
    return if (x == @floor(x)) x - 1 else @floor(x);
}

fn fixCeil(x: f64) f64 {
    return if (x == @ceil(x)) x + 1 else @ceil(x);
}

test "2023.6" {
    try aoc.testBoth(288, 71503, run(
        \\Time:      7  15   30
        \\Distance:  9  40  200
    ));
}
