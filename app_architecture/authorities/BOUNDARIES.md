# Howl Render Vulkan Boundary Authority

## Hard Boundaries

- Consume render-core public API only.
- Own Vulkan execution details only.
- Import no host toolkit, session, or surface runtime internals.

## Forbidden Coupling

- No frame-to-plan interpretation logic.
- No atlas or batching policy ownership.
- No host event, window, or platform-app logic in backend code.
