const aoc = @import("common.zig");

// pub const Solution = struct {
//     year: []const u8,
//     day: []const u8,
//     func: (fn(aoc.Input) anyerror!aoc.Output),
// };

pub const SolutionYear = struct {
    year: []const u8,
    days: []const []const u8,
    funcs: []const *const fn(aoc.Input) anyerror!aoc.Output
};

pub const solutions = [_]SolutionYear{
    .{
        .year = "2015",
        .days = &.{
            "1", "2", "3", "4", "5",// "6", "7", "8", "9", "10",
        },
        .funcs = &.{
            @import("2015/1.zig").run,
            @import("2015/2.zig").run,
            @import("2015/3.zig").run,
            @import("2015/4.zig").run,
            @import("2015/5.zig").run,
            // @import("2015/6.zig").run,
            // @import("2015/7.zig").run,
            // @import("2015/8.zig").run,
            // @import("2015/9.zig").run,
            // @import("2015/10.zig").run,
        }
    },
    .{
        .year = "2016",
        .days = &.{
            "1",
        },
        .funcs = &.{
            @import("2016/1.zig").run,
        }
    },
    .{
        .year = "2020",
        .days = &.{
            "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
        },
        .funcs = &.{
            @import("2020/1.zig").run,
            @import("2020/2.zig").run,
            @import("2020/3.zig").run,
            @import("2020/4.zig").run,
            @import("2020/5.zig").run,
            @import("2020/6.zig").run,
            @import("2020/7.zig").run,
            @import("2020/8.zig").run,
            @import("2020/9.zig").run,
            @import("2020/10.zig").run,
        }
    },
    .{
        .year = "2021",
        .days = &.{
            "1", "2", "3", "4", "5", "6", "7", "8", "9",
        },
        .funcs = &.{
            @import("2021/1.zig").run,
            @import("2021/2.zig").run,
            @import("2021/3.zig").run,
            @import("2021/4.zig").run,
            @import("2021/5.zig").run,
            @import("2021/6.zig").run,
            @import("2021/7.zig").run,
            @import("2021/8.zig").run,
            @import("2021/9.zig").run,
        }
    },
    .{
        .year = "2022",
        .days = &.{
            "1", "2",
        },
        .funcs = &.{
            @import("2022/1.zig").run,
            @import("2022/2.zig").run,
        }
    },
};

//  [_]Solution{
//     .
//     Solution{.year = "2021", .day = "1", .func = @import("2021/1.zig").run},
// };
