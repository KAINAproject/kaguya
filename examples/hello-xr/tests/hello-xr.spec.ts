import { expect, test } from "@playwright/test"

test("WebGPU example boots and reports its initialization state", async ({ page }) => {
  const pageErrors: Error[] = []
  page.on("pageerror", (error) => pageErrors.push(error))

  await page.goto("/")

  await expect(page).toHaveTitle("Kaguya WebGPU Example")
  await expect(page.locator("#canvas")).toBeVisible()
  await expect(page.locator("#enter-xr")).toBeVisible()
  await expect(page.locator("#interaction")).toBeVisible()
  await expect(page.locator("#interaction")).toHaveAttribute(
    "data-state",
    /^(ready|error)$/,
  )
  await expect(page.locator("#interaction-state")).toHaveText(/^(準備完了|エラー)$/)

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
    const controller = {
      valid: true,
      handedness: "right",
      matrix: [
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0.4, 0, -1, 1,
      ],
      rayMatrix: [
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, -1, 1,
      ],
    }
    const gripSpace = {}
    const targetRaySpace = {}
    const leftGripSpace = {}
    const leftTargetRaySpace = {}

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
      selectListeners: Array<(event: {
        type: string
        inputSource: { handedness: string }
      }) => void> = []

      addEventListener(type: string, listener: any) {
        if (type === "end") this.listeners.push(listener)
        if (type === "selectstart" || type === "selectend") {
          this.selectListeners.push(listener)
        }
      }

      requestReferenceSpace() {
        return Promise.resolve({})
      }

      updateRenderState() {}

      emitSelect(pressed: boolean) {
        this.selectListeners.forEach((listener) => {
          listener({
            type: pressed ? "selectstart" : "selectend",
            inputSource: { handedness: "right" },
          })
        })
      }

      requestAnimationFrame(callback: (time: number, frame: unknown) => void) {
        if (this.frameScheduled) return
        this.frameScheduled = true
        window.setTimeout(() => {
          callback(performance.now(), {
            getViewerPose: () => pose,
            session: {
              inputSources: [{
                handedness: "left",
                gripSpace: leftGripSpace,
                targetRaySpace: leftTargetRaySpace,
              }, {
                handedness: "right",
                gripSpace,
                targetRaySpace,
              }],
            },
            getPose: (space: unknown, _referenceSpace: unknown) => ({
              transform: {
                matrix: space === leftTargetRaySpace
                  ? [
                    1, 0, 0, 0,
                    0, 1, 0, 0,
                    0, 0, 1, 0,
                    1, 0, -1, 1,
                  ]
                  : space === targetRaySpace ? controller.rayMatrix : controller.matrix,
              },
            }),
          })
          Object.defineProperty(globalThis, "triggerSelect", {
            configurable: true,
            value: (pressed: boolean) => this.emitSelect(pressed),
          })
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
  await expect(page.locator("#interaction")).toHaveAttribute("data-state", "hover")
  await expect(page.locator("#interaction-controller")).toHaveText("右コントローラー")
  await expect(page.locator("#status")).toContainText("controller: right")
  await page.evaluate(() => {
    (globalThis as unknown as { triggerSelect: (pressed: boolean) => void })
      .triggerSelect(true)
  })
  await expect(page.locator("#status")).toContainText("XR selectstart (right)")
  await expect(page.locator("#status")).toContainText("Cube selected")
  await expect(page.locator("#status")).toContainText("Cube grabbed")
  await expect(page.locator("#interaction")).toHaveAttribute("data-state", "grabbed")
  await expect(page.locator("#interaction")).toHaveAttribute("data-controller", "right")
  await expect(page.locator("#interaction-controller")).toHaveText("右コントローラー")
  await page.evaluate(() => {
    (globalThis as unknown as { triggerSelect: (pressed: boolean) => void })
      .triggerSelect(false)
  })
  await expect(page.locator("#status")).toContainText("XR selectend (right)")
  await expect(page.locator("#status")).toContainText("Cube released")
  await expect(page.locator("#interaction")).toHaveAttribute("data-state", "released")
  await expect(page.locator("#interaction-state")).toHaveText("配置完了")
  expect(pageErrors).toHaveLength(0)
})

test("falls back to WebGL for browsers without the WebGPU XR binding", async ({ page }) => {
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
    const controller = {
      valid: true,
      handedness: "right",
      matrix: [
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0.4, 0, -1, 1,
      ],
      rayMatrix: [
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, -1, 1,
      ],
    }
    const gripSpace = {}
    const targetRaySpace = {}
    const leftGripSpace = {}
    const leftTargetRaySpace = {}

    const fakeGl = {
      ARRAY_BUFFER: 0x8892,
      BACK: 0x0405,
      COLOR_BUFFER_BIT: 0x4000,
      COMPILE_STATUS: 0x8b81,
      CULL_FACE: 0x0b44,
      DEPTH_BUFFER_BIT: 0x0100,
      DEPTH_TEST: 0x0b71,
      FLOAT: 0x1406,
      FRAGMENT_SHADER: 0x8b30,
      FRAMEBUFFER: 0x8d40,
      LESS: 0x0201,
      LINK_STATUS: 0x8b82,
      SCISSOR_TEST: 0x0c11,
      STATIC_DRAW: 0x88e4,
      TRIANGLES: 0x0004,
      VERTEX_SHADER: 0x8b31,
      attachShader: () => {},
      bindBuffer: () => {},
      bindFramebuffer: () => {},
      bufferData: () => {},
      clear: () => {},
      clearColor: () => {},
      clearDepth: () => {},
      compileShader: () => {},
      createBuffer: () => ({}),
      createProgram: () => ({}),
      createShader: () => ({}),
      cullFace: () => {},
      depthFunc: () => {},
      drawArrays: () => {},
      disable: () => {},
      enable: () => {},
      enableVertexAttribArray: () => {},
      getAttribLocation: () => 0,
      getProgramInfoLog: () => "",
      getProgramParameter: () => true,
      getShaderInfoLog: () => "",
      getShaderParameter: () => true,
      getUniformLocation: () => ({}),
      linkProgram: () => {},
      scissor: () => {},
      shaderSource: () => {},
      uniformMatrix4fv: () => {},
      useProgram: () => {},
      vertexAttribPointer: () => {},
      viewport: () => {},
    }
    const makeTexture = () => ({
      createView: () => ({}),
      destroy: () => {},
    })
    const fakeDevice = {
      queue: { writeBuffer: () => {}, submit: () => {} },
      lost: { then: () => {} },
      createShaderModule: () => ({}),
      createRenderPipeline: () => ({ getBindGroupLayout: () => ({}) }),
      createBuffer: () => ({}),
      createBindGroup: () => ({}),
      createTexture: () => makeTexture(),
      createCommandEncoder: () => ({
        beginRenderPass: () => ({
          setPipeline: () => {},
          setBindGroup: () => {},
          setVertexBuffer: () => {},
          draw: () => {},
          end: () => {},
        }),
        finish: () => ({}),
      }),
    }
    const fakeGpu = {
      getPreferredCanvasFormat: () => "bgra8unorm",
      requestAdapter: async () => ({ requestDevice: async () => fakeDevice }),
    }
    const fakeContext = {
      configure: () => {},
      getCurrentTexture: () => makeTexture(),
    }

    class MockXRSession {
      frameScheduled = false
      listeners: Array<() => void> = []
      selectListeners: Array<(event: {
        type: string
        inputSource: { handedness: string }
      }) => void> = []

      addEventListener(type: string, listener: any) {
        if (type === "end") this.listeners.push(listener)
        if (type === "selectstart" || type === "selectend") {
          this.selectListeners.push(listener)
        }
      }

      requestReferenceSpace() {
        return Promise.resolve({})
      }

      updateRenderState() {}

      emitSelect(pressed: boolean) {
        this.selectListeners.forEach((listener) => {
          listener({
            type: pressed ? "selectstart" : "selectend",
            inputSource: { handedness: "right" },
          })
        })
      }

      requestAnimationFrame(callback: (time: number, frame: unknown) => void) {
        if (this.frameScheduled) return
        this.frameScheduled = true
        window.setTimeout(() => {
          callback(performance.now(), {
            getViewerPose: () => pose,
            session: {
              inputSources: [{
                handedness: "left",
                gripSpace: leftGripSpace,
                targetRaySpace: leftTargetRaySpace,
              }, { handedness: "right", gripSpace, targetRaySpace }],
            },
            getPose: (space: unknown, _referenceSpace: unknown) => ({
              transform: {
                matrix: space === leftTargetRaySpace
                  ? [
                    1, 0, 0, 0,
                    0, 1, 0, 0,
                    0, 0, 1, 0,
                    1, 0, -1, 1,
                  ]
                  : space === targetRaySpace ? controller.rayMatrix : controller.matrix,
              },
            }),
          })
          Object.defineProperty(globalThis, "triggerSelect", {
            configurable: true,
            value: (pressed: boolean) => this.emitSelect(pressed),
          })
        }, 0)
      }
    }

    class MockXRWebGLLayer {
      framebuffer = {}

      constructor(_session: MockXRSession, _context: typeof fakeGl) {}

      getViewport() {
        return { x: 0, y: 0, width: 64, height: 64 }
      }
    }

    Object.defineProperty(globalThis, "XRWebGLLayer", {
      configurable: true,
      value: MockXRWebGLLayer,
    })
    Object.defineProperty(HTMLCanvasElement.prototype, "getContext", {
      configurable: true,
      value: (contextId: string) => {
        if (contextId === "webgpu") return fakeContext
        if (contextId === "webgl2" || contextId === "webgl") return fakeGl
        return null
      },
    })
    Object.defineProperty(navigator, "gpu", {
      configurable: true,
      value: fakeGpu,
    })
    Object.defineProperty(navigator, "xr", {
      configurable: true,
      value: {
        isSessionSupported: async () => true,
        requestSession: async (_mode: string, options: { requiredFeatures?: string[] }) => {
          if (options.requiredFeatures?.includes("webgpu")) {
            throw new Error("WebGPU XR is unavailable")
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
  await expect(button).toHaveText("VR を開始（WebGL）")
  await expect(button).toBeEnabled()
  await button.click()

  await expect(page.locator("#status")).toContainText("WebXR session active (2 views, WebGL)")
  await expect(page.locator("#interaction")).toHaveAttribute("data-state", "hover")
  await expect(page.locator("#interaction-controller")).toHaveText("右コントローラー")
  await expect(page.locator("#status")).toContainText("controller: right")
  await page.evaluate(() => {
    (globalThis as unknown as { triggerSelect: (pressed: boolean) => void })
      .triggerSelect(true)
  })
  await expect(page.locator("#status")).toContainText("XR selectstart (right)")
  await expect(page.locator("#status")).toContainText("Cube selected")
  await expect(page.locator("#status")).toContainText("Cube grabbed")
  await expect(page.locator("#interaction")).toHaveAttribute("data-state", "grabbed")
  await expect(page.locator("#interaction")).toHaveAttribute("data-controller", "right")
  await expect(page.locator("#interaction-controller")).toHaveText("右コントローラー")
  await page.evaluate(() => {
    (globalThis as unknown as { triggerSelect: (pressed: boolean) => void })
      .triggerSelect(false)
  })
  await expect(page.locator("#status")).toContainText("XR selectend (right)")
  await expect(page.locator("#status")).toContainText("Cube released")
  await expect(page.locator("#interaction")).toHaveAttribute("data-state", "released")
  await expect(page.locator("#interaction-state")).toHaveText("配置完了")
  expect(pageErrors).toHaveLength(0)
})
