import "./style.css"
import { kaguya_start } from "@kaguya/runtime"
import type { ZenohTransport } from "./zenoh_transport"

let activeZenohTransport: ZenohTransport | undefined

async function start(): Promise<void> {
  await kaguya_start()

  const locator = new URL(window.location.href).searchParams.get("zenoh")
  if (locator == null || locator === "") return

  try {
    const { openZenohTransport } = await import("./zenoh_transport")
    activeZenohTransport = await openZenohTransport(locator)
    console.info(`Kaguya Zenoh connected: ${locator}`)
  } catch (error: unknown) {
    console.error(`Kaguya Zenoh connection failed: ${locator}`, error)
  }
}

window.addEventListener("pagehide", () => {
  void activeZenohTransport?.close()
})

start().catch((error: unknown) => {
  console.error("Kaguya initialization failed", error)
})
