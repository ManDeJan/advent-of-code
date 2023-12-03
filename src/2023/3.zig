const std = @import("std");
const aoc = @import("common.zig");

pub fn run(input: aoc.Input) !aoc.Output {
    var part1: i64 = 0;
    var part2: i64 = 0;
    const length = std.mem.indexOfScalar(u8, input, '\n').?;

    var touching_symbol: bool = false;
    var touched_symbol: bool = false;
    var parsing_integer: bool = false;
    var index_of_integer: usize = 0;

    for (input, 0..) |c, i| {
        const is_digit = isDigit(c);

        if (c != '\n') {
            if (is_digit and !parsing_integer) {
                index_of_integer = i;
                parsing_integer = true;
            }

            touching_symbol =
                (!isDigitOrPeriod(c)) or // we're a symbol
                (i > length and !isDigitOrPeriod(input[i - length - 1])) or // above is a symbol
                (i < input.len - length - 1 and !isDigitOrPeriod(input[i + length + 1])); // below is a symbol

            touched_symbol = touching_symbol or (parsing_integer and touched_symbol);
        }

        if (parsing_integer and !is_digit) {
            if (touched_symbol) {
                part1 += try std.fmt.parseInt(u32, input[index_of_integer..i], 10);
            }
            parsing_integer = false;
            touched_symbol = touching_symbol;
        }

        if (c == '\n') {
            touched_symbol = false;
        }

        // part 2 🤢
        if (c == '*') { // this assumes gears can never be at the edge, which they don't appear to be in the input
            const top_left = input[i - length - 2];
            const top_cntr = input[i - length - 1];
            const top_rght = input[i - length - 0];
            const left = input[i - 1];
            const rght = input[i + 1];
            const bot_left = input[i + length + 0];
            const bot_cntr = input[i + length + 1];
            const bot_rght = input[i + length + 2];
            var digits_on_top = @as(u32, @intFromBool(isDigit(top_left))) +
                                @as(u32, @intFromBool(isDigit(top_cntr))) +
                                @as(u32, @intFromBool(isDigit(top_rght)));
            if (digits_on_top >= 2 and isDigit(top_cntr)) digits_on_top = 1;
            var digits_on_bot = @as(u32, @intFromBool(isDigit(bot_left))) +
                                @as(u32, @intFromBool(isDigit(bot_cntr))) +
                                @as(u32, @intFromBool(isDigit(bot_rght)));
            if (digits_on_bot >= 2 and isDigit(bot_cntr)) digits_on_bot = 1;
            if (digits_on_top + digits_on_bot + @intFromBool(isDigit(left)) + @intFromBool(isDigit(rght)) != 2) continue;
            const int_index_1 =
                if (isDigit(top_left)) i - length - 2 else
                if (isDigit(top_cntr)) i - length - 1 else
                if (isDigit(top_rght)) i - length - 0 else
                if (isDigit(left)) i - 1 else
                if (isDigit(rght)) i + 1 else
                if (isDigit(bot_left)) i + length + 0 else unreachable;
            const int_index_2 =
                if (isDigit(bot_rght)) i + length + 2 else
                if (isDigit(bot_cntr)) i + length + 1 else
                if (isDigit(bot_left)) i + length + 0 else
                if (isDigit(rght)) i + 1 else
                if (isDigit(left)) i - 1 else
                if (isDigit(top_rght)) i - length - 0 else unreachable;
            part2 += findIntFromIndex(input, int_index_1) *
                     findIntFromIndex(input, int_index_2);
        }
    }
    return aoc.Output{ .part1 = part1, .part2 = part2 };
}

fn findIntFromIndex(input: []const u8, index: usize) u32 {
    var i = index;
    while (isDigit(input[i - 1])) i -= 1;
    var j = index;
    while (isDigit(input[j])) j += 1;
    return std.fmt.parseInt(u32, input[i..j], 10) catch unreachable;
}

fn isDigit(char: u8) bool {
    return char >= '0' and char <= '9';
}

fn isDigitOrPeriod(char: u8) bool {
    return isDigit(char) or char == '.';
}

test "2023-3" {
    try aoc.testBoth(4361, 467835, run(
        \\467..114..
        \\...*......
        \\..35..633.
        \\......#...    
        \\617*......
        \\.....+.58.
        \\..592.....
        \\......755.
        \\...$.*....
        \\.664.598..
        \\
    ));
}
