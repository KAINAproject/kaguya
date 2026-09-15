# kaguya

WebXR Framework for Humanoid Development, Written in Moonbit.

Kaguya is designed to serve as the XR layer on top of physics simulators like MuJoCo by handling the VR-specific parts of the stack, including stereo rendering, hand retargeting, spatial interaction, and in-headset control interfaces.

## Backend support

The current WebGPU FFI implementation targets MoonBit's JavaScript backend. WebAssembly (WASM) support is planned for a future release.

## 開発

開発環境には MoonBit、Node.js、pnpm が必要です。Nix を利用する場合は、まず devShell に入ります。

```sh
nix develop
pnpm install
pnpm dev
```

現在の `pnpm dev` は `examples/hello-xr` を起動します。pnpm workspace を使っているため、依存関係のインストールとコマンドはリポジトリルートから実行できます。

`mbt2ts` は `pnpm dev` または `pnpm build` の実行時に必要な場合だけ `.moonbit-tools/` へ自動インストールされます。
