pub const std = @import("std");
pub const mem = std.mem;
pub const split = mem.split;
pub const tokenize = mem.tokenize;
const ArrayList = std.ArrayList;

// pub const allocator = std.debug.global_allocator;
pub const allocator = std.heap.page_allocator;

pub fn newVec(comptime typeOf: type) @TypeOf(ArrayList(typeOf).init(allocator)) {
    return ArrayList(typeOf).init(allocator);
}

pub const stdin = &std.io.getStdIn().inStream();
pub const stdout = &std.io.getStdOut().outStream();
pub const print = stdout.print;
// pub const write = stdout.write;
pub const Timer = std.time.Timer;

pub const Input = []u8;
pub const Output = struct {
    part1: i64,
    part2: i64,
};
