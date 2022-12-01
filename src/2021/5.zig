const std = @import("std");
const aoc = @import("common.zig");

const Line = struct {
    x1: u16,
    y1: u16,
    x2: u16,
    y2: u16,
};

pub noinline fn run(input: aoc.Input) !aoc.Output {
    var part1: i64 = 0;
    var part2: i64 = 0;

    var input_lines = aoc.tokenize(input, "\n");
    var lines = aoc.newVec(Line);
    while (input_lines.next()) |line| {
        // aoc.print("{s}\n", .{line});
        var points = aoc.tokenize(line, ", ->");
        try lines.append(.{
            .x1 = try std.fmt.parseInt(u16, points.next().?, 10),
            .y1 = try std.fmt.parseInt(u16, points.next().?, 10),
            .x2 = try std.fmt.parseInt(u16, points.next().?, 10),
            .y2 = try std.fmt.parseInt(u16, points.next().?, 10),
        });
    }

    var field align(4096) = aoc.field(991, 991, @as(u8, 0));

    for (lines.items) |line| {
        if (line.x1 == line.x2) {
            var begin = if (line.y1 < line.y2) line.y1 else line.y2;
            const end = if (line.y1 < line.y2) line.y2 else line.y1;
            while (begin <= end) : (begin += 1) {
                field[begin][line.x1] += 1;
                if (field[begin][line.x1] == 2) part1 += 1;
            }
        } else if (line.y1 == line.y2) {
            var begin = if (line.x1 < line.x2) line.x1 else line.x2;
            const end = if (line.x1 < line.x2) line.x2 else line.x1;
            while (begin <= end) : (begin += 1) {
                field[line.y1][begin] += 1;
                if (field[line.y1][begin] == 2) part1 += 1;
            }
        } else {
            var begin_x = if (line.x1 < line.x2) line.x1 else line.x2;
            const end_x = if (line.x1 < line.x2) line.x2 else line.x1;
            var begin_y = if (line.x1 < line.x2) line.y1 else line.y2;
            const end_y = if (line.x1 < line.x2) line.y2 else line.y1;
            if (begin_y < end_y) {
                while (begin_x <= end_x) : ({begin_x += 1; begin_y += 1;}) {
                    field[begin_y][begin_x] += 1;
                    if (field[begin_y][begin_x] == 2) part2 += 1;
                }
            } else {
                while (begin_x <= end_x) : ({begin_x += 1; begin_y -= 1;}) {
                    field[begin_y][begin_x] += 1;
                    if (field[begin_y][begin_x] == 2) part2 += 1;
                }
            }
        }
    }
    part2 += part1;
    return aoc.Output{.part1 = part1, .part2 = part2};
}
