const std = @import("std");
const aoc = @import("common.zig");

pub fn run(input: aoc.Input) !aoc.Output {
    var part1: i64 = 0;

    var sections = aoc.split(input, "\n\n");
    const directions = sections.next().?;
    var network = sections.next().?;

    // TODO map instructions to line numbers
    var instructions align(1<<8) = [_]Instruction{undefined} ** (strToNode("ZZZ") + 1);
    // var instructions = std.AutoHashMap(Node, Instruction).init(aoc.allocator);
    // defer instructions.deinit();
    // try instructions.ensureTotalCapacity(1000);
    const length = "AAA = (BBB, CCC)\n".len;

    var a_nodes = aoc.newVec(Node);
    defer a_nodes.deinit();
    var i: usize = length;
    while (i <= network.len) : (i += length) {
        const instruction = network[i - length .. i - 1];
        const from = strToNode(instruction[0..3]);
        const left = strToNode(instruction[7..10]);
        const right = strToNode(instruction[12..15]);
        instructions[from] = .{.left = left, .right = right};
        // try instructions.put(from, .{.left = left, .right = right});
        if (instruction[2] == 'A') {
            try a_nodes.append(from);
            // aoc.print("{s}: {}, {}, {}\n", .{instruction, from, left, right});
        }
    }

    {
        var cur_node = strToNode("AAA");
        while (cur_node != strToNode("ZZZ")) : (part1 += 1) {
            const dir = directions[@as(usize, @intCast(part1)) % directions.len];
            cur_node = switch (dir) {
                'L' => instructions[cur_node].left,
                'R' => instructions[cur_node].right,
                // 'L' => instructions.get(cur_node).?.left,
                // 'R' => instructions.get(cur_node).?.right,
                else => unreachable
            };
        }
    }


    var part2: u64 = 1;
    for (a_nodes.items) |a_node| {
        var cur_node = a_node;
        var path_len: usize = 0;
        while (cur_node % 26 != 25) : (path_len += 1) {
            const dir = directions[@as(usize, @intCast(path_len)) % directions.len];
            cur_node = switch (dir) {
                'L' => instructions[cur_node].left,
                'R' => instructions[cur_node].right,
                // 'L' => instructions.get(cur_node).?.left,
                // 'R' => instructions.get(cur_node).?.right,
                else => unreachable
            };
        }
        part2 = lcm(part2, path_len);
    }

    return aoc.Output{ .part1 = part1, .part2 = @intCast(part2) };
}

const Node = u32;

const Instruction = packed struct {
    left: Node,
    right: Node,
};

fn strToNode(str: *const [3]u8) Node {
    return @as(u32, str[0] - 'A') * (26 * 26) +
           @as(u32, str[1] - 'A') * (26) +
           @as(u32, str[2] - 'A');
}

fn lcm(a: u64, b: u64) u64 {
    return a * b / std.math.gcd(a, b);
}

test "2023-8" {
    try aoc.testPart1(2, run(
        \\RL
        \\
        \\AAA = (BBB, CCC)
        \\BBB = (DDD, EEE)
        \\CCC = (ZZZ, GGG)
        \\DDD = (DDD, DDD)
        \\EEE = (EEE, EEE)
        \\GGG = (GGG, GGG)
        \\ZZZ = (ZZZ, ZZZ)
        \\
    ));
    try aoc.testPart1(6, run(
        \\LLR
        \\
        \\AAA = (BBB, BBB)
        \\BBB = (AAA, ZZZ)
        \\ZZZ = (ZZZ, ZZZ)
        \\
    ));
    // try aoc.testPart2(0, run(""));
}
