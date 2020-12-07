usingnamespace @import("common.zig");

const EntryT = std.StringHashMap(Rule).Entry;

const Rule = struct {
    contains: [4]?*EntryT,
    has_gold_bag: ?bool,

    const Self = @This(); // Is this how init work?
    pub fn init() Self {
        return .{
            .has_gold_bag = null,
            .contains = [_]?*EntryT{null} ** 4
        };
    }
};

pub fn run(input: Input) anyerror!Output {
    var part1: i64 = -1;
    var part2: i64 = undefined;

    var rules = std.StringHashMap(Rule).init(allocator);
    try rules.ensureCapacity(594); // seems like everyone has 594 rules.


    var lines = tokenize(input, "\n");
    while (lines.next()) | line | {
        var idx = indexOfNthChar(2, 0, ' ', line).?;
        const color = line[0..idx];
        var new_rule = Rule.init();
        idx += 14; // skip to after "contains"
        if (line[idx] != 'n') { // if the bag contains at least something. (check for "no")
            for (new_rule.contains) | *entry | {
                idx += 2;
                const start = idx;
                idx = indexOfNthChar(2, idx, ' ', line).?;
                entry.* = (try rules.getOrPut(line[start..idx])).entry;

                const next_idx = indexOfNthChar(1, idx+3, ',', line);
                if (next_idx == null) break;
                idx = next_idx.? + 2;
            }
        }
        (try rules.getOrPut(color)).entry.value = new_rule;
    }

    rules.getEntry("shiny gold").?.value.has_gold_bag = true;

    var it = rules.iterator();
    while (it.next()) | item | {
        part1 += @as(i64, @boolToInt(contains_shiny_gold_bag(item)));
    }


    return Output{.part1 = part1, .part2 = part2};
}

fn contains_shiny_gold_bag(root_entry: *EntryT) bool {
    if (root_entry.value.has_gold_bag) | value | return value;
    root_entry.value.has_gold_bag = false;
    for (root_entry.value.contains) | *child_entry | {
        if (child_entry.* == null) break;
        root_entry.value.has_gold_bag.? = contains_shiny_gold_bag(child_entry.*.?);
        if (root_entry.value.has_gold_bag.?) break;
    }
    return root_entry.value.has_gold_bag.?;
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
