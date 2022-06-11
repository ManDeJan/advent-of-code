const std = @import("std");
const aoc = @import("common.zig");

const Point = packed struct {
    x: i16,
    y: i16,

    pub fn move(self: *Point, dir: u8) void {
             if (dir == '^') { self.y += 1; }
        else if (dir == 'v') { self.y -= 1; }
        else if (dir == '<') { self.x -= 1; }
        else                 { self.x += 1; }
    }
};

pub fn run(input: aoc.Input) !aoc.Output {
    var part1: i64 = 1;
    var part2: i64 = 1;

    var santa_map = std.AutoHashMap(u32, void).init(aoc.allocator);
    var santa_pos = Point{.x = 0, .y = 0};
    try santa_map.put(@bitCast(u32, santa_pos), {});

    var santa_and_robot_map = std.AutoHashMap(u32, void).init(aoc.allocator);
    var santa2_pos = Point{.x = 0, .y = 0};
    var santaR_pos = Point{.x = 0, .y = 0};
    try santa_and_robot_map.put(@bitCast(u32, santa2_pos), {});

    for (input) | dir, i | {
        santa_pos.move(dir);
        var entry = try santa_map.getOrPut(@bitCast(u32, santa_pos));
        if (!entry.found_existing) part1 += 1;

        var santa_or_robot = &(if (i % 2 == 0) santa2_pos else santaR_pos);
        santa_or_robot.move(dir);
        var entry2 = try santa_and_robot_map.getOrPut(@bitCast(u32, santa_or_robot.*));
        if (!entry2.found_existing) part2 += 1;
    }
    return aoc.Output{.part1 = part1, .part2 = part2};
}

test "2015-03" {
    try aoc.testPart1(2, run(">"));
    try aoc.testPart2(3, run("^v"));
    try aoc.testBoth(4, 3, run("^>v<"));
    try aoc.testBoth(2, 11, run("^v^v^v^v^v"));
}
