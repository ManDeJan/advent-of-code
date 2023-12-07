const std = @import("std");
const aoc = @import("common.zig");

pub fn run(input: aoc.Input) !aoc.Output {
    var part1: i64 = 0;
    var part2: i64 = 0;

    var lines = aoc.splitLines(input);
    var hands1 = try aoc.newVecCap(u64, 1000);
    var hands2 = try aoc.newVecCap(u64, 1000);
    while (lines.next()) |line| {
        const value = try aoc.parseInt(u32, line["AAAAA ".len..]);
        const cards = [_]u8{ cardValue(line[0]), cardValue(line[1]), cardValue(line[2]), cardValue(line[3]), cardValue(line[4]) };
        const hands = handType(cards);
        var hand1 = @as(u64, hands[0]);
        var hand2 = @as(u64, hands[1]);

        inline for (cards) |c| {
            hand1 <<= 4;
            hand1 |= c;
            hand2 <<= 4;
            hand2 |= if (c == 11) 1 else c;
        }

        hand1 <<= 32;
        hand1 |= value;
        hand2 <<= 32;
        hand2 |= value;
        try hands1.append(hand1);
        try hands2.append(hand2);
        // aoc.print("Hand: {:>20} Cards1: {any}, Hand: {}, Value: {}\n", .{hand, cards1, handType(cards1), value});
    }

    std.sort.pdq(u64, hands1.items, {}, std.sort.asc(u64));
    std.sort.pdq(u64, hands2.items, {}, std.sort.asc(u64));
    // for (hands.items) |hand| aoc.print("{:>20}\n", .{@as(u32, @truncate(hand))});
    for (hands1.items, 1..) |hand, i|
        part1 += @intCast(@as(u32, @truncate(hand)) * i);

    for (hands2.items, 1..) |hand, i|
        part2 += @intCast(@as(u32, @truncate(hand)) * i);

    return aoc.Output{ .part1 = part1, .part2 = part2 };
}

fn cardValue(char: u8) u8 {
    return switch (char) {
        '0'...'9' => return char - '0',
        'T' => 10,
        'J' => 11,
        'Q' => 12,
        'K' => 13,
        'A' => 14,
        else => unreachable,
    };
}

fn handType(cards: [5]u8) [2]u8 {
    var diff_cards_seen: u8 = 1;
    var cards_seen = [_]u8{0} ** 5;
    var card_counts = [_]u8{0} ** 5;
    var j_count: u8 = if (cards[0] == 11) 1 else 0;
    cards_seen[0] = cards[0];
    card_counts[0] = 1;
    outer: for (cards[1..], 1..) |c, i| {
        aoc.assert(i < 5);
        if (c == 11) j_count += 1;
        for (0..i) |j| {
            if (c == cards_seen[j]) {
                card_counts[j] += 1;
                continue :outer;
            }
        }
        cards_seen[diff_cards_seen] = c;
        card_counts[diff_cards_seen] += 1;
        diff_cards_seen += 1;
    }
    if (card_counts[0] == 5) return .{ 6, 6 }; // five of a kind
    if (card_counts[0] == 4 or card_counts[1] == 4) return if (j_count != 0) .{ 5, 6 } else .{ 5, 5 }; // four of a kind
    if (card_counts[2] == 0 and (card_counts[0] == 3 or card_counts[1] == 3)) return if (j_count != 0) .{ 4, 6 } else .{ 4, 4 }; // full house
    if (card_counts[0] == 3 or card_counts[1] == 3 or card_counts[2] == 3) return if (j_count != 0) .{ 3, 5 } else .{ 3, 3 }; // three of a kind
    if (card_counts[3] == 0) return if (j_count == 1) .{ 2, 4 } else if (j_count == 2) .{ 2, 5 } else .{ 2, 2 }; // two pair
    if (card_counts[4] == 0) return if (j_count != 0) .{ 1, 3 } else .{ 1, 1 }; // one pair
    return .{ 0, j_count }; // high card
}

test "2023-7" {
    try aoc.testBoth(6440, 5905, run(
        \\32T3K 765
        \\T55J5 684
        \\KK677 28
        \\KTJJT 220
        \\QQQJA 483
    ));
}
