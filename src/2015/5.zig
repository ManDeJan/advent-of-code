const std = @import("std");
const aoc = @import("common.zig");

// I'll admit it, this was probably better done in perl.

pub fn run(input: aoc.Input) !aoc.Output {
    var part1: i64 = 0;
    var part2: i64 = 0;

    var lines = aoc.tokenize(input, "\n");
    while (lines.next()) |line| {
        if (isNice1(line)) part1 += 1;
        if (isNice2(line)) part2 += 1;
    }

    return aoc.Output{ .part1 = part1, .part2 = part2 };
}

fn isVowel(char: u8) bool {
    return char == 'a' or
           char == 'e' or
           char == 'i' or
           char == 'o' or
           char == 'u';
}

fn isNice1(line: []const u8) bool {
    var vowel_count: u8 = 0;
    var double_letter = false;
    for (line[0..line.len - 1]) |char, i| {
        const last2 = std.mem.readIntSliceNative(u16, line[i..]);
        if (last2 == std.mem.readIntSliceNative(u16, "ab") or
            last2 == std.mem.readIntSliceNative(u16, "cd") or
            last2 == std.mem.readIntSliceNative(u16, "pq") or
            last2 == std.mem.readIntSliceNative(u16, "xy")) return false;

        if (isVowel(char)) vowel_count += 1;
        if (char == line[i + 1]) double_letter = true;
    }
    if (isVowel(line[line.len-1])) vowel_count += 1;
    return vowel_count >= 3 and double_letter;
}

fn isNice2(line: []const u8) bool {
    var double_pair = false;
    var triple_letter = false;
    for (line[0..line.len - 2]) |_, i| {
        if (line[i] == line[i+2]) triple_letter = true;
        for (line[i+2..line.len - 1]) |_, j| {
            if (std.mem.readIntSliceNative(u16, line[i..]) == std.mem.readIntSliceNative(u16, line[i+j+2..])) double_pair = true;
        }
    }
    return double_pair and triple_letter;
}

test "2015-5" {
    try aoc.testEqual(true, isNice1("ugknbfddgicrmopn"));
    try aoc.testEqual(true, isNice1("aaa"));
    try aoc.testEqual(false, isNice1("jchzalrnumimnmhp"));
    try aoc.testEqual(false, isNice1("haegwjzuvuyypxyu"));
    try aoc.testEqual(false, isNice1("dvszwmarrgswjxmb"));
    try aoc.testEqual(true, isNice1("rthkunfaakmwmush"));

    try aoc.testEqual(true, isNice2("qjhvhtzxzqqjkmpb"));
    try aoc.testEqual(true, isNice2("xxyxx"));
    try aoc.testEqual(false, isNice2("uurcxstgmygtbstg"));
    try aoc.testEqual(false, isNice2("ieodomkazucvgmuy"));

}
