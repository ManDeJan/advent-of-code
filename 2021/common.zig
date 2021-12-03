pub const std = @import("std");
pub const mem = std.mem;
pub const Timer = std.time.Timer;

pub const Input = []const u8;
pub const Output = struct {
    part1: i64,
    part2: i64,
};

const ArrayList = std.ArrayList;

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
pub const gpa_allocator = &gpa.allocator;
pub const heap_allocator = std.heap.page_allocator;
var arena = std.heap.ArenaAllocator.init(heap_allocator);
pub const arena_allocator = &arena.allocator;

pub const allocator = arena_allocator;

pub fn tokenize(buffer: []const u8, delimiter_bytes: []const u8) @TypeOf(mem.tokenize(u8, " ", " ")) {
    return mem.tokenize(u8, buffer, delimiter_bytes);
}

pub fn split(buffer: []const u8, delimiter: []const u8) @TypeOf(mem.split(u8, " ", " ")) {
    return mem.split(u8, buffer, delimiter);
}

pub fn newVec(comptime typeOf: type) @TypeOf(ArrayList(typeOf).init(allocator)) {
    return std.ArrayList(typeOf).init(allocator);
}

pub fn print(comptime format: []const u8, args: anytype) void {
    const stdout = std.io.getStdOut().writer();
    stdout.print(format, args) catch unreachable;
}

pub fn inputAsInts(comptime T: type, input: Input, comptime radix: anytype) !ArrayList(T) {
    var lines = tokenize(input, "\n");
    var nums = newVec(T);
    while (lines.next()) |line| {
        try nums.append(try std.fmt.parseInt(T, line, radix));
    }
    return nums;
}

pub fn range(comptime size: comptime_int) [size]void {
    return [_]void{{}} ** size; // hide the jank B)
}
