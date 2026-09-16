# kaguya

MoonBit XR application for humanoid development, built on Three.js.

Kaguya is a MoonBit XR application designed for humanoid development and applications connected to physics simulators such as MuJoCo. It uses Three.js for the browser-side scene and rendering stack, with Kaguya-specific WebXR and interaction behavior around it.

The current repository is intentionally a thin application layer rather than a standalone rendering engine. MoonBit application code uses `mizchi/three-mbt` to access Three.js, while Kaguya provides the WebXR adapter and the application-specific XR behavior around it.

## Responsibilities

Kaguya currently owns:

- WebXR session start and lifecycle handling
- MoonBit bindings for Three.js `WebXRManager`
- controller connection and select events
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
MoonBit → mizchi/three-mbt / Kaguya adapter → Three.js → WebGL / WebXR
```

The [browser application](app/README.md) is the main application for this repository.

## 開発

開発環境には MoonBit、Node.js、pnpm が必要です。Nix を利用する場合は、まず devShell に入ります。

```sh
nix develop
pnpm install
pnpm dev
```

現在の `pnpm dev` はブラウザアプリを起動します。pnpm workspace を使っているため、依存関係のインストールとコマンドはリポジトリルートから実行できます。

`mbt2ts` は `pnpm dev` または `pnpm build` の実行時に必要な場合だけ `.moonbit-tools/` へ自動インストールされます。
