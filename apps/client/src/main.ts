import "./style.css"
import {
  kaguya_set_xr_robot_id,
  kaguya_start,
  kaguya_websocket_close,
  kaguya_websocket_open,
} from "mbt:KAINAproject/kaguya/apps/client/src"

async function start(): Promise<void> {
  const params = new URL(window.location.href).searchParams
  const robotId = params.get("robot")?.trim()
  if (robotId != null && robotId !== "") {
    kaguya_set_xr_robot_id(robotId)
  }

  await kaguya_start()

  const url = params.get("ws")
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
