const std = @import("std");

const c = @cImport({
    @cInclude("ada_c.h");
});

pub const ParseError = error.ParseError;

pub const Url = struct {
    url: c.ada_url,

    pub fn parse(input: []const u8) !Url {
        const url = c.ada_parse(input.ptr, input.len);
        if (!c.ada_is_valid(url)) {
            return ParseError;
        }
        return Url{ .url = url };
    }

    pub fn deinit(url: Url) void {
        c.ada_free(url.url);
    }

    pub fn href(url: Url) []const u8 {
        return as_string(c.ada_get_href(url.url));
    }

    pub fn set_href(url: Url, s: []const u8) !void {
        return must(c.ada_set_href(url.url, s.ptr, s.len));
    }

    pub fn hash(url: Url) []const u8 {
        return as_string(c.ada_get_hash(url.url));
    }

    pub fn set_hash(url: Url, s: []const u8) void {
        c.ada_set_hash(url.url, s.ptr, s.len);
    }

    pub fn protocol(url: Url) []const u8 {
        return as_string(c.ada_get_protocol(url.url));
    }

    pub fn set_protocol(url: Url, s: []const u8) !void {
        return must(c.ada_set_protocol(url.url, s.ptr, s.len));
    }

    pub fn username(url: Url) []const u8 {
        return as_string(c.ada_get_username(url.url));
    }

    pub fn set_username(url: Url, s: []const u8) !void {
        return must(c.ada_set_username(url.url, s.ptr, s.len));
    }

    pub fn hostname(url: Url) []const u8 {
        return as_string(c.ada_get_hostname(url.url));
    }

    pub fn set_hostname(url: Url, s: []const u8) !void {
        return must(c.ada_set_hostname(url.url, s.ptr, s.len));
    }

    pub fn host(url: Url) []const u8 {
        return as_string(c.ada_get_host(url.url));
    }

    pub fn set_host(url: Url, s: []const u8) !void {
        return must(c.ada_set_host(url.url, s.ptr, s.len));
    }

    pub fn pathname(url: Url) []const u8 {
        return as_string(c.ada_get_pathname(url.url));
    }

    pub fn set_pathname(url: Url, s: []const u8) !void {
        return must(c.ada_set_pathname(url.url, s.ptr, s.len));
    }

    pub fn search(url: Url) []const u8 {
        return as_string(c.ada_get_search(url.url));
    }

    pub fn set_search(url: Url, s: []const u8) void {
        c.ada_set_search(url.url, s.ptr, s.len);
    }
};

fn must(b: bool) !void {
    if (!b) {
        return ParseError;
    }
}

fn as_string(s: c.ada_string) []const u8 {
    return s.data[0..s.length];
}
