declare global {
  interface Window {
    __kaguyaXrDevice?: unknown
  }
}

type BrowserXrSystem = {
  isSessionSupported?: (mode: string) => Promise<boolean>
}

async function hasUsableWebXr(mode: string): Promise<boolean> {
  const xr = (navigator as Navigator & { xr?: BrowserXrSystem }).xr
  if (xr == null || typeof xr.isSessionSupported !== "function") return false

  try {
    return await xr.isSessionSupported(mode)
  } catch {
    return false
  }
}

export async function installXrEmulator(mode = "immersive-vr"): Promise<void> {
  if (!import.meta.env.DEV || import.meta.env.VITE_XR_EMULATOR !== "1") return
  if (await hasUsableWebXr(mode)) return

  const { XRDevice, metaQuest3 } = await import("iwer")
  const device = new XRDevice(metaQuest3)
  device.primaryInputMode = "hand"
  device.installRuntime({ forceInstall: true })
  window.__kaguyaXrDevice = device
}
