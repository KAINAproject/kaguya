import "./style.css"
import { webgpuImports } from "./webgpu-ffi"

type MoonBitRenderer = {
  kaguya_render_clear(device: GPUDevice, context: GPUCanvasContext): void
}

const canvasElement = document.querySelector<HTMLCanvasElement>("#canvas")
const statusElement = document.querySelector<HTMLElement>("#status")

if (!canvasElement || !statusElement) {
  throw new Error("Canvas または status element が見つかりません")
}

const canvas = canvasElement
const status = statusElement

function setStatus(message: string, kind: "info" | "success" | "error" = "info") {
  status.textContent = message
  status.dataset.kind = kind
}

function resizeCanvas() {
  const pixelRatio = window.devicePixelRatio || 1
  const width = Math.max(1, Math.floor(canvas.clientWidth * pixelRatio))
  const height = Math.max(1, Math.floor(canvas.clientHeight * pixelRatio))

  if (canvas.width !== width) {
    canvas.width = width
  }
  if (canvas.height !== height) {
    canvas.height = height
  }
}

async function initializeWebGPU() {
  if (!navigator.gpu) {
    throw new Error("このブラウザでは WebGPU が利用できません")
  }

  setStatus("WebGPU adapter を取得しています…")
  const adapter = await navigator.gpu.requestAdapter()
  if (!adapter) {
    throw new Error("WebGPU adapter を取得できませんでした")
  }

  setStatus("WebGPU device を取得しています…")
  const device = await adapter.requestDevice()
  const context = canvas.getContext("webgpu")
  if (!context) {
    throw new Error("Canvas の WebGPU context を取得できませんでした")
  }

  context.configure({
    device,
    format: navigator.gpu.getPreferredCanvasFormat(),
    alphaMode: "opaque",
  })

  setStatus("MoonBit renderer をロードしています…")
  const wasmResponse = await fetch("/kaguya.wasm")
  if (!wasmResponse.ok) {
    throw new Error(`MoonBit renderer を取得できませんでした (${wasmResponse.status})`)
  }
  const { instance } = await WebAssembly.instantiateStreaming(wasmResponse, {
    webgpu: webgpuImports,
  })
  const renderer = instance.exports as unknown as MoonBitRenderer

  const render = () => {
    resizeCanvas()
    renderer.kaguya_render_clear(device, context)
  }

  render()
  window.addEventListener("resize", render)
  setStatus(`WebGPU initialized (${canvas.width} × ${canvas.height})`, "success")

  device.lost.then((info) => {
    if (info.reason !== "destroyed") {
      setStatus(`WebGPU device lost: ${info.message || info.reason}`, "error")
    }
  })
}

initializeWebGPU().catch((error: unknown) => {
  const message = error instanceof Error ? error.message : String(error)
  setStatus(message, "error")
})
