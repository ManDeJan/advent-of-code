usingnamespace @import("common.zig");


// byr (Birth Year) - four digits; at least 1920 and at most 2002.
// iyr (Issue Year) - four digits; at least 2010 and at most 2020.
// eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
// hgt (Height) - a number followed by either cm or in:
// If cm, the number must be at least 150 and at most 193.
// If in, the number must be at least 59 and at most 76.
// hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
// ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
// pid (Passport ID) - a nine-digit number, including leading zeroes.
// cid (Country ID) - ignored, missing or not.

pub fn run(input: Input) anyerror!Output {
    var part1: i64 = 0;
    var part2: i64 = 0;

    var lines = mem.split(input, "\n\n");
    while (lines.next()) |line| {
        var parts = mem.tokenize(line, "\n ");
        var part_count: usize = 0;
        var valid = true;
        while (parts.next()) | part | {
            if (part[0] != 'c') part_count += 1; // hacky ignore cid check
            const value = part[4..];
            valid = valid and switch (part[0..3]) {
                "byr" => check_byr(value),
                "iyr" => check_iyr(value),
                "eyr" => check_eyr(value),
                "hgt" => check_hgt(value),
                "hcl" => check_hcl(value),
                "ecl" => check_ecl(value),
                "pid" => check_pid(value),
                "cid" => check_cid(value),
                else  => blk: {print("Wat?\n", .{}); break :blk true;},
            };
        }
        if (part_count == 7) { part1 += 1;   // alignment
        if (valid)             part2 += 1; } // yay or nay?
    }

    return Output{.part1 = part1, .part2 = part2};
}

fn check_byr(value: []const u8) bool {
    return true;
}

fn check_iyr(value: []const u8) bool {
    return true;
}

fn check_eyr(value: []const u8) bool {
    return true;
}

fn check_hgt(value: []const u8) bool {
    return true;
}

fn check_hcl(value: []const u8) bool {
    return true;
}

fn check_ecl(value: []const u8) bool {
    return true;
}

fn check_pid(value: []const u8) bool {
    return true;
}

fn check_cid(value: []const u8) bool {
    return true;
}
