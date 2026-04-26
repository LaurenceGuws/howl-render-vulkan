# Howl Render Vulkan Scope Authority

Purpose: define what `howl-render-vulkan` owns and what it does not own.

## In Scope

- Vulkan backend lifecycle and resource ownership
- consumption of backend-neutral render-core plans
- deterministic backend-local tests and validation evidence

## Out of Scope

- frame interpretation and render policy ownership
- host, session, or surface lifecycle ownership
- compatibility, fallback, or workaround paths
