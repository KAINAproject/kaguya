# Kaguya shared protocol

このパッケージは、通信方式に依存しない Kaguya のプロトコル定義を保持します。

- `kaguya.proto` が wire format の正本です。
- `protocol.mbt` は MoonBit 側のドメイン型と codec の公開 API です。
- `protobuf.mbt` は初期プロトコルに必要な protobuf wire type の手書き実装です。

WebSocket の binary message には `Frame` を使います。`Frame` は topic と操作種別を持ち、
publish/data のときだけ `Envelope` を内包します。transport はこの package の bytes API
に依存し、プロトコル層は特定の transport を import しません。

現在の codec は次を扱います。

- `Envelope`
- `HeadPose` / `HeadPoseRecord`
- `ControllerSnapshot` / `ControllerSnapshotRecord`
- `HandPose` / `HandPoseRecord`
- `JointStateOutput` / `JointStateOutputRecord`
- `DeviceDataTimestamp`

Topic は `kaguya/v1/{robot_id}/...` をルートにします。

- `input/controller_snapshot`
- `input/head_pose`
- `input/hand_pose`
- `output/joint_state`
- `output/rgb`
- `state/{name}`、`event/{name}`、`debug/{name}`

画像も独立した transport にはせず、`Envelope` の protobuf bytes として扱います。
`Envelope.encoding` に `Jpeg` または `Webp` を設定し、`output/rgb` に publish します。

未知の field は読み飛ばすため、追加フィールドを含む将来の packet を古いクライアントが受信できます。
protobuf のフィールド番号は再利用しないでください。

このパッケージは WebSocket、WebRTC などの transport を直接 import しません。transport
adapter は別 package からこの package の `Bytes` API を利用します。
