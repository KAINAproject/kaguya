# Kaguya shared protocol

このパッケージは、通信方式に依存しない Kaguya のプロトコル定義を保持します。

- `kaguya.proto` が wire format の正本です。
- `protocol.mbt` は MoonBit 側のドメイン型と codec の公開 API です。
- `protobuf.mbt` は初期プロトコルに必要な protobuf wire type の手書き実装です。

現在の codec は次を扱います。

- `Envelope`
- `HmdPose`
- `JointState`

未知の field は読み飛ばすため、追加フィールドを含む将来の packet を古いクライアントが受信できます。
protobuf のフィールド番号は再利用しないでください。

このパッケージは Zenoh、WebSocket、WebRTC などの transport を直接 import しません。transport adapter は別 package からこの package の `Bytes` API を利用します。

