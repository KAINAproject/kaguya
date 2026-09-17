# WebSocket binding for MoonBit

This package is the browser transport adapter for Kaguya. It only exposes a
binary WebSocket to MoonBit; framing and payload schemas belong to
`KAINAproject/kaguya/packages/shared`.

Each binary WebSocket message is expected to contain the protobuf-encoded
`Frame` defined by the shared package. A future WebRTC DataChannel adapter can
use the same `Frame` bytes without changing the protocol layer.

The JavaScript companion uses the browser's native `WebSocket` and has no
runtime dependency on a messaging protocol library.
