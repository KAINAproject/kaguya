import "./style.css"
import {
  kaguya_start,
  kaguya_zenoh_close,
  kaguya_zenoh_open,
} from "@kaguya/runtime"

async function start(): Promise<void> {
  await kaguya_start()

  const locator = new URL(window.location.href).searchParams.get("zenoh")
  if (locator == null || locator === "") return

  try {
    await kaguya_zenoh_open(locator)
    console.info(`Kaguya Zenoh connected: ${locator}`)
  } catch (error: unknown) {
    console.error(`Kaguya Zenoh connection failed: ${locator}`, error)
  }
}

window.addEventListener("pagehide", () => {
  void kaguya_zenoh_close()
})

start().catch((error: unknown) => {
  console.error("Kaguya initialization failed", error)
})
