# Kaguya WebSocket bridge transport

`websocket-bridge` は native WebSocket server と `bridge-core` の adapter です。

- binary message を `bridge-core.publish_frame` に渡す
- 接続、切断、decode error を `BridgeEvent` として通知する
- Inspector や特定の外部 connector には依存しない

WebSocket endpoint は `/ws` です。`/ws` 以外の HTTP path は `404 Not Found` になります。

```moonbit no-check
let bus = @bridge.EventBus::new()
bus.subscribe(fn(event) { /* inspector / robot connector */ })
@transport.serve("127.0.0.1:9001", bus)
```

既存の `packages/websocket-mbt` は browser の JavaScript WebSocket binding として
そのまま分離しています。
