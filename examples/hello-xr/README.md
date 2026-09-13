# hello-xr

WebGPU の初期化と、MoonBit で実装した MVP 行列付きの立方体描画を確認する最小ブラウザ example です。

## 起動

```sh
pnpm install
pnpm run setup:types
pnpm dev
```

`setup:types` は初回だけ実行してください。mizchi/ts の `mbt2ts` を `.moonbit-tools/` にインストールします。

`pnpm dev` の前に MoonBit の JS backend module と TypeScript 宣言を自動でビルドし、`.moonbit-build/` に生成します。実行時の JS module は Vite の alias 経由で、型は `mbt2ts` が生成した `.d.ts` 経由で読み込みます。MoonBit が PATH にない場合は、リポジトリルートで `nix develop` に入ってから実行してください。

表示された `https://` URL を、WebGPU 対応ブラウザで開いてください。basic SSL が生成する自己署名証明書のため、初回だけ証明書警告が表示されます。開発環境なので警告を進めると、LAN 上の別デバイスからもアクセスできます。

成功すると Canvas に濃紺背景と、色付きで回転する立方体が描画され、下部に初期化済みの解像度が表示されます。

WebXR と WebXR/WebGPU Binding に対応したブラウザでは、「VR を開始」ボタンから immersive VR session を開始できます。XR 中は各 eye の projection layer に pose の行列を使って、回転する立方体をステレオ描画します。WebXR/WebGPU Binding は実験的なブラウザ API のため、対応状況によってボタンが利用できない場合があります。

## 検証

```sh
pnpm build
pnpm exec playwright install chromium
pnpm test:e2e
```

`tsc --noEmit` による型チェック、MoonBit の JS build、Vite の production build を実行します。
`test:e2e` は Vite を起動して、Canvas の表示、WebGPU 初期化状態、ページエラーの有無を Chromium で確認します。

NixOS では `nix develop` に入ると、devShell が提供する Nix の Chromium を Playwright が使用します。Ubuntu の依存を入れる `playwright install --with-deps` は不要です。
