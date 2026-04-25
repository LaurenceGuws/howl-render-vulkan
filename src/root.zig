const std = @import("std");

pub const InitError = error{NotImplemented};
pub const RenderError = error{NotImplemented};

pub const RendererConfig = struct {
    width_px: u16,
    height_px: u16,
};

pub const Renderer = struct {
    config: RendererConfig,

    pub fn init(config: RendererConfig) InitError!Renderer {
        _ = config;
        return error.NotImplemented;
    }

    pub fn resize(self: *Renderer, width_px: u16, height_px: u16) void {
        self.config = .{ .width_px = width_px, .height_px = height_px };
    }

    pub fn renderFrame(self: *Renderer) RenderError!void {
        _ = self;
        return error.NotImplemented;
    }

    pub fn deinit(self: *Renderer) void {
        _ = self;
    }
};

test "renderer config stores dimensions" {
    var renderer = Renderer{ .config = .{ .width_px = 800, .height_px = 600 } };
    renderer.resize(1024, 768);
    try std.testing.expectEqual(@as(u16, 1024), renderer.config.width_px);
    try std.testing.expectEqual(@as(u16, 768), renderer.config.height_px);
}
