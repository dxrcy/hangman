const std = @import("std");
const io = std.io;
const fs = std.fs;
const debug = std.debug;
const process = std.process;
const ArrayList = std.ArrayList;
const stdin = std.io.getStdIn().reader();

pub fn main() !void {
    print("=== HANGMAN ===\n", .{});

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var args = std.process.args();
    _ = args.next();

    const filename = args.next() orelse {
        debug.print("Please provide a file path.\n", .{});
        process.exit(1);
    };

    var words = ArrayList(ArrayList(u8)).init(allocator);
    defer {
        for (words.items) |item| {
            item.deinit();
        }
        words.deinit();
    }

    readFileLines(filename, &words, allocator) catch {
        debug.print("Failed to read file.\n", .{});
        process.exit(2);
    };

    var seed: u64 = undefined;
    try std.os.getrandom(std.mem.asBytes(&seed));
    var prng = std.rand.DefaultPrng.init(seed);
    const rand = prng.random();

    print("\n\n\n\n\n\n", .{});

    while (true) {
        const index = rand.intRangeAtMost(usize, 0, words.items.len - 1);
        const word = words.items[index];

        var correct = HashSet(u8).init(allocator);
        defer correct.deinit();
        var incorrect = HashSet(u8).init(allocator);
        defer incorrect.deinit();

        while (true) {
            for (0..5) |_| {
                print("\x1b[A\x1b[K", .{});
            }

            var visible = ArrayList(u8).init(allocator);
            defer visible.deinit();
            var is_win = true;
            for (word.items) |char| {
                if (correct.contains(char)) {
                    try visible.append(char);
                } else {
                    try visible.append('_');
                    is_win = false;
                }
            }

            if (is_win) {
                print("---------\n", .{});
                print("You win! :)\n", .{});
                print("The word was: '{s}'\n", .{word.items});
                print("---------\n", .{});
                _ = try stdin.readByte();
                break;
            }
            if (incorrect.count() >= 6) {
                print("---------\n", .{});
                print("You lose! :(\n", .{});
                print("The word was: '{s}'\n", .{word.items});
                print("---------\n", .{});
                _ = try stdin.readByte();
                break;
            }

            print("{s}\n", .{visible.items});
            print("Chances: {}\n", .{6 - incorrect.count()});
            print("Correct: ", .{});
            printSet(&correct);
            print("Incorrect: ", .{});
            printSet(&incorrect);
            print("Guess: ", .{});

            const guess = try readFirstByte() orelse continue;

            if (arrayContains(guess, &word.items)) {
                try correct.put(guess, true);
            } else {
                try incorrect.put(guess, true);
            }
        }
    }
}

fn HashSet(comptime K: type) type {
    return std.AutoHashMap(K, bool);
}

pub fn print(comptime fmt: []const u8, args: anytype) void {
    const stdout = io.getStdOut().writer();
    nosuspend stdout.print(fmt, args) catch return;
}

fn readFileLines(filename: [:0]const u8, list: *ArrayList(ArrayList(u8)), allocator: anytype) !void {
    const file = try fs.cwd().openFile(filename, .{});
    defer file.close();

    var buf_reader = io.bufferedReader(file.reader());
    const reader = buf_reader.reader();

    var line = ArrayList(u8).init(allocator);
    defer line.deinit();
    const writer = line.writer();

    while (reader.streamUntilDelimiter(writer, '\n', null)) {
        defer line.clearRetainingCapacity();

        // Remove trailing \r
        if (line.items[line.items.len - 1] == '\r') {
            line.items.len -= 1;
        }

        var string = ArrayList(u8).init(allocator);
        try string.appendSlice(line.items);
        try list.append(string);
    } else |err| switch (err) {
        error.EndOfStream => {},
        else => return err,
    }
}

fn printSet(set: *const HashSet(u8)) void {
    var it = set.iterator();
    var i: usize = 0;
    while (it.next()) |item| : (i += 1) {
        if (i > 0) {
            print(", ", .{});
        }
        const ch = item.key_ptr.*;
        print("{c}", .{ch});
    }
    print("\n", .{});
}

fn arrayContains(needle: u8, haystack: *const []u8) bool {
    for (haystack.*) |item| {
        if (needle == item) {
            return true;
        }
    }
    return false;
}

fn readFirstByte() !?u8 {
    const first = try stdin.readByte();
    if (first == '\r' or first == '\n') {
        return null;
    }
    while (true) {
        const byte = try stdin.readByte();
        if (byte == '\r' or byte == '\n') {
            break;
        }
    }
    return first;
}
