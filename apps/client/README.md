# Kaguya XR application

Kaguya の XR クライアントです。MoonBit から `mizchi/three-mbt` 経由で Three.js を使い、Kaguya の WebXR adapter で `WebXRManager` と接続します。pnpm workspace のパッケージとして、リポジトリルートから起動できます。

## WebSocket transport

ブラウザからの通信は、標準 `WebSocket` で自前の protobuf protocol endpoint に接続します。
外部のメッセージングライブラリはブラウザに持ち込みません。

wire format の正本は [`packages/shared/kaguya.proto`](../../packages/shared/kaguya.proto) で、
MoonBit の [`packages/shared/protocol.mbt`](../../packages/shared/protocol.mbt) が
`Frame` と `Envelope` の encode/decode を担当します。WebSocket binding は binary frame を
運ぶだけです。

```moonbit
async fn open_example(url : String) -> Unit {
  let connection = @websocket.Connection::open(url, fn(bytes) {
    match @protocol.decode_frame(bytes) {
      Ok(frame) => @core.log(frame.topic())
      Err(error) => @core.log(error)
    }
  })
  connection.send(
    @protocol.encode_frame(
      @protocol.Frame::subscribe("kaguya/v1/atlas/output/joint_state"),
    ),
  )
}
```

動作確認だけなら、WebSocket URL を `ws` query に指定してクライアントを起動できます。

```text
https://<client-host>:5173/?ws=ws://<server-host>:10000/ws&robot=atlas
```

接続後の通信は `Frame::publish` / `Frame::subscribe` などを protobuf bytes にして送ります。
現在の WebSocket binding は transport としての接続・送受信だけを担当し、将来の WebRTC
DataChannel でも同じ `Frame` bytes を再利用できるようにしています。

`ws` query で接続した状態で XR セッションを開始すると、client は Three.js の XR frame
loop から次の input topic をリアルタイム publish します。

- `kaguya/v1/atlas/input/head_pose`
- `kaguya/v1/atlas/input/controller_snapshot`
- `kaguya/v1/atlas/input/hand_pose`

各 envelope の `encoding` は `Protobuf` で、payload は対応する `*Record` です。手 tracking
は `"hand-tracking"` が利用できる環境で有効になり、対応する手について WebXR の 26
関節を `hand_pose` に含めます。WebSocket の送信キューが 512 KiB を超えた場合は、その
frame の publish を捨てて送信キューの回復を待ちます。
robot ID の既定値は `atlas` で、URL の `robot` query で変更できます。

このアプリでの担当範囲は次の通りです。

- Three.js: scene graph、`WebGLRenderer`、XR camera、frame loop、projection layer、controller pose
- Kaguya: WebXR session の開始、`WebXRManager` binding、controller/hand event、XR interaction
- MoonBit application code: Cube の表示、Raycaster による hover、select による grab/release、XR input の protobuf publish、画面の状態表示

Kaguya 自身が WebGL/WebGPU renderer を実装する構成ではありません。現在のブラウザ統合は Three.js の WebGL renderer を使います。

## 起動

MoonBit が PATH にない場合は、先にリポジトリルートで `nix develop` に入ってください。

```sh
# リポジトリルートで実行。Vite を起動する
pnpm install
pnpm dev
```

ルートの `pnpm dev` はこのクライアントを起動します。クライアントディレクトリから直接起動する場合は、`pnpm dev` も利用できます。

`mbt2ts` は `pnpm install` ではなく、`pnpm dev` と `pnpm build` の実行時に必要な場合だけ `mizchi/ts` から `.moonbit-tools/` へ自動インストールされます。

`pnpm dev` の前に MoonBit の JS backend module と TypeScript 宣言を自動でビルドし、`.moonbit-build/` に生成します。実行時の JS module は Vite の alias 経由で、型は `mbt2ts` が生成した `.d.ts` 経由で読み込みます。

表示された `https://` URL を、WebGL2 と WebXR に対応したブラウザで開いてください。basic SSL が生成する自己署名証明書のため、初回だけ証明書警告が表示されます。開発環境なので警告を進めると、LAN 上の別デバイスからもアクセスできます。

成功すると Canvas に濃紺背景と、色付きで回転する立方体が描画されます。

XR ボタンの下にある Interaction パネルでは、準備中・コントローラー待ち・Cube への hover・grab 中・配置完了の状態を確認できます。XR セッション中は、使用中のコントローラーの左右も表示されます。

three.js の `WebXRManager` が XR カメラ、フレームループ、projection layer、コントローラーの座標更新を管理します。Kaguya 側は session の開始と controller イベントを扱います。

## 検証

```sh
# リポジトリルートで実行
pnpm build
pnpm --filter @kaguya/client exec playwright install chromium
pnpm test:e2e
```

`tsc --noEmit` による型チェック、MoonBit の JS build、Vite の production build を実行します。
`test:e2e` は Vite を起動して、Canvas の表示、Three.js 初期化状態、ページエラーの有無を Chromium で確認します。

NixOS では `nix develop` に入ると、devShell が提供する Nix の Chromium を Playwright が使用します。Ubuntu の依存を入れる `playwright install --with-deps` は不要です。
