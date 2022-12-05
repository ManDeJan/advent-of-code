pub const std = @import("std");
pub const mem = std.mem;
pub const Timer = std.time.Timer;

pub const Input = []const u8;
pub const Output = struct {
    part1: i64,
    part2: i64,
};

pub const SolutionFnType = union(enum) {
    outputAsInt: *const fn(Input) anyerror!Output,
    outputAsText: *const fn(Input, []u8, []u8) anyerror!void,
};

const ArrayList = std.ArrayList;

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
pub const gpa_allocator = &gpa.allocator;
pub const heap_allocator = std.heap.page_allocator;
var arena = std.heap.ArenaAllocator.init(heap_allocator);
pub const arena_allocator = arena.allocator();

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

pub fn printToString(comptime format: []const u8, args: anytype) []const u8 {
    return std.fmt.allocPrint(allocator, format, args) catch unreachable;
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

pub fn field(comptime dim_x: comptime_int, comptime dim_y: comptime_int, init: anytype) @TypeOf([_][dim_x]@TypeOf(init){[_]@TypeOf(init){init} ** dim_x} ** dim_y) {
    return [_][dim_x]@TypeOf(init){[_]@TypeOf(init){init} ** dim_x} ** dim_y;
}

pub fn testPart1(part1: i64, output: anyerror!Output) !void {
    try std.testing.expectEqual(part1, (try output).part1);
}

pub fn testPart2(part2: i64, output: anyerror!Output) !void {
    try std.testing.expectEqual(part2, (try output).part2);
}

pub fn testBoth(part1: i64, part2: i64, output: anyerror!Output) !void {
    try testPart1(part1, output);
    try testPart2(part2, output);
}

pub fn testBothText(part1: []const u8, part2: []const u8, solution: anytype, input: []const u8) !void {
    var result_text_1 = std.mem.zeroes([15:0]u8);
    var result_text_2 = std.mem.zeroes([15:0]u8);
    try solution(input, &result_text_1, &result_text_2);
    try std.testing.expectEqualBytes(part1, result_text_1[0..std.mem.indexOfScalar(u8, &result_text_1, 0) orelse result_text_1.len]);
    try std.testing.expectEqualBytes(part2, result_text_2[0..std.mem.indexOfScalar(u8, &result_text_2, 0) orelse result_text_2.len]);
}

pub const testEqual = std.testing.expectEqual;
