# Kaguya bridge core

`bridge-core` は WebSocket や TUI に依存しない、bridge の観測イベント境界です。

- `packages/shared` の wire protocol を decode する
- `BridgeEvent` と `EventSink` で接続処理と observer を分離する
- `publish_frame` で受信 bytes を decode し、失敗も `DecodeError` として通知する
- Inspector、ロボット向け connector、Foxglove 向け connector が同じイベントを購読できる

TUI の描画や外部 transport はこの package に追加しません。
