# Howl Render Vulkan Milestone Authority

This document defines the Vulkan backend ladder.
`howl-render-vulkan` is a backend executor, not a render-policy owner.

## Milestone Ladder

| ID | Name | Outcome |
| --- | --- | --- |
| `M0` | Scaffold Reset | Repo, docs, and compile-safe stub reflect thin-backend ownership only. |
| `M1` | Backend API Contract | Vulkan backend lifecycle and render-core consumption contract are explicit. |
| `M2` | Device and Resource Lifecycle | Queue, buffer, image, and pipeline ownership is explicit and bounded. |
| `M3` | Render Plan Execution Baseline | Vulkan backend executes backend-neutral render-core plans deterministically. |
| `M4` | Text Resource Execution | Vulkan resource upload path exists without owning atlas policy. |
| `M5` | Presentation and Update Discipline | Resize and presentation boundaries are explicit at backend level. |
| `M6` | Capability Conformance | Vulkan backend proves conformance to render-core capability contract. |
| `M7` | Performance and Memory Discipline | Upload and draw cost are measured and bounded. |
| `M8` | Visual Reliability | Edge cases and driver variance are covered by evidence. |
| `M9` | Operational Surface | Diagnostics and backend failure behavior are explicit. |
| `M10` | Production Vulkan Backend | Vulkan backend is production-ready within the renderer family model. |

## Current Target

Current target is `M0` scaffold reset closure.
