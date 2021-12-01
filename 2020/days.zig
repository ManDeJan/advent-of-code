const aoc = @import("common.zig");

pub const strs = [_][]const u8{"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"};

pub const funcs = blk: {
    var _funcs = [_]fn(aoc.Input) anyerror!aoc.Output{undefined} ** strs.len;
    inline for (strs) |day, i| {
        _funcs[i] = @import(day ++ ".zig").run;
    }
    break :blk _funcs;
};
pub const inputs = blk: {
    var _inputs = [_][]const u8{undefined} ** strs.len;
    inline for (strs) |day, i| {
        _inputs[i] = "input/" ++ day ++ ".txt";
    }
    break :blk _inputs;
};
