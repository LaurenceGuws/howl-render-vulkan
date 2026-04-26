//! Responsibility: Vulkan backend scaffold.
//! Ownership: Vulkan device/resource execution only.
//! Reason: keep render policy out of backend-specific code.

const types = @import("types.zig");
const execution = @import("execution.zig");

/// Backend configuration shared with render-core and the host.
pub const BackendConfig = types.BackendConfig;
/// Current lifecycle state for a Vulkan backend instance.
pub const BackendState = types.BackendState;
/// Errors returned while executing a Vulkan backend frame.
pub const ExecuteError = types.ExecuteError;
/// Stateful Vulkan renderer that tracks configuration and execution state.
pub const Backend = execution.Backend;
