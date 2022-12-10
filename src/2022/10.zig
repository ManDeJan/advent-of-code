const std = @import("std");
const aoc = @import("common.zig");

pub fn run(input: aoc.Input, part2: []u8) !aoc.OutputPart1 {
    var part1: i64 = 0;
    var cpu = try SimpleCPU.initMemory(aoc.allocator, input);

    cpu.nCycles(19);
    part1 += cpu.signalStrength();
    for (aoc.range(5)) |_| {
        cpu.nCycles(40);
        part1 += cpu.signalStrength();
    }
    cpu.nCycles(21);

    aoc.ocr_6x5('#', '.', part2, .{
        cpu.screen[0..40],
        cpu.screen[40..80],
        cpu.screen[80..120],
        cpu.screen[120..160],
        cpu.screen[160..200],
        cpu.screen[200..240],
    });
    return part1;
}

const SimpleCPU = struct {
    const Self = @This();

    const State = enum {
        done,
        addx,
    };

    const Opcode = enum(u8) {
        noop,
        addx,
    };

    const Operand = i8;

    const Mem = packed union {
        opcode: Opcode,
        operand: Operand,
    };

    comptime {
        std.debug.assert(@sizeOf(Mem) == @sizeOf(u8));
    }

    rx: i64,
    pc: u32,
    cycles: u32,
    state: State,
    memory: std.ArrayList(Mem),
    screen: [240]u8,

    pub fn init(allocator: std.mem.Allocator) Self {
        return .{
            .rx = 1,
            .pc = 0,
            .cycles = 1,
            .state = .done,
            .memory = std.ArrayList(Mem).init(allocator),
            .screen = [_]u8{'.'} ** 240,
        };
    }

    pub fn initMemory(allocator: std.mem.Allocator, input: aoc.Input) !Self {
        var self = Self.init(allocator);
        try self.readInput(input);
        return self;
    }

    pub fn deinit(self: Self) void {
        self.memory.deinit();
    }

    pub fn readInput(self: *Self, input: aoc.Input) !void {
        try self.memory.ensureTotalCapacity(input.len / 7 * 2 + 1); // Assume worst case scenario of all lines are "addx 1\n" which would require 2 bytes of memory for every 7 characters of input

        var instructions = aoc.tokenize(input, "\n");
        while (instructions.next()) |inst| {
            if (inst[0] == 'n') {
                self.memory.appendAssumeCapacity(.{ .opcode = .noop });
            } else if (inst[0] == 'a') {
                self.memory.appendAssumeCapacity(.{ .opcode = .addx });
                self.memory.appendAssumeCapacity(.{ .operand = try std.fmt.parseInt(i8, inst["addx ".len..], 10) });
            }
        }
    }

    fn draw(self: *Self) void {
        const col = (self.cycles - 1) % 40;
        if (col == self.rx - 1 or
            col == self.rx or
            col == self.rx + 1)
        {
            self.screen[self.cycles - 1] = '#';
        }
    }

    pub fn oneCycle(self: *Self) void {
        const mem = self.memory.items[self.pc];
        self.draw();
        switch (self.state) {
            .done => {
                switch (mem.opcode) {
                    .noop => {},
                    .addx => {
                        self.state = .addx;
                    },
                }
            },
            .addx => {
                self.rx += mem.operand;
                self.state = .done;
            },
        }
        self.pc += 1;
        self.cycles += 1;
    }

    pub fn nCycles(self: *Self, comptime count: comptime_int) void {
        inline for (aoc.range(count)) |_| {
            self.oneCycle();
        }
    }

    pub fn signalStrength(self: Self) i64 {
        return self.rx * self.cycles;
    }
};

test "2022-10" {
    // try aoc.testPart1(0, run(""));
    // try aoc.testPart2(0, run(""));
}
