const std = @import("std");
const print = std.debug.print;
const io = std.io;
const fs = std.fs;
const ArrayList = std.ArrayList;
const stdin = std.io.getStdIn().reader();

pub fn main() !void {
    print("\n=== Hangman ===\n", .{});

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var words = ArrayList(ArrayList(u8)).init(allocator);
    defer words.deinit();
    defer for (words.items) |item| {
        item.deinit();
    };

    {
        // assume LF
        const file = try fs.cwd().openFile("words.txt", .{});
        defer file.close();
        try readFileLines(file, &words, allocator);
    }
    if (words.items.len < 1) {
        return error.EmptyFile;
    }

    var seed: u64 = undefined;
    try std.os.getrandom(std.mem.asBytes(&seed));
    var prng = std.rand.DefaultPrng.init(seed);
    const rand = prng.random();

    var correct = ArrayList(u8).init(allocator);
    defer correct.deinit();
    var incorrect = ArrayList(u8).init(allocator);
    defer incorrect.deinit();

    while (true) {
        const index = rand.intRangeAtMost(usize, 0, words.items.len - 1);
        const word = words.items[index];
        print("Secret word: {s}\n", .{word.items});

        correct.clearRetainingCapacity();
        incorrect.clearRetainingCapacity();

        try correct.appendSlice("aeiou");

        while (true) {
            var show = try ArrayList(u8).initCapacity(allocator, word.items.len);
            defer show.deinit();
            for (word.items) |char| {
                var new_char =
                    if (arrayContains(char, &correct.items)) char else '_';
                try show.append(new_char);
            }

            if (std.mem.eql(u8, show.items, word.items)) {
                print("\n========\n   WIN\n========\n", .{});
                break;
            }

            print("\n{s}\nChances: {}\nCorrect: {s}\nIncorrect: {s}\nGuess: ", .{
                show.items,
                6 - incorrect.items.len,
                correct.items,
                incorrect.items,
            });

            // read one byte
            // stdin buffer is not flushed until newline
            var guess = try stdin.readByte();
            _ = try stdin.readByte(); // discard newline character

            if (arrayContains(guess, &word.items)) {
                print("correct!\n", .{});
                if (!arrayContains(guess, &correct.items)) {
                    print("(new)\n", .{});
                    try correct.append(guess);
                }
            } else {
                print("incorrect!\n", .{});
                if (!arrayContains(guess, &incorrect.items)) {
                    print("(new)\n", .{});
                    try incorrect.append(guess);
                }
            }

            if (incorrect.items.len >= 6) {
                print("\n========\n  LOSS\n  The word was '{s}'\n========\n", .{word.items});
                break;
            }
        }
    }
}

fn arrayContains(needle: u8, haystack: *const []u8) bool {
    for (haystack.*) |item| {
        if (needle == item) {
            return true;
        }
    }
    return false;
}

fn readFileLines(file: fs.File, list: *ArrayList(ArrayList(u8)), allocator: anytype) !void {
    var buf_reader = io.bufferedReader(file.reader());
    const reader = buf_reader.reader();

    var line = ArrayList(u8).init(allocator);
    const writer = line.writer();

    while (reader.streamUntilDelimiter(writer, '\n', null)) {
        defer line.clearRetainingCapacity();

        var string = ArrayList(u8).init(allocator);
        try string.appendSlice(line.items);
        try list.append(string);
    } else |err| switch (err) {
        error.EndOfStream => {},
        else => return err,
    }
}
