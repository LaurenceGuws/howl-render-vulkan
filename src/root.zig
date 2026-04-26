//! Responsibility: Vulkan backend scaffold.
//! Ownership: Vulkan device/resource execution only.
//! Reason: keep render policy out of backend-specific code.

const std = @import("std");
const render_core = @import("howl_render_core");

pub const BackendConfig = struct {
    surface_px: render_core.PixelSize,
    cell_px: render_core.CellSize,
};

pub const BackendState = enum {
    cold,
    ready,
};

pub const ExecuteError = error{
    NotReady,
};

pub const Backend = struct {
    config: BackendConfig,
    state: BackendState = .cold,
    last_stats: ?render_core.PlanStats = null,

    pub fn init(config: BackendConfig) Backend {
        return .{ .config = config, .state = .ready };
    }

    pub fn resize(self: *Backend, surface_px: render_core.PixelSize) void {
        self.config.surface_px = surface_px;
    }

    pub fn execute(self: *Backend, plan: render_core.RenderPlan) ExecuteError!void {
        if (self.state != .ready) return error.NotReady;
        self.last_stats = plan.stats();
    }

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
