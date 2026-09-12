# hello-xr

WebGPU の初期化と Canvas への clear 描画を確認する最小ブラウザ example です。

## 起動

```sh
pnpm install
pnpm dev
```

表示された URL を、WebGPU 対応ブラウザで開いてください。成功すると Canvas に濃紺の clear color が描画され、下部に初期化済みの解像度が表示されます。

## 検証

```sh
pnpm build
```

`tsc --noEmit` による型チェックと、Vite の production build を実行します。
