# Kaguya XR application

Kaguya の XR クライアントです。MoonBit から `mizchi/three-mbt` 経由で Three.js を使い、Kaguya の WebXR adapter で `WebXRManager` と接続します。pnpm workspace のパッケージとして、リポジトリルートから起動できます。

## Zenoh transport

ブラウザからの Zenoh 接続には `@eclipse-zenoh/zenoh-ts` を使います。これは
`zenoh-bridge-remote-api` の WebSocket endpoint に接続する方式です。この bridge は
通常の Zenoh router と `remote_api` plugin をひとつの実行ファイルにまとめています。
アプリケーション側の低レベル API は
[`src/zenoh_transport.ts`](src/zenoh_transport.ts) にあります。

```ts
const transport = await ZenohTransport.open("ws://127.0.0.1:10000")
await transport.publish(keyExpr, protobufBytes)
const subscription = await transport.subscribe(keyExpr, ({ payload }) => {
  // packages/shared の decode_* に payload を渡す
})
```

動作確認だけなら、locator を URL query に指定してクライアントを起動できます。

```text
https://<client-host>:5173/?zenoh=ws://<bridge-host>:10000
```

接続後の publish/subscribe は `src/zenoh_transport.ts` の `ZenohTransport` を
利用します。アプリの起動時に locator がない場合は Zenoh 接続を行いません。

Nix 環境では、リポジトリルートの `pnpm dev` が Vite と bridge を同時に起動します。
`direnv` を使っていない場合は、先に `nix develop` に入ってください。

bridge の bind address やポートを変更する場合は、次の環境変数を設定できます。

```sh
ZENOH_BRIDGE_LISTEN=tcp/0.0.0.0:7447 \
ZENOH_BRIDGE_WS_PORT=0.0.0.0:10000 \
pnpm dev
```

bridge だけを手動で起動する場合は、次のコマンドを使えます。

```sh
nix run .#zenoh-bridge-remote-api -- \
  --mode peer \
  --listen tcp/0.0.0.0:7447 \
  --ws-port 0.0.0.0:10000
```

この設定は認証なしで LAN に Zenoh と WebSocket を公開する開発用設定です。インター
ネット側へポートを公開しないでください。本番または HTTPS クライアントから使う
場合は bridge の `--cert` / `--key` を設定し、`wss://` locator を使います。

bridge はサーバーと同一である必要はありません。クライアントから到達できる任意の
LAN 上の bridge を locator に指定できます。制御 PC と bridge とアプリケーション
サーバーは、必要に応じて同じマシンにも別マシンにも配置できます。現在の開発用クライアントは
WebXR のため HTTPS で起動するので、実機ブラウザからは HTTPS/WSS の組み合わせを
使う構成を推奨します。`ws://` は混在コンテンツ制限に注意してください。

このアプリでの担当範囲は次の通りです。

- Three.js: scene graph、`WebGLRenderer`、XR camera、frame loop、projection layer、controller pose
- Kaguya: WebXR session の開始、`WebXRManager` binding、controller event、XR interaction
- MoonBit application code: Cube の表示、Raycaster による hover、select による grab/release、画面の状態表示

Kaguya 自身が WebGL/WebGPU renderer を実装する構成ではありません。現在のブラウザ統合は Three.js の WebGL renderer を使います。

## 起動

MoonBit が PATH にない場合は、先にリポジトリルートで `nix develop` に入ってください。

```sh
# リポジトリルートで実行。Vite と Zenoh bridge を起動する
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
