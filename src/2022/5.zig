const std = @import("std");
const aoc = @import("common.zig");

pub fn run(input: aoc.Input, part1: []u8, part2: []u8) !void {
    var input_sections = aoc.split(input, "\n\n");
    var header = input_sections.next().?;
    var header_sections = std.mem.splitBackwards(u8, header, "\n");
    var instructions = aoc.tokenize(input_sections.rest(), "\n");

    const stack_count = blk: {
        var stack_line = std.mem.splitBackwards(u8, header_sections.next().?[0..], " ");
        while (stack_line.next()) |stack_line_seg| {
            if (stack_line_seg.len == 0) continue;
            break :blk try std.fmt.parseUnsigned(u8, stack_line_seg, 10);
        }
        unreachable;
    };
    const max_boxes = stack_count * std.mem.count(u8, header, "\n");

    var stacks1 = try std.ArrayList(std.ArrayList(u8)).initCapacity(aoc.allocator, stack_count);
    var stacks2 = try stacks1.clone();
    defer stacks1.deinit();
    defer stacks2.deinit();
    {var i: usize = 0; while (i < stack_count) : (i += 1) {
        stacks1.appendAssumeCapacity(try std.ArrayList(u8).initCapacity(aoc.allocator, max_boxes));
        stacks2.appendAssumeCapacity(try std.ArrayList(u8).initCapacity(aoc.allocator, max_boxes));
    }}
    defer for (stacks1.items) |s| {s.deinit();};
    defer for (stacks2.items) |s| {s.deinit();};

    {var i: usize = 0; while (header_sections.next()) |box_line| : (i += 1) {
        {var j: usize = 0; while (j < stack_count) : (j += 1) {
            const letter = box_line[1 + 4 * j];
            if (letter == ' ') continue;
            stacks1.items[j].appendAssumeCapacity(letter);
            stacks2.items[j].appendAssumeCapacity(letter);
        }}
    }}

    while (instructions.next()) |instruction| {
        var instruction_tokens = aoc.tokenize(instruction, "ft mover"); // All letters in words used in instruction lines
        const amt = try std.fmt.parseUnsigned(u8, instruction_tokens.next().?, 10);
        const src = try std.fmt.parseUnsigned(u8, instruction_tokens.next().?, 10);
        const dst = try std.fmt.parseUnsigned(u8, instruction_tokens.next().?, 10);

        {var i: usize = 0; while (i < amt) : (i += 1) {
            stacks1.items[dst-1].appendAssumeCapacity(stacks1.items[src-1].pop());
        }}
        const len = stacks2.items[src-1].items.len;
        stacks2.items[dst-1].appendSliceAssumeCapacity(stacks2.items[src-1].items[len-amt..len]);
        stacks2.items[src-1].shrinkRetainingCapacity(len - amt);
    }

    for (stacks1.items) |s, i| { part1[i] = s.items[s.items.len - 1]; }
    for (stacks2.items) |s, i| { part2[i] = s.items[s.items.len - 1]; }
}

test "2022-5" {
    try aoc.testBothText("CMZ", "MCD", run,
        \\    [D]    
        \\[N] [C]    
        \\[Z] [M] [P]
        \\ 1   2   3 
        \\
        \\move 1 from 2 to 1
        \\move 3 from 1 to 3
        \\move 2 from 2 to 1
        \\move 1 from 1 to 2
        \\
    );
}
