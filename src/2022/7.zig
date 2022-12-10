const std = @import("std");
const aoc = @import("common.zig");

pub fn run(input: aoc.Input) !aoc.Output {
    var part1: i64 = 0;
    var part2: i64 = std.math.maxInt(i64);

    var commands = aoc.tokenize(input, "\n");
    var sizes = aoc.newVec(u32);
    try sizes.ensureTotalCapacity(input.len / 12);
    defer sizes.deinit();

    const total_size = try calc_sizes(&commands, &sizes, &part1, 0);

    for (sizes.items) |size| {
        if (total_size - size < 40000000 and size < part2) part2 = size;
    }
    return aoc.Output{ .part1 = part1, .part2 = part2 };
}

fn calc_sizes(commands: *@TypeOf(aoc.tokenize(" ", " ")), sizes: *std.ArrayList(u32), part1: *i64, depth: usize) !u32 {
    while (true) {
        const command = commands.next() orelse "$ cd ..";
        if (command[2] == 'l' or command[2] == 'r') {
            continue;
        } else if (command[2] == 'c' and command[5] == '.') {
            part1.* += if (sizes.items[depth] < 100000) sizes.items[depth] else 0;
            return sizes.items[depth];
        } else if (command[2] == 'c') {
            sizes.appendAssumeCapacity(0);
            sizes.items[depth] += try calc_sizes(
                commands,
                sizes,
                part1,
                sizes.items.len - 1,
            );
        } else {
            sizes.items[depth] += try std.fmt.parseUnsigned(u32, command[0..std.mem.indexOf(u8, command, " ").?], 10);
        }
    }
}

test "2022-7" {}
