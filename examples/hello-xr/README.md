# hello-xr

WebGPU の初期化と Canvas への clear 描画を確認する最小ブラウザ example です。

## 起動

```sh
pnpm install
pnpm dev
```

表示された `https://` URL を、WebGPU 対応ブラウザで開いてください。basic SSL が生成する自己署名証明書のため、初回だけ証明書警告が表示されます。開発環境なので警告を進めると、LAN 上の別デバイスからもアクセスできます。

成功すると Canvas に濃紺の clear color が描画され、下部に初期化済みの解像度が表示されます。

## 検証

```sh
pnpm build
```

`tsc --noEmit` による型チェックと、Vite の production build を実行します。
