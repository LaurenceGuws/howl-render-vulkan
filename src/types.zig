//! Responsibility: define Vulkan backend types and state contracts.
//! Ownership: BackendConfig, BackendState, ExecuteError types and their semantics.
//! Reason: provide a minimal type contract between render-core and the Vulkan renderer implementation.

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
