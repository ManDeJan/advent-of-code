const std = @import("std");
const aoc = @import("common.zig");

pub fn run(input: aoc.Input) !aoc.Output {
    var part1: i64 = undefined;
    var part2: i64 = undefined;

    var rope = [_]Point{.{}} ** 10;

    var uniques1 = std.AutoArrayHashMap(Point, void).init(aoc.allocator);
    var uniques2 = std.AutoArrayHashMap(Point, void).init(aoc.allocator);
    defer uniques1.deinit();
    defer uniques2.deinit();

    try uniques1.ensureTotalCapacity(10000);
    try uniques2.ensureTotalCapacity(10000);

    var movements = aoc.tokenizeScalar(input, '\n');
    while (movements.next()) |movement| {
        const dir = directionToVector(movement[0]);
        const amount = try std.fmt.parseInt(u8, movement[2..], 10);

        {
            var i: usize = 0;
            while (i < amount) : (i += 1) {
                rope[0] = rope[0].add(dir);
                inline for (0..(rope.len - 1)) |j| {
                    const delta = rope[j].sub(rope[j + 1]);
                    if (@abs(delta.x) > 1 or @abs(delta.y) > 1) {
                        rope[j + 1] = rope[j + 1].add(Point{ .x = std.math.sign(delta.x), .y = std.math.sign(delta.y) });
                    }
                }
                uniques1.putAssumeCapacity(rope[1], {});
                uniques2.putAssumeCapacity(rope[9], {});
            }
        }
    }

    part1 = @intCast(uniques1.count());
    part2 = @intCast(uniques2.count());

    return aoc.Output{ .part1 = part1, .part2 = part2 };
}

fn directionToVector(dir: u8) Point {
    return switch (dir) {
        'R' => .{ .x = 1, .y = 0 },
        'L' => .{ .x = -1, .y = 0 },
        'U' => .{ .x = 0, .y = 1 },
        'D' => .{ .x = 0, .y = -1 },
        else => unreachable,
    };
}

const Point = struct {
    x: i16 = 0,
    y: i16 = 0,

    pub inline fn add(self: Point, other: Point) Point {
        return .{
            .x = self.x + other.x,
            .y = self.y + other.y,
        };
    }

    pub inline fn sub(self: Point, other: Point) Point {
        return .{
            .x = self.x - other.x,
            .y = self.y - other.y,
        };
    }
};

test "2022-9" {
    try aoc.testBoth(13, 1, run(
        \\R 4
        \\U 4
        \\L 3
        \\D 1
        \\R 4
        \\D 1
        \\L 5
        \\R 2
        \\
    ));

    try aoc.testPart2(36, run(
        \\R 5
        \\U 8
        \\L 8
        \\D 3
        \\R 17
        \\D 10
        \\L 25
        \\U 20
        \\
    ));
}
