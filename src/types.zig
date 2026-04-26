//! Type definitions for howl-render-vulkan.

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
