//! Type definitions for howl-render-vulkan.

const render_core = @import("howl_render_core");

/// Configuration for a Vulkan backend instance.
pub const BackendConfig = struct {
    surface_px: render_core.PixelSize,
    cell_px: render_core.CellSize,
};

/// Lifecycle state for a Vulkan backend instance.
pub const BackendState = enum {
    cold,
    ready,
};

/// Errors returned by Vulkan frame execution.
pub const ExecuteError = error{
    NotReady,
};
