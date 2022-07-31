const std = @import("std");
const clap = @import("clap");

const version = "0.1.0a";
const version_str = std.fmt.comptimePrint("Arkane v{s} by NTBBloodbath", .{version});

pub fn main() anyerror!void {
    // Standard input/output/err
    const stdout = std.io.getStdOut().writer();
    const stderr = std.io.getStdErr().writer();
    // const stdio = std.io.getStdIn().reader();

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
        try stdout.print("{s}\n", .{version_str});
}
