const std = @import("std");
const aoc = @import("common.zig");

const MemoryCell = struct {
    amt: i32,
    ins: u8,
};

const mem_size = 1000;
pub fn run(input: aoc.Input) anyerror!aoc.Output {
    var part1: i64 = undefined;
    var part2: i64 = undefined;

    var memory = [_]MemoryCell{undefined} ** mem_size;

    var lines = aoc.tokenize(input, "\n");
    var i: usize = 0;
    while (lines.next()) |line| : (i += 1) {
        memory[i].amt = try std.fmt.parseInt(i32, line[4..], 10);
        memory[i].ins = line[0];
    }
    memory[i].ins = 0;

    part1 = run_code(memory[0..]).acc;
    for (&memory) |*cell| {
        if (cell.ins == 'a') continue;
        cell.ins ^= 4; // flip j to n and vice versa
        const result = run_code(memory[0..]);
        if (result.term) {
            part2 = result.acc;
            break;
        }
        cell.ins ^= 4; // flip back
    }
    return aoc.Output{ .part1 = part1, .part2 = part2 };
}

fn run_code(memory: []MemoryCell) struct { acc: i64, term: bool } {
    var ins_ptr: usize = 0;
    var acc: i32 = 0;

    var dirty = [_]bool{false} ** mem_size;

    while (!dirty[ins_ptr]) {
        dirty[ins_ptr] = true;

        switch (memory[ins_ptr].ins) {
            'a' => {
                acc += memory[ins_ptr].amt;
            },
            'j' => {
                ins_ptr = @as(usize, @intCast(@as(i32, @intCast(ins_ptr)) + memory[ins_ptr].amt - 1));
            },
            else => {},
        }
        ins_ptr += 1;
        if (memory[ins_ptr].ins == 0) return .{ .term = true, .acc = acc };
    }
    return .{ .term = false, .acc = acc };
}
