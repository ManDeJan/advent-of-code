usingnamespace @import("common.zig");

pub fn run(input: Input) anyerror!Output {
    // var timer = try Timer.start();
    // var time: u64 = 0;

    var expenses = newVec(u32);
    try expenses.ensureCapacity(200);
    defer expenses.deinit();

    var lines = mem.tokenize(input, "\n");
    while (lines.next()) |line| {
        try expenses.append(try std.fmt.parseInt(u32, line, 10));
    }
    
    // time = timer.lap();
    // try print(">>> Time: {} ns\n", .{time});
    // time = timer.lap();

    var part1: i64 = undefined;
    outer: for (expenses.items) |exp1| {
        const target = 2020 - exp1;
        for (expenses.items) |exp2| {
            if (exp2 == target) {
                part1 = exp1 * exp2;
                break :outer;
            }
        }
    }

    // time = timer.lap();
    // try print(">>> Time: {} ns\n", .{time});
    // time = timer.lap();

    var part2: i64 = undefined;
    outer: for (expenses.items) |exp1| {
        const target1 = 2020 - exp1;
        middle: for (expenses.items) |exp2| {
            if (target1 + exp2 >= 2020) {
                continue :middle;
            }
            const target2 = target1 - exp2;
            for (expenses.items) |exp3| {
                if (exp3 == target2) {
                    part2 = exp1 * exp2 * exp3;
                    break :outer;
                }
            }
        }
    }

    // time = timer.lap();
    // try print(">>> Time: {} ns\n", .{time});

    return Output{.part1 = part1, .part2 = part2};
}
