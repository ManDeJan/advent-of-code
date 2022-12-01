const std = @import("std");
const aoc = @import("common.zig");

pub fn run(input: aoc.Input) !aoc.Output {
    var part1: i64 = undefined;
    var part2: i64 = undefined;

    var elf_segments = aoc.split(input, "\n\n");
    var max_calories: u32 = 0;
    var elf_index: u32 = undefined;

    {var i: u32 = 1; while (elf_segments.next()) |elf_segment| : (i += 1) {
        var calorie_lines = aoc.tokenize(elf_segment, "\n");
        var total_calories: u32 = 0;

        while (calorie_lines.next()) |calorie_line| {
            total_calories += try std.fmt.parseInt(u32, calorie_line, 10);
        }

        // aoc.print("Elf: {d:3}, Cals: {d:5}\n", .{i, total_calories});

        if (max_calories < total_calories) {
            max_calories = total_calories;
            elf_index = i;
        }
    }}

    part1 = max_calories;
    part2 = 0;
    return aoc.Output{ .part1 = part1, .part2 = part2 };
}

test "2022-1" {
    try aoc.testPart1(4, run(
        \\1000
        \\2000
        \\3000
        \\
        \\4000
        \\
        \\5000
        \\6000
        \\
        \\7000
        \\8000
        \\9000
        \\
        \\10000
    ));
    try aoc.testPart2(0, run(""));
}
