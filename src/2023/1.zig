const std = @import("std");
const aoc = @import("common.zig");

pub fn run(input: aoc.Input) !aoc.Output {
    var part1: i64 = 0;
    var part2: i64 = 0;

    var calibration_codes = aoc.splitLines(input);

    const digit_strings = .{ "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" };

    while (calibration_codes.next()) |code| {
        var first_digit_1: u32 = 0;
        var first_digit_2: u32 = 0;
        var last_digit_1: u32 = 0;
        var last_digit_2: u32 = 0;

        for (code, 0..) |_, i| {
            if (code[i] >= '1' and code[i] <= '9') {
                const digit = code[i] - '0';
                if (first_digit_1 == 0) first_digit_1 = digit;
                if (first_digit_2 == 0) first_digit_2 = digit;
                last_digit_1 = digit;
                last_digit_2 = digit;
            } else {
                inline for (digit_strings, 1..) |digit_string, digit| {
                    if (std.mem.startsWith(u8, code[i..], digit_string)) {
                        if (first_digit_2 == 0) first_digit_2 = digit;
                        last_digit_2 = digit;
                    }
                }
            }
        }

        part1 += first_digit_1 * 10 + last_digit_1;
        part2 += first_digit_2 * 10 + last_digit_2;
    }

    return aoc.Output{ .part1 = part1, .part2 = part2 };
}

test "2023-1" {
    try aoc.testPart1(142, run(
        \\1abc2
        \\pqr3stu8vwx
        \\a1b2c3d4e5f
        \\treb7uchet
        \\
    ));
    try aoc.testPart2(281, run(
        \\two1nine
        \\eightwothree
        \\abcone2threexyz
        \\xtwone3four
        \\4nineeightseven2
        \\zoneight234
        \\7pqrstsixteen
        \\
    ));
}
