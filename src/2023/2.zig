const std = @import("std");
const aoc = @import("common.zig");

pub fn run(input: aoc.Input) !aoc.Output {
    var part1: i64 = 0;
    var part2: i64 = 0;

    var games = aoc.splitLines(input);
    while (games.next()) |game| {
        var results = aoc.tokenizeAny(game["Game ".len..], " :;,");
        const game_num = try std.fmt.parseInt(u32, results.next().?, 10);
        var red: u32 = 0;
        var green: u32 = 0;
        var blue: u32 = 0;

        while (results.next()) |amount_str| {
            const amount = try std.fmt.parseInt(u32, amount_str, 10);
            switch (results.next().?[0]) {
                'r' => red = @max(amount, red),
                'g' => green = @max(amount, green),
                'b' => blue = @max(amount, blue),
                else => unreachable,
            }
        }
        if (red <= 12 and green <= 13 and blue <= 14) part1 += game_num;
        part2 += red * green * blue;
    }

    return aoc.Output{ .part1 = part1, .part2 = part2 };
}

test "2023-1" {
    try aoc.testPart1(8, run(
        \\Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        \\Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
        \\Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
        \\Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
        \\Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    ));
    try aoc.testPart2(2286, run(
        \\Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        \\Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
        \\Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
        \\Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
        \\Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    ));
}
