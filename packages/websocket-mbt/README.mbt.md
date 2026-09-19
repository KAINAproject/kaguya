# WebSocket binding for MoonBit

This package is the browser transport adapter for Kaguya. It exposes a
reconnecting binary WebSocket to MoonBit; framing and payload schemas belong to
`KAINAproject/kaguya/packages/shared`.

Each binary WebSocket message is expected to contain the protobuf-encoded
`Frame` defined by the shared package. A future WebRTC DataChannel adapter can
use the same `Frame` bytes without changing the protocol layer.

The JavaScript companion owns the browser WebSocket lifecycle. It reconnects
with exponential backoff after a connection closes, and `Connection::close`
stops the lifecycle permanently. It has no runtime dependency on a messaging
protocol library.
