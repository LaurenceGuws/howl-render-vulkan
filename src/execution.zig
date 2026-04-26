//! Responsibility: implement Vulkan renderer command recording.
//! Ownership: frame command encoding and stateful pipeline state.
//! Reason: encapsulate Vulkan queue and synchronization contracts while accepting render-core draw plans.

const std = @import("std");
const render_core = @import("howl_render_core");
const types = @import("types.zig");

/// Vulkan renderer that records frame execution against the current config.
pub const Backend = struct {
    config: types.BackendConfig,
    state: types.BackendState = .cold,
    last_stats: ?render_core.PlanStats = null,

    /// Creates a ready backend with the supplied configuration.
    pub fn init(config: types.BackendConfig) Backend {
        return .{ .config = config, .state = .ready };
    }

    /// Updates the surface size used for subsequent frame execution.
    pub fn resize(self: *Backend, surface_px: render_core.PixelSize) void {
        self.config.surface_px = surface_px;
    }

    /// Records the stats for one render plan while the backend is ready.
    pub fn execute(self: *Backend, plan: render_core.RenderPlan) types.ExecuteError!void {
        if (self.state != .ready) return error.NotReady;
        self.last_stats = plan.stats();
    }

    /// Returns the backend to its cold state and clears recorded stats.
    pub fn deinit(self: *Backend) void {
        self.last_stats = null;
        self.state = .cold;
    }
};

test "backend accepts BackendConfig with PixelSize and CellSize" {
    const config: render_core.BackendConfig = .{
        .surface_px = .{ .width = 640, .height = 480 },
        .cell_px = .{ .width = 8, .height = 16 },
    };
    const backend = Backend.init(config);
    try std.testing.expectEqual(@as(u16, 640), backend.config.surface_px.width);
    try std.testing.expectEqual(@as(u16, 8), backend.config.cell_px.width);
}

test "backend execute consumes RenderPlan and records stats" {
    var backend = Backend.init(.{
        .surface_px = .{ .width = 640, .height = 480 },
        .cell_px = .{ .width = 8, .height = 16 },
    });
    const uploads = [_]render_core.AtlasUpload{
        .{ .slot = 0, .codepoint = 'A', .width = 8, .height = 16 },
    };
    const plan: render_core.RenderPlan = .{
        .surface_px = .{ .width = 640, .height = 480 },
        .cell_px = .{ .width = 8, .height = 16 },
        .grid = .{ .cols = 80, .rows = 30 },
        .atlas_uploads = &uploads,
    };
    try backend.execute(plan);
    try std.testing.expect(backend.last_stats != null);
    try std.testing.expectEqual(@as(usize, 1), backend.last_stats.?.atlas_uploads);
}

test "backend resize updates surface dimensions via PixelSize" {
    var backend = Backend.init(.{
        .surface_px = .{ .width = 640, .height = 480 },
        .cell_px = .{ .width = 8, .height = 16 },
    });
    const new_size: render_core.PixelSize = .{ .width = 1920, .height = 1080 };
    backend.resize(new_size);
    try std.testing.expectEqual(@as(u16, 1920), backend.config.surface_px.width);
    try std.testing.expectEqual(@as(u16, 1080), backend.config.surface_px.height);
}

test "backend state transitions: cold -> ready -> cold" {
    var backend = Backend.init(.{
        .surface_px = .{ .width = 640, .height = 480 },
        .cell_px = .{ .width = 8, .height = 16 },
    });
    try std.testing.expectEqual(types.BackendState.ready, backend.state);
    backend.deinit();
    try std.testing.expectEqual(types.BackendState.cold, backend.state);
}

test "backend rejects execute when not ready" {
    var backend = Backend{
        .config = .{
            .surface_px = .{ .width = 640, .height = 480 },
            .cell_px = .{ .width = 8, .height = 16 },
        },
        .state = .cold,
    };
    const plan: render_core.RenderPlan = .{
        .surface_px = .{ .width = 640, .height = 480 },
        .cell_px = .{ .width = 8, .height = 16 },
        .grid = .{ .cols = 80, .rows = 30 },
    };
    try std.testing.expectError(error.NotReady, backend.execute(plan));
}

test "backend deinit clears stats and returns to cold state" {
    var backend = Backend.init(.{
        .surface_px = .{ .width = 640, .height = 480 },
        .cell_px = .{ .width = 8, .height = 16 },
    });
    const plan: render_core.RenderPlan = .{
        .surface_px = .{ .width = 640, .height = 480 },
        .cell_px = .{ .width = 8, .height = 16 },
        .grid = .{ .cols = 80, .rows = 30 },
    };
    try backend.execute(plan);
    try std.testing.expect(backend.last_stats != null);
    backend.deinit();
    try std.testing.expectEqual(types.BackendState.cold, backend.state);
    try std.testing.expectEqual(@as(?render_core.PlanStats, null), backend.last_stats);
}
