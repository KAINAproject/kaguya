import { expect, test } from "@playwright/test"

test("WebGPU example boots and reports its initialization state", async ({ page }) => {
  const pageErrors: Error[] = []
  page.on("pageerror", (error) => pageErrors.push(error))

  await page.goto("/")

  await expect(page).toHaveTitle("Kaguya WebGPU Example")
  await expect(page.locator("#canvas")).toBeVisible()
  await expect(page.locator("#enter-xr")).toBeVisible()

  const status = page.locator("#status")
  await expect(status).toHaveAttribute("data-kind", /^(success|error)$/)
  await expect(status).not.toContainText("WebGPU を初期化しています")
  expect(pageErrors).toHaveLength(0)
})

test("renders a mocked stereo WebXR frame", async ({ page }) => {
  await page.addInitScript(() => {
    const matrix = [
      1, 0, 0, 0,
      0, 1, 0, 0,
      0, 0, 1, 0,
      0, 0, 0, 1,
    ]
    const pose = {
      views: ["left", "right"].map((eye) => ({
        eye,
        projectionMatrix: matrix,
        transform: { inverse: { matrix } },
      })),
    }

    const makeTexture = () => ({
      createView: () => ({}),
      destroy: () => {},
    })
    const fakePass = {
      setPipeline: () => {},
      setBindGroup: () => {},
      setVertexBuffer: () => {},
      setViewport: () => {},
      draw: () => {},
      end: () => {},
    }
    const fakeDevice = {
      queue: { writeBuffer: () => {}, submit: () => {} },
      lost: { then: () => {} },
      requestAdapter: undefined,
      createShaderModule: () => ({}),
      createRenderPipeline: () => ({ getBindGroupLayout: () => ({}) }),
      createBuffer: () => ({}),
      createBindGroup: () => ({}),
      createTexture: () => makeTexture(),
      createCommandEncoder: () => ({
        beginRenderPass: () => fakePass,
        finish: () => ({}),
      }),
    }
    const fakeContext = {
      configure: () => {},
      getCurrentTexture: () => makeTexture(),
    }
    const fakeGpu = {
      getPreferredCanvasFormat: () => "bgra8unorm",
      requestAdapter: async (options: { xrCompatible?: boolean }) => {
        if (!options.xrCompatible) throw new Error("XR-compatible adapter was not requested")
        return { requestDevice: async () => fakeDevice }
      },
    }

    class MockXRSession {
      frameScheduled = false
      listeners: Array<() => void> = []

      addEventListener(type: string, listener: () => void) {
        if (type === "end") this.listeners.push(listener)
      }

      requestReferenceSpace() {
        return Promise.resolve({})
      }

      updateRenderState() {}

      requestAnimationFrame(callback: (time: number, frame: unknown) => void) {
        if (this.frameScheduled) return
        this.frameScheduled = true
        window.setTimeout(() => {
          callback(performance.now(), { getViewerPose: () => pose })
        }, 0)
      }
    }

    class MockXRGPUBinding {
      device: typeof fakeDevice

      constructor(_session: MockXRSession, device: typeof fakeDevice) {
        this.device = device
      }

      getPreferredColorFormat() {
        return "rgba8unorm"
      }

      createProjectionLayer() {
        return {}
      }

      getViewSubImage() {
        const colorTexture = this.device.createTexture({
          size: [64, 64],
          format: "rgba8unorm",
          usage: GPUTextureUsage.RENDER_ATTACHMENT,
        })
        const depthStencilTexture = this.device.createTexture({
          size: [64, 64],
          format: "depth24plus",
          usage: GPUTextureUsage.RENDER_ATTACHMENT,
        })
        return {
          colorTexture,
          depthStencilTexture,
          getViewDescriptor: () => ({}),
          viewport: { x: 0, y: 0, width: 64, height: 64 },
        }
      }
    }

    Object.defineProperty(globalThis, "XRGPUBinding", {
      configurable: true,
      value: MockXRGPUBinding,
    })
    Object.defineProperty(HTMLCanvasElement.prototype, "getContext", {
      configurable: true,
      value: (contextId: string) => contextId === "webgpu" ? fakeContext : null,
    })
    Object.defineProperty(navigator, "gpu", {
      configurable: true,
      value: fakeGpu,
    })
    Object.defineProperty(navigator, "xr", {
      configurable: true,
      value: {
        isSessionSupported: async () => true,
      requestSession: async (
        _mode: string,
        options: { requiredFeatures?: string[] },
      ) => {
        if (!options.requiredFeatures?.includes("webgpu")) {
          throw new Error("WebGPU XR session was not requested")
        }
        return new MockXRSession()
      },
      },
    })
  })

  const pageErrors: Error[] = []
  page.on("pageerror", (error) => pageErrors.push(error))

  await page.goto("/")
  const button = page.locator("#enter-xr")
  await expect(button).toBeEnabled()
  await button.click()

  await expect(page.locator("#status")).toContainText("WebXR session active (2 views)")
  expect(pageErrors).toHaveLength(0)
})
