const std = @import("std");
const mem = std.mem;
const aoc = @import("common.zig");

pub fn run(input: aoc.Input) anyerror!aoc.Output {
    var part1: i64 = 0;
    var part2: i64 = 0;

    var lines = aoc.split(input, "\n\n");
    while (lines.next()) |line| {
        var parts = aoc.tokenize(line, "\n ");
        var part_count: usize = 0;
        var valid = true;

        while (parts.next()) |part| {
            if (part[0] != 'c') part_count += 1; // hacky ignore cid check
            const value = part[4..];
            valid = valid and switch (match_str(part[0..])) {
                match_str("byr:") => check_byr(value),
                match_str("iyr:") => check_iyr(value),
                match_str("eyr:") => check_eyr(value),
                match_str("hgt:") => check_hgt(value),
                match_str("hcl:") => check_hcl(value),
                match_str("ecl:") => check_ecl(value),
                match_str("pid:") => check_pid(value),
                match_str("cid:") => check_cid(value),
                else => unreachable,
            };
        }
        if (part_count == 7) {
            part1 += 1; // alignment
            if (valid) part2 += 1;
        } // yay or nay?
    }

    return aoc.Output{ .part1 = part1, .part2 = part2 };
}

fn match_str(value: []const u8) u32 {
    return mem.readPackedIntNative(u32, value, 0);
}

// byr (Birth Year) - four digits; at least 1920 and at most 2002.
fn check_byr(value: []const u8) bool {
    // My input doesn't have birth years before 1920... possible optimization?
    // If it's hacky and you know it clap your hands👏🏼👏🏼
    const year = mem.readInt(u32, value[0..4], .big);
    const min = mem.readInt(u32, "1920", .big);
    const max = mem.readInt(u32, "2002", .big);
    return year <= max and min <= year;
}

// iyr (Issue Year) - four digits; at least 2010 and at most 2020.
fn check_iyr(value: []const u8) bool {
    const year = mem.readInt(u32, value[0..4], .big);
    const min = mem.readInt(u32, "2010", .big);
    const max = mem.readInt(u32, "2020", .big);
    return min <= year and year <= max;
}

// eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
fn check_eyr(value: []const u8) bool {
    const year = mem.readInt(u32, value[0..4], .big);
    const min = mem.readInt(u32, "2020", .big);
    const max = mem.readInt(u32, "2030", .big);
    return min <= year and year <= max;
}

// hgt (Height) - a number followed by either cm or in:
// If cm, the number must be at least 150 and at most 193.
// If in, the number must be at least 59 and at most 76.
fn check_hgt(value: []const u8) bool {
    const unit = mem.readInt(u16, value[value.len - 2 ..][0..2], aoc.native);
    const cm = mem.readInt(u16, "cm", aoc.native);
    const in = mem.readInt(u16, "in", aoc.native);
    if (unit == cm) { // bogus logic comming right up
        if (value.len != 5 or value[0] != '1') return false;
        const min = mem.readInt(u16, "50", .big);
        const max = mem.readInt(u16, "93", .big);
        const len = mem.readInt(u16, value[1..][0..2], .big);
        return min <= len and len <= max;
    }
    if (unit == in) { // bogus logic comming right up
        if (value.len != 4) return false;
        const min = mem.readInt(u16, "59", .big);
        const max = mem.readInt(u16, "76", .big);
        const len = mem.readInt(u16, value[0..2], .big);
        return min <= len and len <= max;
    }
    return false;
}

// hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
fn check_hcl(value: []const u8) bool {
    return value[0] == '#'; // This is all you need apperantly :')
}

// ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
fn check_ecl(value: []const u8) bool {
    return (mem.eql(u8, value, "amb") or
        mem.eql(u8, value, "blu") or
        mem.eql(u8, value, "brn") or
        mem.eql(u8, value, "gry") or
        mem.eql(u8, value, "grn") or
        mem.eql(u8, value, "hzl") or
        mem.eql(u8, value, "oth"));
}
// pid (Passport ID) - a nine-digit number, including leading zeroes.
fn check_pid(value: []const u8) bool {
    return value.len == 9;
}

// cid (Country ID) - ignored, missing or not.
fn check_cid(value: []const u8) bool {
    // print("{}\n", .{value});
    _ = value;
    return true;
}
