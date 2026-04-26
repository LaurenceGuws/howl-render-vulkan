//! Responsibility: Vulkan backend scaffold.
//! Ownership: Vulkan device/resource execution only.
//! Reason: keep render policy out of backend-specific code.

const types = @import("types.zig");
const execution = @import("execution.zig");

pub const BackendConfig = types.BackendConfig;
pub const BackendState = types.BackendState;
pub const ExecuteError = types.ExecuteError;
pub const Backend = execution.Backend;
