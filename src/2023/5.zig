const std = @import("std");
const aoc = @import("common.zig");

pub fn run(input: aoc.Input) !aoc.Output {
    var sections = aoc.split(input, "\n\n");
    var seeds_it = aoc.tokenizeScalar(sections.next().?["seeds: ".len..], ' ');
    var seeds = aoc.newVec(i64);
    while (seeds_it.next()) |seed_str| try seeds.append(try aoc.parseInt(i64, seed_str));

    // aoc.print("Seeds: {}\n", .{seeds});
    var mappings = aoc.newVec(Mapping);
    while (sections.next()) |map_section| try mappings.append(try createMapping(map_section));

    // todo: benchmark sorting algorithms
    for (mappings.items) |mapping| {
        std.sort.pdq(Map, mapping.items, {}, cmpMaps);
        aoc.print("Map: {any}\n", .{mapping.items});
    }

    const part1 = solvePart1(seeds.items, mappings.items);
    const part2 = solvePart2Bf(seeds.items, mappings.items);
    return aoc.Output{ .part1 = part1, .part2 = part2 };
}

fn cmpMaps(_: void, map1: Map, map2: Map) bool {
    return map1.to < map2.to;
}

const Mapping = @TypeOf(aoc.newVec(Map));
const Mappings = @TypeOf(aoc.newVec(Mapping));

fn solvePart1(seeds: []const i64, mappings: []const Mapping) i64 {
    var part1: i64 = std.math.maxInt(i64);

    for (seeds) |seed| {
        var result = seed;
        for (mappings) |mapping| {
            // aoc.print("{} ", .{result});
            for (mapping.items) |map| {
                if (map.from <= result and result < map.from + map.range) {
                    result += map.to - map.from;
                    break;
                }
            }
        }
        // aoc.print("{}\n", .{result});
        if (result < part1) part1 = @intCast(result);
    }
    return part1;
}

fn solvePart2Bf(seeds: []const i64, mappings: []const Mapping) i64 {
    var i: i64 = 0;
    outer: while (true) : (i += 1) {
        var result = i;
        var reverse_mappings = std.mem.reverseIterator(mappings);
        while (reverse_mappings.next()) |mapping| {
            for (mapping.items) |map| {
                if (map.to <= result and result < map.to + map.range) {
                    result += map.from - map.to;
                    break;
                }
            }
        }
        for (0..seeds.len / 2) |j| {
            const seed = seeds[j * 2];
            const seed_range = seeds[j * 2 + 1];
            if (seed <= result and result < seed + seed_range)
                break :outer;
        }
    }
    return @intCast(i);
}

fn solvePart2Search(seeds: []const i64, mappings: []const Mapping) i64 {
    return backwardsSearchRec(0, std.math.maxInt(i64), 0, 0, seeds, mappings);
}

fn backwardsSearchRec(start: i64, end: i64, origin: i64, i: usize, seeds: []const i64, mappings: []const Mapping) ?i64 {
    // we're finished and need to start searching
    if (i == 0) return if (isInSeeds(start, end, seeds)) origin else null;
    const mapping = mappings[i];
    const buoy = start;
    _ = buoy;
    for (mapping) |map| {
        _ = map;
    }
}

fn isInSeeds(start: i64, end: i64, seeds: []const i64) bool {
    for (0..seeds.len / 2) |j| {
        const seed_start = seeds[j * 2];
        const seed_end = seed_start + seeds[j * 2 + 1];
        if (start < seed_end or seed_start < end)
            return true;
    }
    return false;
}

fn createMapping(section: []const u8) !Mapping {
    var lines = aoc.splitLines(section);
    var mapping = aoc.newVec(Map);
    _ = lines.next();
    while (lines.next()) |line| try mapping.append(try Map.init(line));
    // aoc.print("Map: {any}\n", .{mapping.items});
    return mapping;
}

const Map = struct {
    to: i64,
    from: i64,
    range: i64,

    pub fn init(line: []const u8) !@This() {
        var ints = aoc.tokenizeScalar(line, ' ');
        return @This(){
            .to = try aoc.parseInt(i64, ints.next().?),
            .from = try aoc.parseInt(i64, ints.next().?),
            .range = try aoc.parseInt(i64, ints.next().?),
        };
    }
};

test "2023-5" {
    try aoc.testPart1(0, run(
        \\seeds: 79 14 55 13
        \\
        \\seed-to-soil map:
        \\50 98 2
        \\52 50 48
        \\
        \\soil-to-fertilizer map:
        \\0 15 37
        \\37 52 2
        \\39 0 15
        \\
        \\fertilizer-to-water map:
        \\49 53 8
        \\0 11 42
        \\42 0 7
        \\57 7 4
        \\
        \\water-to-light map:
        \\88 18 7
        \\18 25 70
        \\
        \\light-to-temperature map:
        \\45 77 23
        \\81 45 19
        \\68 64 13
        \\
        \\temperature-to-humidity map:
        \\0 69 1
        \\1 0 69
        \\
        \\humidity-to-location map:
        \\60 56 37
        \\56 93 4
        \\
    ));
}
