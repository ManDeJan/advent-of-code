const aoc = @import("common.zig");

fn getSolution(comptime import: anytype) aoc.SolutionFnType {
    const params = @typeInfo(@TypeOf(import.run)).@"fn".params;
    return switch (params.len) {
        1 => .{ .outputAsInt = import.run },
        2 => .{ .outputAsIntText = import.run },
        else => .{ .outputAsText = import.run },
    };
}

pub const SolutionYear = struct {
    year: []const u8,
    days: []const []const u8,
    funcs: []const aoc.SolutionFnType,
};

pub const solutions = [_]SolutionYear{
    // .{
    //     .year = "2015",
    //     .days = &.{
    //         "1", "2", "3", "4", "5", // "6", "7", "8", "9", "10",
    //     },
    //     .funcs = &.{
    //         getSolution(@import("2015/1.zig")),
    //         getSolution(@import("2015/2.zig")),
    //         getSolution(@import("2015/3.zig")),
    //         getSolution(@import("2015/4.zig")),
    //         getSolution(@import("2015/5.zig")),
    //         // getSolution(@import("2015/6.zig")),
    //         // getSolution(@import("2015/7.zig")),
    //         // getSolution(@import("2015/8.zig")),
    //         // getSolution(@import("2015/9.zig")),
    //         // getSolution(@import("2015/10.zig")),
    //     },
    // },
    // .{
    //     .year = "2016",
    //     .days = &.{
    //         "1",
    //     },
    //     .funcs = &.{
    //         getSolution(@import("2016/1.zig")),
    //     },
    // },
    // .{
    //     .year = "2020",
    //     .days = &.{
    //         "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
    //     },
    //     .funcs = &.{
    //         getSolution(@import("2020/1.zig")),
    //         getSolution(@import("2020/2.zig")),
    //         getSolution(@import("2020/3.zig")),
    //         getSolution(@import("2020/4.zig")),
    //         getSolution(@import("2020/5.zig")),
    //         getSolution(@import("2020/6.zig")),
    //         getSolution(@import("2020/7.zig")),
    //         getSolution(@import("2020/8.zig")),
    //         getSolution(@import("2020/9.zig")),
    //         getSolution(@import("2020/10.zig")),
    //     },
    // },
    // .{
    //     .year = "2021",
    //     .days = &.{
    //         "1", "2", "3", "4", "5", "6", "7", "8", "9",
    //     },
    //     .funcs = &.{
    //         getSolution(@import("2021/1.zig")),
    //         getSolution(@import("2021/2.zig")),
    //         getSolution(@import("2021/3.zig")),
    //         getSolution(@import("2021/4.zig")),
    //         getSolution(@import("2021/5.zig")),
    //         getSolution(@import("2021/6.zig")),
    //         getSolution(@import("2021/7.zig")),
    //         getSolution(@import("2021/8.zig")),
    //         getSolution(@import("2021/9.zig")),
    //     },
    // },
    // .{
    //     .year = "2022",
    //     .days = &.{
    //         "1", "2", "3", "5", "6", "7", "9", "10", "11", "12",
    //         // "12",
    //     },
    //     .funcs = &.{
    //         getSolution(@import("2022/1.zig")),
    //         getSolution(@import("2022/2.zig")),
    //         getSolution(@import("2022/3.zig")),
    //         getSolution(@import("2022/5.zig")),
    //         getSolution(@import("2022/6.zig")),
    //         getSolution(@import("2022/7.zig")),
    //         getSolution(@import("2022/9.zig")),
    //         getSolution(@import("2022/10.zig")),
    //         getSolution(@import("2022/11.zig")),
    //         getSolution(@import("2022/12.zig")),
    //         // getSolution(@import("2022/14.zig")),
    //     },
    // },
    // .{
    //     .year = "2023",
    //     .days = &.{
    //         "1",
    //         "2",
    //         "3",
    //         "4",
    //         // "5",
    //         "6",
    //         "7",
    //         "8",
    //         "9",
    //     },
    //     .funcs = &.{
    //         getSolution(@import("2023/1.zig")),
    //         getSolution(@import("2023/2.zig")),
    //         getSolution(@import("2023/3.zig")),
    //         getSolution(@import("2023/4.zig")),
    //         // getSolution(@import("2023/5.zig")),
    //         getSolution(@import("2023/6.zig")),
    //         getSolution(@import("2023/7.zig")),
    //         getSolution(@import("2023/8.zig")),
    //         getSolution(@import("2023/9.zig")),
    //         // getSolution(@import("2023/10.zig")),
    //         // getSolution(@import("2023/11.zig")),
    //         // getSolution(@import("2023/12.zig")),
    //         // getSolution(@import("2023/14.zig")),
    //     },
    // },
    .{
        .year = "2024",
        .days = &.{
            "1",
            "2",
            "3",
        },
        .funcs = &.{
            getSolution(@import("2024/1.zig")),
            getSolution(@import("2024/2.zig")),
            getSolution(@import("2024/3.zig")),
        },
    },
};
