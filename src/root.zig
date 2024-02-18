const builtin = @import("builtin");
const std = @import("std");
const io = std.io;
const log = std.log;
const testing = std.testing;

export fn hello(recipient: [*c]const u8) callconv(.C) bool {
    if (builtin.mode == .Debug) {
        log.debug("Hello, {s} from Zig!", .{ recipient });
        return true;
    }
    const stdout = io.getStdOut().writer();
    stdout.print("Hello, {s} from Zig!\n", .{ recipient }) catch {
        log.err("Stdout Issue!", .{});
        return false;
    };
    return true;
}

export fn simple() callconv(.C) void {
    if (builtin.mode == .Debug) {
        log.debug("Simple Zig Plugin", .{});
        return;
    }
    const stdout = io.getStdOut().writer();
    stdout.print("Simple Zig Plugin\n", .{}) catch {};
}

test "hello" {
    try testing.expect(hello("world"));
}

test "simple" {
    simple();
}
