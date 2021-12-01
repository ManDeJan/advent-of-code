const aoc = @import("common.zig");

pub const strs = [_][]const u8{
    "1",
};

pub const days = .{
    @import("1.zig"),
};

pub const funcs = blk: {
    var _funcs = [_]fn(aoc.Input) callconv(.Inline) anyerror!aoc.Output{undefined} ** strs.len;
    inline for (days) |day, i| {
        _funcs[i] = day.run;
    }
    break :blk _funcs;
};
pub const inputs = blk: {
    var _inputs = [_][]const u8{undefined} ** strs.len;
    inline for (strs) |day,
    i| {
        _inputs[i] = "input/" ++ day ++ ".txt";
    }
    break :blk _inputs;
};
