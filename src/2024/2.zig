const std = @import("std");
const aoc = @import("common.zig");

// types & limits to play around with for performance
const ParseT = i8;
const NumT = i8;
const max_line_n = 8;

fn diff(T: type, a: T, b: T) T {
    return if (a > b) a - b else b - a;
}

pub fn run(input: aoc.Input) !aoc.Output {
    var part1: aoc.OutputPart1 = 0;
    var part2: aoc.OutputPart2 = 0;

    var lines = aoc.splitLines(input);

    lines: while (lines.next()) |line| {
        var nums: [max_line_n]NumT = undefined;
        var nums_len: usize = 0;
        var split_line = aoc.splitScalar(line, ' ');
        while (split_line.next()) |num_s| {
            nums[nums_len] = try aoc.parseInt(ParseT, num_s);
            nums_len += 1;
        }
        const nums_slice = nums[0..nums_len];
        // sliding window over pairs of num
        var window = aoc.window(NumT, nums_slice, 2, 1);

        var isDeclining = nums_slice[0] > nums_slice[1];

        while (window.next()) |p1_p2| {
            if (isDeclining and p1_p2[0] < p1_p2[1]) break;
            if (!isDeclining and p1_p2[0] > p1_p2[1]) break;
            const delta = diff(NumT, p1_p2[0], p1_p2[1]);
            if (delta < 1 or delta > 3) break;
        } else {
            part1 += 1;
            continue :lines;
        }

        const failed_window_state = window; // let's save this window for the second case

        // special cases for end, you can always remove p2 and still have a succesfull sequence
        if (window.index == null) {
            part2 += 1;
            continue :lines;
        }
        if (window.index.? == 1) { // special case for start
            isDeclining = nums_slice[1] > nums_slice[2];
            while (window.next()) |p1_p2| {
                if (isDeclining and p1_p2[0] < p1_p2[1]) break;
                if (!isDeclining and p1_p2[0] > p1_p2[1]) break;
                const delta = diff(NumT, p1_p2[0], p1_p2[1]);
                if (delta < 1 or delta > 3) break;
            } else {
                part2 += 1;
                continue :lines;
            }
            window = failed_window_state;

            nums_slice[1] = nums_slice[0];
            isDeclining = nums_slice[1] > nums_slice[2];
            while (window.next()) |p1_p2| {
                if (isDeclining and p1_p2[0] < p1_p2[1]) break;
                if (!isDeclining and p1_p2[0] > p1_p2[1]) break;
                const delta = diff(NumT, p1_p2[0], p1_p2[1]);
                if (delta < 1 or delta > 3) break;
            } else {
                part2 += 1;
                continue :lines;
            }
            continue :lines;
        }
        if (window.index.? == 2) { // special case for wrong declinement on starting pair
            window.index.? -= 1;
            isDeclining = nums_slice[1] > nums_slice[2];
            while (window.next()) |p1_p2| {
                if (isDeclining and p1_p2[0] < p1_p2[1]) break;
                if (!isDeclining and p1_p2[0] > p1_p2[1]) break;
                const delta = diff(NumT, p1_p2[0], p1_p2[1]);
                if (delta < 1 or delta > 3) break;
            } else {
                part2 += 1;
                continue :lines;
            }
            window = failed_window_state;
        }

        // general case

        // for part 2 there's 2 options to continue, remove either the number at the current idx, or the number ahead, if we then still have issues we're on an unsafe level

        // first the case where we remove the *first number of the pair we're on*, this requires copying
        // the -1 digit to the first digit and retrying it
        // after a .next() call on window, the index is already ahead of the pair we just failed on, so to start with, we return one

        window.index.? -= 1;
        // now index points to the current failed pair, to skip the first digit, we overwrite it with the previous

        const old_p1 = nums_slice[window.index.?];
        nums_slice[window.index.?] = nums_slice[window.index.? - 1]; // now try again
        if (window.index == 1) {
            isDeclining = nums_slice[1] > nums_slice[2];
        }
        while (window.next()) |p1_p2| {
            if (isDeclining and p1_p2[0] < p1_p2[1]) break;
            if (!isDeclining and p1_p2[0] > p1_p2[1]) break;
            const delta = diff(NumT, p1_p2[0], p1_p2[1]);
            if (delta < 1 or delta > 3) break;
        } else {
            part2 += 1;
            continue :lines;
        }

        // okay, we still failed, let's restore the window and try remove the second part of the pair
        window = failed_window_state;
        // index now points to p2 of the failed pair, to remove it we need to copy the previous index (previously overwritten and saved as old_p1, onto the current position)

        nums_slice[window.index.? - 1] = old_p1;
        nums_slice[window.index.?] = old_p1;

        while (window.next()) |p1_p2| {
            if (isDeclining and p1_p2[0] < p1_p2[1]) break;
            if (!isDeclining and p1_p2[0] > p1_p2[1]) break;
            const delta = diff(NumT, p1_p2[0], p1_p2[1]);
            if (delta < 1 or delta > 3) break;
        } else {
            part2 += 1;
            continue :lines;
        }
    }

    part2 += part1; // add already safe levels from part 1
    return aoc.Output{ .part1 = part1, .part2 = part2 };
}

test "2024-2" {
    try aoc.testBoth(2, 4, run(
        \\7 6 4 2 1
        \\1 2 7 8 9
        \\9 7 6 2 1
        \\1 3 2 4 5
        \\8 6 4 4 1
        \\1 3 6 7 9
        \\
    ));

    // Edge cases
    try aoc.testPart2(2, run(
        \\14 13 14 17 20 22 25 27
        \\81 83 82 79 77 75 74 71
        \\
    ));
}
