# kaguya

MoonBit XR application for humanoid development, built on Three.js.

Kaguya is a MoonBit XR application designed for humanoid development and applications connected to physics simulators such as MuJoCo. It uses Three.js for the browser-side scene and rendering stack, with Kaguya-specific WebXR and interaction behavior around it.

The current repository is intentionally a thin application layer rather than a standalone rendering engine. MoonBit application code uses `mizchi/three-mbt` to access Three.js, while Kaguya provides the WebXR adapter and the application-specific XR behavior around it.

## Responsibilities

Kaguya currently owns:

- WebXR session start and lifecycle handling
- MoonBit bindings for Three.js `WebXRManager`
- controller and hand tracking, including pinch events
- XR interaction and humanoid-oriented application logic

Three.js, accessed through `mizchi/three-mbt`, owns:

- scene graph and object model
- WebGL rendering
- XR camera and frame loop
- projection layer setup
- controller pose updates

Kaguya is not currently a replacement for Three.js, nor does it provide its own direct WebGL/WebGPU implementation. The former standalone WebGPU FFI and renderer are not part of the current architecture.

## Current architecture

```text
MoonBit XR application
├── Kaguya application and interaction logic
├── Kaguya WebXR adapter
│   └── WebXRManager bindings
└── mizchi/three-mbt
    └── Three.js
        ├── WebGLRenderer
        ├── scene graph
        └── WebXRManager
```

The browser boundary is therefore:

```text
MoonBit application
├── shared protobuf protocol
├── native WebSocket transport adapter
└── mizchi/three-mbt / Kaguya adapter → Three.js → WebGL / WebXR
```

The bridge-side packages keep transport and inspection separate:

```text
packages/shared             protobuf wire protocol
packages/bridge-core        decoded BridgeEvent + EventBus
packages/websocket-bridge   native WebSocket → bridge-core adapter
packages/inspector-tui      BridgeEvent observer and TUI view
packages/websocket-mbt      browser WebSocket binding
```

`inspector-tui` displays connection state, receive metrics, joint validity
counts, sequence numbers, and logs. It does not draw hand skeletons or
landmarks.

The [browser client](apps/client/README.md) is the main application for this repository.

## 開発

開発環境には MoonBit、Node.js、pnpm が必要です。Nix を利用する場合は、まず devShell に入ります。

```sh
nix develop
pnpm install
pnpm dev
```

現在の `pnpm dev` はブラウザアプリを起動します。pnpm workspace を使っているため、依存関係のインストールとコマンドはリポジトリルートから実行できます。

`mbt2ts` は `pnpm dev` または `pnpm build` の実行時に必要な場合だけ `.moonbit-tools/` へ自動インストールされます。

## Bridge Inspector TUI

ネイティブ側で WebSocket の protobuf frame を確認する TUI は、次のコマンドで起動できます。

```sh
moon run --target native ./apps/inspector
```

デフォルトでは `127.0.0.1:9001` で WebSocket を待ち受けます。待受先を変更する場合はアドレスを引数に渡します。

```sh
moon run --target native ./apps/inspector -- 0.0.0.0:9001
```

TUI は `q`、`Ctrl-C`、または `Esc` で終了します。画面は約1秒ごとに更新され、ログ、受信 frame 数、hand pose 数、decode error 数、左右 hand の valid joint 数と sequence を表示します。
