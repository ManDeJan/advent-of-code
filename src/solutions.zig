const aoc = @import("common.zig");

fn getSolution(comptime import: anytype) aoc.SolutionFnType {
    const args = @typeInfo(@TypeOf(import.run)).Fn.args;
    return switch (args.len) {
        1 => .{.outputAsInt = import.run},
        2 => .{.outputAsIntText = import.run},
        else => .{.outputAsText = import.run},
    };
}

pub const SolutionYear = struct {
    year: []const u8,
    days: []const []const u8,
    funcs: []const aoc.SolutionFnType,
};

pub const solutions = [_]SolutionYear{
    .{
        .year = "2015",
        .days = &.{
            "1", "2", "3", "4", "5", // "6", "7", "8", "9", "10",
        },
        .funcs = &.{
            getSolution(@import("2015/1.zig")),
            getSolution(@import("2015/2.zig")),
            getSolution(@import("2015/3.zig")),
            getSolution(@import("2015/4.zig")),
            getSolution(@import("2015/5.zig")),
            // getSolution(@import("2015/6.zig")),
            // getSolution(@import("2015/7.zig")),
            // getSolution(@import("2015/8.zig")),
            // getSolution(@import("2015/9.zig")),
            // getSolution(@import("2015/10.zig")),
        },
    },
    .{
        .year = "2016",
        .days = &.{
            "1",
        },
        .funcs = &.{
            getSolution(@import("2016/1.zig")),
        },
    },
    .{
        .year = "2020",
        .days = &.{
            "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
        },
        .funcs = &.{
            getSolution(@import("2020/1.zig")),
            getSolution(@import("2020/2.zig")),
            getSolution(@import("2020/3.zig")),
            getSolution(@import("2020/4.zig")),
            getSolution(@import("2020/5.zig")),
            getSolution(@import("2020/6.zig")),
            getSolution(@import("2020/7.zig")),
            getSolution(@import("2020/8.zig")),
            getSolution(@import("2020/9.zig")),
            getSolution(@import("2020/10.zig")),
        },
    },
    .{
        .year = "2021",
        .days = &.{
            "1", "2", "3", "4", "5", "6", "7", "8", "9",
        },
        .funcs = &.{
            getSolution(@import("2021/1.zig")),
            getSolution(@import("2021/2.zig")),
            getSolution(@import("2021/3.zig")),
            getSolution(@import("2021/4.zig")),
            getSolution(@import("2021/5.zig")),
            getSolution(@import("2021/6.zig")),
            getSolution(@import("2021/7.zig")),
            getSolution(@import("2021/8.zig")),
            getSolution(@import("2021/9.zig")),
        },
    },
    .{
        .year = "2022",
        .days = &.{
            "1", "2", "3", "5", "6", "10"
        },
        .funcs = &.{
            getSolution(@import("2022/1.zig")),
            getSolution(@import("2022/2.zig")),
            getSolution(@import("2022/3.zig")),
            getSolution(@import("2022/5.zig")),
            getSolution(@import("2022/6.zig")),
            // getSolution(@import("2022/9.zig")),
            getSolution(@import("2022/10.zig")),
        },
    },
};
