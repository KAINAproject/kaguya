import "./style.css"

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

  const render = () => {
    resizeCanvas()

    const commandEncoder = device.createCommandEncoder()
    const passEncoder = commandEncoder.beginRenderPass({
      colorAttachments: [
        {
          view: context.getCurrentTexture().createView(),
          clearValue: { r: 0.05, g: 0.08, b: 0.16, a: 1 },
          loadOp: "clear",
          storeOp: "store",
        },
      ],
    })
    passEncoder.end()
    device.queue.submit([commandEncoder.finish()])
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
