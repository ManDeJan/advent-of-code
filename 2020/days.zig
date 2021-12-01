const aoc = @import("common.zig");

pub const strs = [_][]const u8{
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
};

pub const days = .{
    @import("1.zig"),
    @import("2.zig"),
    @import("3.zig"),
    @import("4.zig"),
    @import("5.zig"),
    @import("6.zig"),
    @import("7.zig"),
    @import("8.zig"),
    @import("9.zig"),
    @import("10.zig"),
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
