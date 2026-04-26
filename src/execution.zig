//! Execution logic for howl-render-vulkan.

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

test "backend execute rejects cold state" {
    var backend = Backend{
        .config = .{
            .surface_px = .{ .width = 640, .height = 480 },
            .cell_px = .{ .width = 8, .height = 16 },
        },
        .state = .cold,
    };
    const plan = render_core.RenderPlan{
        .surface_px = .{ .width = 640, .height = 480 },
        .cell_px = .{ .width = 8, .height = 16 },
        .grid = .{ .cols = 80, .rows = 30 },
    };
    try std.testing.expectError(error.NotReady, backend.execute(plan));
}
