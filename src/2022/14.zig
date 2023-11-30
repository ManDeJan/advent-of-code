const std = @import("std");
const aoc = @import("common.zig");

pub fn run(input: aoc.Input) !aoc.Output {
    var part1: i64 = 0;
    var part2: i64 = 0;

    var lines = aoc.tokenize(input, "\n");
    var paths = aoc.newVec(Path);
    defer paths.deinit();

    var min_x: u16 = std.math.maxInt(u16);
    var max_x: u16 = 0;
    var max_y: u16 = 0;

    while (lines.next()) |path| {
        var point_lines = aoc.split(path, " -> ");
        var last_point = try Point.initSlice(point_lines.next().?);
        updateBounds(&min_x, &max_x, &max_y, last_point);
        while (point_lines.next()) |point_line| {
            var new_point = try Point.initSlice(point_line);
            updateBounds(&min_x, &max_x, &max_y, new_point);
            try paths.append(.{ .begin = last_point, .end = new_point });
            last_point = new_point;
        }
    }

    // for (paths.items) |path| aoc.print("Path: {}\n", .{path});
    aoc.print("Bounds: Min X: {}, Max X: {}, Max Y: {}\n", .{ min_x, max_x, max_y });

    var cave = try Cave.init(paths, min_x, max_x, max_y);
    cave.print();
    // aoc.print("Cave:\n{any}\n", .{cave.cave.items});

    return aoc.Output{ .part1 = part1, .part2 = part2 };
}

inline fn updateBounds(min_x: *u16, max_x: *u16, max_y: *u16, point: Point) void {
    if (point.x < min_x.*) min_x.* = point.x;
    if (point.x > max_x.*) max_x.* = point.x;
    if (point.y > max_y.*) max_y.* = point.y;
}

const Point = packed struct {
    x: u16 = 0,
    y: u16 = 0,

    fn initSlice(line: []const u8) !Point {
        var coords = aoc.split(line, ",");
        return .{
            .x = try std.fmt.parseUnsigned(u16, coords.next().?, 10),
            .y = try std.fmt.parseUnsigned(u16, coords.next().?, 10),
        };
    }
};

const Path = packed struct {
    begin: Point,
    end: Point,
};

const CaveTile = enum { air, sand, stone };

const Cave = struct {
    cave: std.ArrayList(CaveTile),
    offset_x: u16,
    width: u16,
    depth: u16,
    sand: usize,

    pub fn init(paths: std.ArrayList(Path), min_x: u16, max_x: u16, max_y: u16) !Cave {
        var self = Cave{
            .cave = std.ArrayList(CaveTile).init(aoc.allocator),
            .offset_x = min_x - 1,
            .width = max_x - min_x + 3, // + 3 cause we want padding on both sides and the range is inclusive
            .depth = max_y + 1,
            .sand = 0,
        };
        const cave_size = self.width * self.depth;
        aoc.print("Width: {}, Depth: {}, Offset: {}\n", .{ self.width, self.depth, self.offset_x });
        try self.cave.ensureTotalCapacity(cave_size);
        self.cave.appendNTimesAssumeCapacity(.air, cave_size);
        for (paths.items) |path| {
            // self.print();
            // aoc.print("Path: {}\n", .{path});
            self.addPath(path);
        }
        return self;
    }

    pub fn deinit(self: Cave) void {
        self.cave.deinit();
    }

    pub fn addPath(self: Cave, path: Path) void {
        aoc.assert(path.begin.x == path.end.x or path.begin.y == path.end.y);
        if (path.begin.x == path.end.x) {
            const begin = std.math.min(path.begin.y, path.end.y);
            const end = std.math.max(path.begin.y, path.end.y);
            var y: u16 = begin;
            while (y <= end) : (y += 1) self.at(.{ .x = path.begin.x, .y = y }).* = .stone;
        } else {
            const begin = std.math.min(path.begin.x, path.end.x);
            const end = std.math.max(path.begin.x, path.end.x);
            // aoc.print("Begin: {} End: {}\n", .{ begin, end });
            var x: u16 = begin;
            while (x <= end) : (x += 1) self.at(.{ .x = x, .y = path.begin.y }).* = .stone;
        }
    }

    pub fn at(self: Cave, point: Point) *CaveTile {
        // aoc.print("Print point: {}, {}\n", .{ point.x, point.y });
        return &self.cave.items[
            @as(usize, point.y) * self.width + (point.x - self.offset_x)
        ];
    }

    pub fn print(self: Cave) void {
        var y: usize = 0;
        while (y < self.depth) : (y += 1) {
            var x: usize = 0;
            while (x < self.width) : (x += 1) {
                aoc.print("{s}", .{switch (self.cave.items[y * self.width + x]) {
                    .air => "  ",
                    .sand => "░░", // ∴
                    .stone => "██",
                }});
            }
            aoc.print("\n", .{});
        }
        aoc.print("\n", .{});
    }

    pub fn addSand(self: *Cave) bool {
        var start = Point{ .x = 500, .y = 0 };
        while (true) {
            const down = .{ .x = start.x, .y = start + 1 };
            const left = .{ .x = start.x - 1, .y = start + 1 };
            const right = .{ .x = start.x + 1, .y = start + 1 };

            if (self.at(down) == .air) {
                start = down;
            } else if (self.at(left) == air) {
                start = left;
            } else if (self.at(right) == air) {
                start = right;
            }
        }
        self.sand += 1;
        return true;
    }
};

test "2022-14" {
    try aoc.testPart1(0, run(""));
    try aoc.testPart2(0, run(""));
}
