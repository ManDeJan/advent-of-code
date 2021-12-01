const std = @import("std");
const aoc = @import("common.zig");

pub inline fn run(input: aoc.Input) anyerror!aoc.Output {
    var part1: i64 = 0;
    var part2: i64 = 0;

    // var timer = try Timer.start(); // DEBUG
    // var time: u64 = 0; // DEBUG
    
    // var total_minnum: u64 = 0; // DEBUG
    // var total_maxnum: u64 = 0; // DEBUG
    // var total_part1: u64 = 0; // DEBUG
    // var total_part2: u64 = 0; // DEBUG

    var lines = aoc.tokenize(input, "\n");
    while (lines.next()) |line| {
        var offset: u32 = 2;

        // time = timer.lap(); // DEBUG
        
        const minnum = blk: {
            var _minnum: u32 = undefined;
            _minnum = line[0] - '0';
            if (line[1] != '-') {
                _minnum *= 10;
                _minnum += line[1] - '0';
                offset += 1;
            }
            break :blk _minnum;
        };

        // time = timer.lap(); // DEBUG
        // total_minnum += time; // DEBUG
        // time = timer.lap(); // DEBUG

        const maxnum = blk: {
            var _maxnum: u32 = undefined;
            _maxnum = line[offset] - '0';
            if (line[offset+1] != ' ') {
                _maxnum *= 10;
                _maxnum += line[offset+1] - '0';
                offset += 1;
            }
            offset += 2;
            break :blk _maxnum;
        };

        // time = timer.lap(); // DEBUG
        // total_maxnum += time; // DEBUG
        // time = timer.lap(); // DEBUG

        const key = line[offset];
        offset += 2;

        var count: u32 = 0;
        for (line[offset+1..]) | char | {
            if (char == key) count += 1;
        }
        if (minnum <= count and count <= maxnum) part1 += 1;

        // time = timer.lap(); // DEBUG
        // total_part1 += time; // DEBUG
        // time = timer.lap(); // DEBUG

        if ((line[offset+minnum] == key) != (line[offset+maxnum] == key)) {
            part2 += 1;
        }

        // time = timer.lap(); // DEBUG
        // total_part2 += time; // DEBUG

        // print("{}, {}, {c}, {}\n", .{minnum, maxnum, key, count});
    }
    // print(">>> Min: {} Max: {}, Part1: {}, Part2: {}\n", .{total_minnum, total_maxnum, total_part1, total_part2}); // DEBUG
    // print(">>> Total: {}\n", .{total_minnum + total_maxnum + total_part1 + total_part2}); // DEBUG

    return aoc.Output{.part1 = part1, .part2 = part2};
}
