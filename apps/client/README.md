# Kaguya XR application

Kaguya の XR クライアントです。MoonBit から `mizchi/three-mbt` 経由で Three.js を使い、Kaguya の WebXR adapter で `WebXRManager` と接続します。pnpm workspace のパッケージとして、リポジトリルートから起動できます。

このアプリでの担当範囲は次の通りです。

- Three.js: scene graph、`WebGLRenderer`、XR camera、frame loop、projection layer、controller pose
- Kaguya: WebXR session の開始、`WebXRManager` binding、controller event、XR interaction
- MoonBit application code: Cube の表示、Raycaster による hover、select による grab/release、画面の状態表示

Kaguya 自身が WebGL/WebGPU renderer を実装する構成ではありません。現在のブラウザ統合は Three.js の WebGL renderer を使います。

## 起動

MoonBit が PATH にない場合は、先にリポジトリルートで `nix develop` に入ってください。

```sh
# リポジトリルートで実行
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
