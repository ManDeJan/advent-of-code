pub const std = @import("std");
pub const mem = std.mem;
pub const split = mem.split;
pub const tokenize = mem.tokenize;
const ArrayList = std.ArrayList;

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
pub const allocator = &gpa.allocator;
// pub const allocator = std.heap.page_allocator;

pub fn newVec(comptime typeOf: type) @TypeOf(ArrayList(typeOf).init(allocator)) {
    return ArrayList(typeOf).init(allocator);
}

pub fn print(comptime format: []const u8, args: anytype) void {
    const stdout = std.io.getStdOut().writer();
    stdout.print(format, args) catch unreachable;
}

pub const Timer = std.time.Timer;

pub const Input = []u8;
pub const Output = struct {
    part1: i64,
    part2: i64,
};
