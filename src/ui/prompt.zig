// ┌                                                          ┐
// │  Copyright (c) 2023 NTBBloodbath. All rights reserved.   │
// │  Use of this source code is governed by a GPLv3 license  │
// │          that can be found in the LICENSE file.          │
// └                                                          ┘
const std = @import("std");

/// Gets user input and saves it into a `std.ArrayList(u8)` struct.
///
/// It does not automatically free memory so you will need to `deinit` it
/// once you do not need its results anymore.
pub fn inputStr(allocator: std.mem.Allocator, ask: []const u8, comptime max_size: usize, default_value: ?[]const u8) !std.ArrayList(u8) {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();
    // Create a buffered reader so input will be automatically flushed if overflow
    const buffer = std.io.bufferedReader(stdin).reader();

    var input_array = std.ArrayList(u8).init(allocator);

    try stdout.print("{s} ", .{ask});
    buffer.readUntilDelimiterArrayList(&input_array, '\n', max_size) catch |err| {
        if (err != error.EndOfStream) return err;
    };

    // Set default value
    if (input_array.items.len == 0 and default_value != null)
        try input_array.insertSlice(0, default_value.?);

    return input_array;
}
