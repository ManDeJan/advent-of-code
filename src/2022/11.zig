const std = @import("std");
const aoc = @import("common.zig");

pub fn run(input: aoc.Input) !aoc.Output {
    var part1: i64 = 0;
    var part2: i64 = 0;

    var monkey_lines = aoc.split(input, "\n\n");
    var monkeys1 = aoc.newVec(Monkey);
    var monkeys2 = aoc.newVec(Monkey);
    defer monkeys1.deinit();
    defer monkeys2.deinit();

    while (monkey_lines.next()) |monkey_line| {
        try monkeys1.append(try Monkey.init(monkey_line));
        try monkeys2.append(try Monkey.init(monkey_line));
    }
    defer for (monkeys1.items) |monkey| monkey.deinit();
    defer for (monkeys2.items) |monkey| monkey.deinit();

    const total_items = blk: {
        var total_items: usize = 0;
        for (monkeys1.items) |monkey| total_items += monkey.items.items.len;
        break :blk total_items;
    };
    for (monkeys1.items) |*monkey| try monkey.items.ensureTotalCapacity(total_items);
    for (monkeys2.items) |*monkey| try monkey.items.ensureTotalCapacity(total_items);

    const common_divsor = calculate_common_divisor(&monkeys1);

    manage_monkeys(20, true, common_divsor, &monkeys1);
    manage_monkeys(10000, false, common_divsor, &monkeys2);
    part1 = calculate_monkey_business(&monkeys1);
    part2 = calculate_monkey_business(&monkeys2);

    return aoc.Output{ .part1 = part1, .part2 = part2 };
}

fn manage_monkeys(comptime rounds: comptime_int, comptime keep_calm: bool, common_divsor: usize, monkeys: *std.ArrayList(Monkey)) void {
    for (aoc.range(rounds)) |_| {
        for (monkeys.items) |*monkey| {
            monkey.inspected += monkey.items.items.len;
            for (monkey.items.items) |*item| {
                switch (monkey.operation) {
                    .mul => |amt| item.* *= amt,
                    .add => |amt| item.* += amt,
                    .sqr => item.* *= item.*,
                }
                if (keep_calm) { item.* /= 3; }
                else           { item.* %= common_divsor; }
                const throw_to = if (item.* % monkey.test_div == 0) monkey.if_true else monkey.if_false;
                monkeys.items[throw_to].items.appendAssumeCapacity(item.*);
            }
            monkey.items.clearRetainingCapacity();
        }
    }
}

fn calculate_monkey_business(monkeys: *std.ArrayList(Monkey)) i64 {
    var active1: usize = 0;
    var active2: usize = 0;
    for (monkeys.items) |monkey| {
        if (monkey.inspected > active1) {
            active2 = active1;
            active1 = monkey.inspected;
        } else if (monkey.inspected > active2) {
            active2 = monkey.inspected;
        }
    }
    return @intCast(i64, active1 * active2);
}

fn calculate_common_divisor(monkeys: *std.ArrayList(Monkey)) usize {
    var a_common_divsor: usize = 1;
    for (monkeys.items) |monkey| a_common_divsor *= monkey.test_div;
    return a_common_divsor;
}

const Operation = union(enum) {
    mul: u8,
    add: u8,
    sqr: bool,
};

const Monkey = struct {
    inspected: usize,
    items: std.ArrayList(u64),
    operation: Operation,
    test_div: u8,
    if_true: u8,
    if_false: u8,

    pub fn init(lines: []const u8) !Monkey {
        var monkey_cfg = aoc.tokenize(lines, "\n");
        _ = monkey_cfg.next(); // throw away monkey name
        const item_line  = monkey_cfg.next().?["  Starting items: ".len..];
        const oper_line  = monkey_cfg.next().?["  Operation: new = old ".len..];
        const test_line  = monkey_cfg.next().?["  Test: divisible by ".len..];
        const true_line  = monkey_cfg.next().?["    If true: throw to monkey ".len..];
        const false_line = monkey_cfg.next().?["    If false: throw to monkey ".len..];

        return Monkey{
            .inspected = 0,
            .items = blk: {
                var items = aoc.newVec(u64);
                var item_lines = aoc.tokenize(item_line, ", ");
                while (item_lines.next()) |item| try items.append(try std.fmt.parseUnsigned(u8, item, 10));
                break :blk items;
            },
            .operation = switch (oper_line[0]) {
                '+' => .{ .add = try std.fmt.parseUnsigned(u8, oper_line[2..], 10) },
                '*' => switch (oper_line[2]) {
                    'o' => .{ .sqr = true },
                    else => .{ .mul = try std.fmt.parseUnsigned(u8, oper_line[2..], 10) },
                },
                else => unreachable,
            },
            .test_div = try std.fmt.parseUnsigned(u8, test_line, 10),
            .if_true = try std.fmt.parseUnsigned(u8, true_line, 10),
            .if_false = try std.fmt.parseUnsigned(u8, false_line, 10),
        };
    }

    pub fn deinit(self: Monkey) void {
        self.items.deinit();
    }
};

test "2022-11" {
    try aoc.testPart1(0, run(""));
    try aoc.testPart2(0, run(""));
}
