import "./style.css"
import { kaguya_start, kaguya_websocket_close, kaguya_websocket_open } from "@kaguya/runtime"

async function start(): Promise<void> {
  await kaguya_start()

  const url = new URL(window.location.href).searchParams.get("ws")
  if (url == null || url === "") return

  try {
    await kaguya_websocket_open(url)
    console.info(`Kaguya WebSocket connected: ${url}`)
  } catch (error: unknown) {
    console.error(`Kaguya WebSocket connection failed: ${url}`, error)
  }
}

window.addEventListener("pagehide", () => {
  kaguya_websocket_close()
})

start().catch((error: unknown) => {
  console.error("Kaguya initialization failed", error)
})
