# Kaguya shared protocol

このパッケージは、通信方式に依存しない Kaguya のプロトコル定義を保持します。

- `kaguya.proto` が wire format の正本です。
- `kaguya/v1/top.mbt` は公式 `protoc-gen-mbt` から生成した wire 型と codec です。
- `protocol.mbt` は既存のドメイン型を wire 型へ変換する公開 API です。

生成コードを更新する場合は、protoc と MoonBit toolchain を用意した上で、リポジトリの
ルートから `./scripts/generate-protobuf.sh` を実行してください。generator は
`moonbitlang/protoc-gen-mbt@0.2.0`、runtime は `moonbitlang/protobuf@0.1.3` に固定しています。

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
