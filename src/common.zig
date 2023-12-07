pub const std = @import("std");
pub const mem = std.mem;
pub const Timer = std.time.Timer;

pub const Input = []const u8;
pub const OutputPart1 = i64;
pub const OutputPart2 = i64;
pub const Output = struct {
    part1: OutputPart1,
    part2: OutputPart2,
};

pub const SolutionFnType = union(enum) {
    outputAsInt: *const fn (Input) anyerror!Output,
    outputAsText: *const fn (Input, []u8, []u8) anyerror!void,
    outputAsIntText: *const fn (Input, []u8) anyerror!OutputPart2,
};

const ArrayList = std.ArrayList;

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
pub const gpa_allocator = &gpa.allocator;
pub const heap_allocator = std.heap.page_allocator;
var arena = std.heap.ArenaAllocator.init(heap_allocator);
pub const arena_allocator = arena.allocator();

pub const allocator = arena_allocator;

pub const native = @import("builtin").cpu.arch.endian();

pub fn tokenize(buffer: []const u8, delimiter_bytes: []const u8) @TypeOf(mem.tokenize(u8, " ", " ")) {
    return mem.tokenize(u8, buffer, delimiter_bytes);
}

pub fn tokenizeAny(buffer: []const u8, delimiter_bytes: []const u8) @TypeOf(mem.tokenizeAny(u8, " ", " ")) {
    return mem.tokenizeAny(u8, buffer, delimiter_bytes);
}

pub fn tokenizeScalar(buffer: []const u8, delimiter: u8) @TypeOf(mem.tokenizeScalar(u8, " ", ' ')) {
    return mem.tokenizeScalar(u8, buffer, delimiter);
}

pub fn splitLines(buffer: []const u8) @TypeOf(mem.tokenizeScalar(u8, " ", '\n')) {
    return mem.tokenizeScalar(u8, buffer, '\n');
}

pub fn split(buffer: []const u8, delimiter: []const u8) @TypeOf(mem.split(u8, " ", " ")) {
    return mem.splitSequence(u8, buffer, delimiter);
}

pub fn newVec(comptime typeOf: type) @TypeOf(ArrayList(typeOf).init(allocator)) {
    return std.ArrayList(typeOf).init(allocator);
}

pub fn newVecCap(comptime typeOf: type, comptime capacity: usize) !@TypeOf(ArrayList(typeOf).init(allocator)) {
    var vec = std.ArrayList(typeOf).init(allocator);
    try vec.ensureTotalCapacity(capacity);
    return vec;
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

pub fn parseInt(comptime T: type, input: []const u8) !T {
    return std.fmt.parseInt(T, input, 10);
}

// pub fn range(comptime size: comptime_int) [size]void {
//     return [_]void{{}} ** size; // hide the jank B)
// }

pub const assert = std.debug.assert;

pub fn field(
    comptime dim_x: comptime_int,
    comptime dim_y: comptime_int,
    init: anytype,
) @TypeOf([_][dim_x]@TypeOf(init){[_]@TypeOf(init){init} ** dim_x} ** dim_y) {
    return [_][dim_x]@TypeOf(init){[_]@TypeOf(init){init} ** dim_x} ** dim_y;
}

// Trust me bro
pub fn ocr_6x5_once(comptime fill: u8, comptime none: u8, rows: [6][]const u8) u8 {
    const bits: [6]u8 = .{ rows[0][0], rows[0][3], rows[2][1], rows[2][3], rows[5][1], rows[5][3] };
    for (bits) |bit| assert(bit == fill or bit == none);
    if (bits[0] == fill) {
        if (bits[1] == fill) {
            if (bits[2] == fill) {
                if (bits[3] == fill) return 'H';
                if (bits[4] == fill) return 'E';
                if (bits[5] == fill) return 'K';
                return 'F';
            }
            if (bits[3] == fill) return 'U';
            return 'Z';
        }
        if (bits[2] == fill) {
            if (bits[3] == fill) return 'Y';
            return 'B';
        }
        if (bits[3] == fill) {
            if (bits[5] == fill) return 'R';
            return 'P';
        }
        return 'L';
    }
    if (bits[1] == fill) {
        if (bits[3] == fill) return 'J';
        if (bits[5] == fill) return 'I';
        return 'S';
    }
    if (bits[3] == fill) {
        if (bits[4] == fill) return 'O';
        return 'A';
    }
    if (bits[5] == fill) return 'G';
    return 'C';
}

pub fn ocr_6x5_once_alt(comptime fill: u8, comptime none: u8, rows: [6][]const u8) u8 {
    const bits: [6]u8 = .{ rows[5][3], rows[0][3], rows[2][3], rows[0][0], rows[1][3], rows[5][1] };
    for (bits) |bit| std.debug.assert(bit == fill or bit == none);
    if (bits[0] == fill) {
        if (bits[1] == fill) {
            if (bits[2] == fill) return 'H';
            if (bits[3] == fill) {
                if (bits[4] == fill) return 'Z';
                if (bits[5] == fill) return 'E';
                return 'K';
            }
            return 'I';
        }
        if (bits[2] == fill) {
            if (bits[3] == fill) return 'R';
            return 'A';
        }
        if (bits[3] == fill) return 'L';
        return 'G';
    }
    if (bits[1] == fill) {
        if (bits[2] == fill) {
            if (bits[3] == fill) return 'U';
            return 'J';
        }
        if (bits[3] == fill) return 'F';
        return 'S';
    }
    if (bits[2] == fill) {
        if (bits[3] == fill) {
            if (bits[4] == fill) return 'P';
            return 'Y';
        }
        return 'O';
    }
    if (bits[3] == fill) return 'B';
    return 'C';
}

pub fn ocr_6x5(comptime fill: u8, comptime none: u8, buf: []u8, rows: [6][]const u8) void {
    var i: u8 = 0;
    while (i < rows[0].len / 5) : (i += 1) {
        buf[i] = ocr_6x5_once_alt(fill, none, .{
            rows[0][i * 5 ..],
            rows[1][i * 5 ..],
            rows[2][i * 5 ..],
            rows[3][i * 5 ..],
            rows[4][i * 5 ..],
            rows[5][i * 5 ..],
        });
    }
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
    try std.testing.expectEqualSlices(u8, part1, result_text_1[0 .. std.mem.indexOfScalar(u8, &result_text_1, 0) orelse result_text_1.len]);
    try std.testing.expectEqualSlices(u8, part2, result_text_2[0 .. std.mem.indexOfScalar(u8, &result_text_2, 0) orelse result_text_2.len]);
}

pub const testEqual = std.testing.expectEqual;
