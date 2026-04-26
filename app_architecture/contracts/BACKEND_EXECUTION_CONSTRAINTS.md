# Vulkan Backend Execution Constraints

## Queue and Synchronization Ownership

- **Single queue per backend**: All GPU work submits to one presentation queue; caller manages queue selection.
- **Command buffer lifecycle**: Backend records commands into a caller-provided command buffer; recording is synchronous within `execute()`.
- **Synchronization responsibility**: Caller owns synchronization (fences, semaphores) between frames; backend does not manage GPU synchronization.
- **No swapchain management**: Backend assumes swapchain is external; does not own acquire/present logic.

## Descriptor and Update Boundaries

- **Descriptor set management**: Texture descriptors are immutable during recording; caller responsible for descriptor layout matching.
- **Resource binding constraints**: All textures must be bound before `execute()`; no dynamic rebinding during command recording.
- **Update coherency**: Buffer/texture updates from previous frames must be complete before submission; caller enforces memory barriers.

## Texture and Memory Constraints

- **Texture format: RGBA8Srgb or BGRA8Srgb**: Backend assumes sRGB colorspace; no color space conversion applied.
- **Max texture dimensions**: Subject to `VkPhysicalDeviceProperties.limits.maxImageDimension2D`.
- **Single atlas texture**: Glyph atlas must fit in one texture; overflow requires caller batching.
- **Synchronous uploads**: Texture uploads complete synchronously within `execute()`; no async staging buffers assumed.

## Pipeline State and Render Pass

- **Pipeline immutability**: Render pipeline is fixed at init; `execute()` does not change pipelines or render passes.
- **Render pass compatibility**: Render pass must be compatible with caller's framebuffer attachment format.
- **Viewport/scissor**: Backend sets viewport to surface dimensions; caller must not override during execution.
- **No dynamic state beyond viewport**: Other dynamic states (blend factors, line width) are fixed.

## Execution State Machine

- **Cold → Ready → Cold**: Synchronous transitions via `init()` and `deinit()`.
- **NotReady error**: Execution outside Ready state returns `NotReady`.
- **Stats recording**: `last_stats` captures counts from the most recent successful `execute()`.

## Vulkan Version and Device Requirements

- **Vulkan 1.0 or later**: Targets stable Vulkan core; no extension assumptions.
- **sRGB framebuffer**: Framebuffer attachment must use sRGB format for color correction.
- **No GPU synchronization primitives**: Caller provides VkFence and VkSemaphore if needed; backend does not allocate.
