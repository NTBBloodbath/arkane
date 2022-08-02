// ┌                                                          ┐
// │  Copyright (c) 2022 NTBBloodbath. All rights reserved.   │
// │  Use of this source code is governed by a GPLv3 license  │
// │          that can be found in the LICENSE file.          │
// └                                                          ┘
const std = @import("std");
const clap = @import("clap");

const fs = @import("fs.zig");
const prompt = @import("ui/prompt.zig");

const version = "0.1.0a";

pub fn main() anyerror!void {
    // Standard output/err
    const stdout = std.io.getStdOut().writer();
    const stderr = std.io.getStdErr().writer();

    // Create an arena allocator to reduce time spent allocating
    // and freeing memory during runtime.
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    var allocator = arena.allocator();

    // Cmdline
    // ------------
    const params = comptime clap.parseParamsComptime(
        \\-h, --help     Display this help and exit.
        \\-v, --version  Display Arkane version and exit.
        \\
    );
    var diag = clap.Diagnostic{};
    var res = clap.parse(clap.Help, &params, clap.parsers.default, .{
        .diagnostic = &diag,
    }) catch |err| {
        // Report useful error and exit
        diag.report(stderr, err) catch {};
        return err;
    };
    defer res.deinit();

    if (res.args.help) {
        try stdout.print("Usage: arkane [options]\n\nOptions:\n", .{});
        return clap.help(stdout, clap.Help, &params, .{});
    }
    if (res.args.version)
        try stdout.print("Arkane v{s} by NTBBloodbath\n", .{version});

    // Main logic
    // ------------
    //
    // Initialize Arkane fs module and create required directories
    // like `~/.config/arkane`.
    var arkane_paths = try fs.init(allocator);
    defer arkane_paths.deinit(allocator);

    // TODO: implement `state.zig` and `config.zig` modules so we can
    // actually use `arkane_paths` struct.
}
