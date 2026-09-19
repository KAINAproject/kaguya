# Kaguya inspector TUI

`inspector-tui` は bridge のイベントを表示する端末UIです。

表示するのは接続状態、受信数、HMD pose、ブラウザから報告されたバッテリー、左右の有効
joint 数、sequence、最新フレームの26個のランドマーク座標、ログです。手の骨格や
ランドマークの形状は描画しません。バッテリーはブラウザの Battery Status API が利用
できない場合は `n/a` になります。

この package は WebSocket に接続しません。接続処理は bridge 側に置き、
`BridgeEvent` を `InspectorState::on_event` に渡します。

そのため、将来は同じ state/view を次のどちらからでも利用できます。

- bridge プロセス内の observer
- bridge の monitor endpoint に接続する別プロセス
