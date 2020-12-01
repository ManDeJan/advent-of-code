usingnamespace @import("common.zig");

pub fn run(input: Input) anyerror!Output {
    var expenses = newVec(u16);
    defer expenses.deinit();

    var lines = mem.tokenize(input, "\n");
    while (lines.next()) |line| {
        try expenses.append(try std.fmt.parseInt(u16, line, 10));
    }
    
    var part1: i64 = undefined;
    outer: for (expenses.items) |exp1| { for (expenses.items) |exp2| {
        if (exp1 + exp2 == 2020) {
            part1 = @as(i64, exp1) * @as(i64, exp2);
            break :outer;
        }
    }}

    var part2: i64 = undefined;
    outer: for (expenses.items) |exp1| { for (expenses.items) |exp2| { for (expenses.items) |exp3| {
        if (exp1 + exp2 + exp3 == 2020) {
            part2 = @as(i64, exp1) * @as(i64, exp2) * @as(i64, exp3);
            break :outer;
        }
    }}}

    return Output{.part1 = part1, .part2 = part2};
}
