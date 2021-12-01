const std = @import("std");
const aoc = @import("common.zig");

const Rule = struct {
    contains: [4]?*Rule,
    contains_amt: [4]u8,
    has_gold_bag: ?bool,

    const Self = @This(); // Is this how init work?
    pub fn init() Self {
        return .{
            .has_gold_bag = null,
            .contains = [_]?*Rule{null} ** 4,
            .contains_amt = [_]u8{0} ** 4,
        };
    }
};

pub inline fn run(input: aoc.Input) anyerror!aoc.Output {
    var part1: i64 = -1;
    var part2: i64 = undefined;

    var rules: [594]Rule = undefined; 

    var lines = tokenize(input, "\n");
    while (lines.next()) | line | {
        const first_start_col = indexOfNthChar(1, 0, ' ', line).? + 1;
        var idx = indexOfNthChar(1, first_start_col, ' ', line).?;
        const color = line[0..idx];
        var new_rule = Rule.init();
        idx += 14; // skip to after "contains"
        if (line[idx] != 'n') { // if the bag contains at least something. (check for "no")
            for (new_rule.contains) | *rule, i | {
                new_rule.contains_amt[i] = line[idx] - '0';
                idx += 2;
                const start = idx;
                const arg_start_col = indexOfNthChar(1, idx, ' ', line).? + 1;
                idx = indexOfNthChar(1, arg_start_col, ' ', line).?;
                rule.* = &rules[perfect_hash_bag(line[start..idx], arg_start_col - start)];

                const next_idx = indexOfNthChar(1, idx+3, ',', line);
                if (next_idx == null) break;
                idx = next_idx.? + 2;
            }
        }
        rules[perfect_hash_bag(color, first_start_col)] = new_rule;
    }

    const shiny_gold_rule = &rules[perfect_hash_bag("shiny gold", 6)];
    part2 = count_bags_recursive(shiny_gold_rule) - 1; // minus one because we count the bag itself
    shiny_gold_rule.has_gold_bag = true;

    for (rules) | *rule | {
        part1 += @as(i64, @boolToInt(contains_shiny_gold_bag(rule)));
    }

    return Output{.part1 = part1, .part2 = part2};
}

fn count_bags_recursive(root_rule: *Rule) i64 {
    var total: i64 = 1;
    for (root_rule.contains) | *child_rule, i | {
        if (child_rule.* == null) break;
        total += @as(i64, root_rule.contains_amt[i]) *
                 count_bags_recursive(child_rule.*.?);
    }
    return total;
}

fn contains_shiny_gold_bag(root_rule: *Rule) bool {
    if (root_rule.has_gold_bag) | value | return value;
    root_rule.has_gold_bag = false;
    for (root_rule.contains) | *child_rule | {
        if (child_rule.* == null) break;
        root_rule.has_gold_bag.? = contains_shiny_gold_bag(child_rule.*.?);
        if (root_rule.has_gold_bag.?) break;
    }
    return root_rule.has_gold_bag.?;
}

fn indexOfNthChar(comptime idx: usize, start: usize, comptime needle: u8, haystack: []const u8) ?usize {
    var count: usize = 0;
    var i: usize = start;
    while (i < haystack.len) : (i += 1) {
        if (haystack[i] == needle) {
            count += 1;
            if (count == idx) return i;
        }
    }
    return null;
}

const lookup_table = comptime blk: {
    @setEvalBranchQuota(8000);
    var _lookup_table = [_]u16{0} ** 4717;
    var i = 0;
    for (bag_names) | bag | {
        const start_col = indexOfNthChar(1, 0, ' ', bag).? + 1;
        _lookup_table[hash_bag_impl(bag, start_col)] = i;
        i += 1;
    }
    break :blk _lookup_table;
};

// magic hash function, do not question it
fn hash_bag_impl(bag: []const u8, start_col: usize) u16 {
    const key = @as(usize, bag[0] ) << 0 ^
                @as(usize, bag[1] ) << 3 ^
                @as(usize, bag[0+start_col]) << 10 ^
                @as(usize, bag[1+start_col]) << 10 ^
                @as(usize, bag.len) << 7;
    return @intCast(u16, (key ^ 2985) % 4739);
}

fn perfect_hash_bag(bag: []const u8, start_col: usize) u16 {
    return lookup_table[hash_bag_impl(bag, start_col)];
}

const ads = [_][]const u8{"bright", "clear", "dark", "dim", "dotted", "drab", "dull", "faded", "light", "mirrored", "muted", "pale", "plaid", "posh", "shiny", "striped", "vibrant", "wavy"};
const colors = [_][]const u8{"aqua", "beige", "black", "blue", "bronze", "brown", "chartreuse", "coral", "crimson", "cyan", "fuchsia", "gold", "gray", "green", "indigo", "lavender", "lime", "magenta", "maroon", "olive", "orange", "plum", "purple", "red", "salmon", "silver", "tan", "teal", "tomato", "turquoise", "violet", "white", "yellow"};
const bag_names = comptime blk: {
    var _bag_names: [ads.len * colors.len][]const u8 = undefined;
    for (ads) |ad, i| {
        for (colors) |col, j| {
            _bag_names[i * colors.len + j] = ad ++ " " ++ col;
        }
    }
    break :blk _bag_names;
};
