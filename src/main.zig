const std = @import("std");
const fs = std.fs;
const log = std.log;
const mem = std.mem;

pub fn main() !void {
    const cwd = fs.cwd();
    const plugins_dir = try cwd.openDir("/tmp/plugins", .{ .iterate = true });
    var plugins_iter = plugins_dir.iterate();
    while (try plugins_iter.next()) |entry| {
        if (!mem.endsWith(u8, entry.name, ".so")) continue;
        log.info("Found Plugin '{s}'", .{ entry.name });
        var full_path: [300:0]u8 = .{ 0 } ** 300;
        var plugin = try std.DynLib.open(try plugins_dir.realpath(entry.name, full_path[0..]));
        if (plugin.lookup(*const fn ([*:0]const u8) bool, "hello")) |hello| {
            log.info("Found `hello()`", .{});
            _ = hello("Zig");
        }
        if (plugin.lookup(*const fn () void, "simple")) |simple| {
            log.info("Found `simple()`", .{});
            simple();
        }
    }
}
