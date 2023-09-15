const std = @import("std");
const exit = std.os.exit;

const ada = @import("lib/ada.zig");

fn print(s: []const u8) void {
    std.debug.print("{s}\n", .{s});
}

pub fn main() !void {
    const input = "https://username:password@www.google.com:8080/pathname?query=true#hash-exists";
    const url = try ada.Url.parse(input);
    defer url.deinit();
    print(url.href());

    try url.set_hostname("example.com");
    print(url.href());
}

test "simple test" {
    const input = "https://username:password@www.google.com:8080/pathname?query=true#hash-exists";
    const url = try ada.Url.parse(input);
    defer url.deinit();
    try std.testing.expectEqualStrings(
        "https://username:password@www.google.com:8080/pathname?query=true#hash-exists",
        url.href(),
    );
    try std.testing.expectEqualStrings(
        "https:",
        url.protocol(),
    );
    try std.testing.expectEqualStrings(
        "username",
        url.username(),
    );

    const href = "https://www.yagiz.co";
    try url.set_href(href);
    url.set_hash("new-hash");
    try url.set_hostname("new-host");
    try url.set_host("changed-host:9090");
    try url.set_pathname("new-pathname");
    url.set_search("new-search");
    try url.set_protocol("wss");

    try std.testing.expectEqualStrings(
        "wss://changed-host:9090/new-pathname?new-search#new-hash",
        url.href(),
    );
}
