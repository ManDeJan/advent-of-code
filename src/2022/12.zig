const std = @import("std");
const aoc = @import("common.zig");

pub fn run(input: aoc.Input) !aoc.Output {
    var map: MapType align(8) = aoc.field(MapWidth, MapHeight, @as(u8, 0));

    var lines = aoc.split(input, "\n");
    {
        var i: usize = 0;
        while (lines.next()) |line| : (i += 1) {
            aoc.assert(line.len < MapWidth);
            @memcpy(map[i + 1][1 .. line.len + 1], line);
        }
    }

    var start: ?Point = null;
    var end: ?Point = null;
    outer: for (map, 0..) |row, y| for (row, 0..) |point, x| {
        if (point == 'S') start = Point{ .x = @truncate(x), .y = @truncate(y) };
        if (point == 'E') end = Point{ .x = @truncate(x), .y = @truncate(y) };
        if (start != null and end != null) break :outer;
    };
    map[start.?.y][start.?.x] = 'a';
    map[end.?.y][end.?.x] = 'z';

    return try breadth_first_search(&map, end.?, start.?);
}

const MapWidth = 161 + 2;
const MapHeight = 41 + 2;
const MapType = @TypeOf(aoc.field(MapWidth, MapHeight, @as(u8, 0)));

inline fn breadth_first_search(map: *const MapType, start: Point, end: Point) !aoc.Output {
    // var frontier = std.ArrayList(PointCost).init(aoc.allocator);
    // defer frontier.deinit();
    // try frontier.ensureTotalCapacity(1 << 13);

    var frontier: [64]PointCost align(8) = undefined;
    var came_from align(8) = aoc.field(MapWidth, MapHeight, false);

    frontier[0] = .{ .point = start, .cost = 0 };
    came_from[start.y][start.x] = true;

    var part1: i64 = 0;
    var part2: ?i64 = null;

    var read_idx: usize = 0;
    var write_idx: usize = 1;

    while (true) { // assume there is always a path in the input
        const current = frontier[read_idx % frontier.len];
        read_idx += 1;
        const current_point = current.point;
        const current_cost = current.cost;
        const our_value = map[current_point.y][current_point.x];

        if (our_value == 'a') {
            if (part2 == null) part2 = current_cost // assumes we always find part2 before part1
            else if (std.meta.eql(current_point, end)) {
                part1 = current_cost;
                break;
            }
        }

        for (get_neighbours(current_point)) |next| {
            const next_value = map[next.y][next.x];
            if (next_value < our_value and our_value - next_value > 1) continue;

            const new_cost = current_cost + 1;
            if (!came_from[next.y][next.x]) {
                came_from[next.y][next.x] = true;
                frontier[write_idx % frontier.len] = .{ .point = next, .cost = new_cost };
                write_idx += 1;
            }
        }
    }
    return .{ .part1 = part1, .part2 = part2.? };
}

inline fn get_neighbours(point: Point) [4]Point {
    return [4]Point{
        .{ .x = point.x - 1, .y = point.y },
        .{ .x = point.x + 1, .y = point.y },
        .{ .x = point.x, .y = point.y - 1 },
        .{ .x = point.x, .y = point.y + 1 },
    };
}

const Point = packed struct {
    x: u8 = 0,
    y: u8 = 0,
};

const Cost = u16;

const PointCost = packed struct {
    cost: Cost,
    point: Point,
};

test "2022-12" {
    try aoc.testBoth(31, 29, run(
        \\Sabqponm
        \\abcryxxl
        \\accszExk
        \\acctuvwj
        \\abdefghi
        \\
    ));
}
