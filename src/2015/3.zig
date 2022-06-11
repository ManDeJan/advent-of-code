const std = @import("std");
const aoc = @import("common.zig");

pub fn run(input: aoc.Input) !aoc.Output {
    var part1: i64 = 0;
    var part2: i64 = 0;

    const Point = packed struct {x: i16, y: i16};
    var map = std.AutoHashMap(u32, u32).init(aoc.allocator);
    var cur_point = Point{.x = 0, .y = 0};
    try map.put(@bitCast(u32, cur_point), 1);

    for (input) | dir | {
             if (dir == '^') { cur_point.y += 1; }
        else if (dir == 'v') { cur_point.y -= 1; }
        else if (dir == '<') { cur_point.x -= 1; }
        else                 { cur_point.x += 1; }

        var entry = try map.getOrPutValue(@bitCast(u32, cur_point), 1);
        if (entry.value_ptr.* == 1) part1 += 1
        else entry.value_ptr.* += 1;

    }
    return aoc.Output{.part1 = part1, .part2 = part2};
}
