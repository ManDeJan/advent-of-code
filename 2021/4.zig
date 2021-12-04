const std = @import("std");
const aoc = @import("common.zig");

pub noinline fn run(input: aoc.Input) !aoc.Output {
    var part1: i64 = 0;
    var part2: i64 = 0;

    var lines = aoc.split(input, "\n\n");

    var bingo_nums = aoc.newVec(u8);
    var bingo_line = aoc.tokenize(lines.next().?, ",");

    while (bingo_line.next()) |bingo_num| {
        try bingo_nums.append(try std.fmt.parseInt(u8, bingo_num, 10));
    }

    // is this data oriented design? 🤡
    var bingo_boards = aoc.newVec([25]u8);
    var board_tallys = aoc.newVec([5 + 5]u8);
    var board_totals = aoc.newVec(u32);
    var board_finished = aoc.newVec(bool);

    while (lines.next()) |board_line| {
        var board_nums = aoc.tokenize(board_line, " \n");
        var board: [25]u8 = undefined;
        for (board) |*num| {
            num.* = try std.fmt.parseInt(u8, board_nums.next().?, 10);
        }
        try bingo_boards.append(board);
        try board_tallys.append([_]u8{0} ** (5 + 5));
        try board_totals.append(0);
        try board_finished.append(false);
    }
    // the above takes about 26 microseconds

    var boards_finished: u32 = 0;
    stop_bingo: for (bingo_nums.items) |bingo_num| {
        for (bingo_boards.items) |board, board_i| {
            if (board_finished.items[board_i]) continue;

            for (board) |board_num, num_i| {
                if (board_num == bingo_num) {
                    board_totals.items[board_i] += bingo_num;
                    board_tallys.items[board_i][    num_i / 5] += 1;
                    board_tallys.items[board_i][5 + num_i % 5] += 1;
                    if (board_tallys.items[board_i][    num_i / 5] == 5 or
                        board_tallys.items[board_i][5 + num_i % 5] == 5) {
                        // BINGOOOO !!!!!! DOOR VOOR DE BROODROOSTER BEP
                        boards_finished += 1;
                        board_finished.items[board_i] = true;
                        if (boards_finished == 1) {
                            part1 = calculateBoardSum(board, board_totals.items[board_i]) * bingo_num;
                        } else if (boards_finished == board_finished.items.len) {
                            part2 = calculateBoardSum(board, board_totals.items[board_i]) * bingo_num;
                            break :stop_bingo;
                        }
                        break;
                    }
                }
            }
        }
    }
    return aoc.Output{.part1 = part1, .part2 = part2};
}

fn calculateBoardSum(board: [25]u8, board_total: u32) u32 {
    const sum = blk: {
        var acc: u32 = 0;
        for (board) |num| {
            acc += num;
        }
        acc -= board_total;
        break :blk acc;
    };
    return sum;
}
