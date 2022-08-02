// ┌                                                          ┐
// │  Copyright (c) 2022 NTBBloodbath. All rights reserved.   │
// │  Use of this source code is governed by a GPLv3 license  │
// │          that can be found in the LICENSE file.          │
// └                                                          ┘
const std = @import("std");

/// System paths used by Arkane.
///
/// **Fields**:
/// - `data`   : `[]u8`
/// - `config` : `[]u8`
pub const Path = struct {
    /// Data directory
    data: []u8,
    /// Configuration directory
    config: []u8,

    /// Initialize an immutable `fs.Path` structure instance and return it
    pub fn init(allocator: std.mem.Allocator) !Path {
        var system_paths = Path{
            .config = undefined,
            .data = undefined,
        };
        // Try to get paths from XDG convention environment variables first,
        // if these variables does not exist then fallback to manual detection
        var xdg_config = std.os.getenv("XDG_CONFIG_HOME");
        if (xdg_config) |cfg_path| {
            const config_dir = try std.fmt.allocPrint(allocator, "{s}/arkane", .{cfg_path});
            system_paths.config = config_dir;
        }
        var xdg_data = std.os.getenv("XDG_DATA_HOME");
        if (xdg_data) |data_path| {
            const data_dir = try std.fmt.allocPrint(allocator, "{s}/arkane", .{data_path});
            system_paths.data = data_dir;
        }

        if (system_paths.config.len == 0 or system_paths.data.len == 0) {
            var home = std.os.getenv("HOME");
            if (home) |path| {
                if (system_paths.config.len == 0) {
                    const config_dir = try std.fmt.allocPrint(allocator, "{s}/.config/arkane", .{path});
                    system_paths.config = config_dir;
                }
                if (system_paths.data.len == 0) {
                    const data_dir = try std.fmt.allocPrint(allocator, "{s}/.local/share/arkane", .{path});
                    system_paths.data = data_dir;
                }
            }
        }

        return system_paths;
    }

    /// Free memory used by `fs.Path` struct fields (`data`, `config`)
    pub fn deinit(self: *Path, allocator: std.mem.Allocator) void {
        defer allocator.free(self.config);
        defer allocator.free(self.data);
    }

    /// Create `data` and `config` directories from `fs.Path` struct
    pub fn createDirectories(self: *Path) !bool {
        std.fs.makeDirAbsolute(self.data) catch |err| {
            if (err != error.PathAlreadyExists) return err;
        };
        std.fs.makeDirAbsolute(self.config) catch |err| {
            if (err != error.PathAlreadyExists) return err;
        };
        return true;
    }

    /// Get a given path from `fs.Path` struct (`data`, `config`)
    pub fn getPath(self: *Path, comptime path: []const u8) []u8 {
        return @field(self, path);
    }
};

/// Initialize and return a new `fs.Path` struct instance and create Arkane directories
pub fn init(allocator: std.mem.Allocator) !Path {
    // Initialize a new Path instance and create required Arkane directories
    var path = try Path.init(allocator);
    _ = try path.createDirectories();

    return path;
}

test "Correct Arkane paths" {
    const allocator = std.testing.allocator;

    // Crate a new `Path` struct instance and get its fields
    var path = try Path.init(allocator);
    defer path.deinit(allocator);
    var path_data_dir = path.getPath("data");
    var path_config_dir = path.getPath("config");

    // We use fallback method ($HOME) from `Path.init()` here for compatibility checks
    // just in case user XDG environment variables does not point to correct paths
    var arkane_home_paths = Path{
        .data = undefined,
        .config = undefined,
    };
    defer allocator.free(arkane_home_paths.data);
    defer allocator.free(arkane_home_paths.config);

    var home = std.os.getenv("HOME");
    if (home) |home_path| {
        const config_dir = try std.fmt.allocPrint(allocator, "{s}/.config/arkane", .{home_path});
        arkane_home_paths.config = config_dir;

        const data_dir = try std.fmt.allocPrint(allocator, "{s}/.local/share/arkane", .{home_path});
        arkane_home_paths.data = data_dir;
    }

    try std.testing.expect(std.mem.eql(u8, arkane_home_paths.data, path_data_dir));
    try std.testing.expect(std.mem.eql(u8, arkane_home_paths.config, path_config_dir));
}

test "Create directories" {
    const allocator = std.testing.allocator;

    var path = try Path.init(allocator);
    defer path.deinit(allocator);

    try std.testing.expect(try path.createDirectories());
}
