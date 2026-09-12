# hello-xr

WebGPU の初期化と、MoonBit で実装した Canvas への clear 描画を確認する最小ブラウザ example です。

## 起動

```sh
pnpm install
pnpm dev
```

`pnpm dev` の前に MoonBit の JS backend module を自動でビルドし、`.moonbit-build/` に生成された module を Vite の alias 経由で読み込みます。MoonBit が PATH にない場合は、リポジトリルートで `nix develop` に入ってから実行してください。

表示された `https://` URL を、WebGPU 対応ブラウザで開いてください。basic SSL が生成する自己署名証明書のため、初回だけ証明書警告が表示されます。開発環境なので警告を進めると、LAN 上の別デバイスからもアクセスできます。

成功すると Canvas に濃紺の clear color が描画され、下部に初期化済みの解像度が表示されます。

## 検証

```sh
pnpm build
```

`tsc --noEmit` による型チェック、MoonBit の JS build、Vite の production build を実行します。
