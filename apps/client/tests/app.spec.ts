import { expect, test } from "@playwright/test"
import { WebSocketServer, type RawData } from "ws"

type ProtobufField = number | Uint8Array

function asBuffer(data: RawData): Buffer {
  if (Buffer.isBuffer(data)) return data
  if (Array.isArray(data)) return Buffer.concat(data)
  if (data instanceof ArrayBuffer) return Buffer.from(data)
  return Buffer.from(data)
}

function readVarint(bytes: Uint8Array, offset: number): [number, number] {
  let value = 0
  let shift = 0
  while (offset < bytes.length) {
    const current = bytes[offset++]
    value |= (current & 0x7f) << shift
    if ((current & 0x80) === 0) return [value, offset]
    shift += 7
  }
  throw new Error("truncated protobuf varint")
}

function readMessage(bytes: Uint8Array): Map<number, ProtobufField> {
  const fields = new Map<number, ProtobufField>()
  let offset = 0
  while (offset < bytes.length) {
    const [key, nextOffset] = readVarint(bytes, offset)
    offset = nextOffset
    const fieldNumber = key >> 3
    const wireType = key & 0x07
    if (wireType === 0) {
      const [value, endOffset] = readVarint(bytes, offset)
      fields.set(fieldNumber, value)
      offset = endOffset
    } else if (wireType === 2) {
      const [length, valueOffset] = readVarint(bytes, offset)
      const endOffset = valueOffset + length
      if (endOffset > bytes.length) throw new Error("truncated protobuf field")
      fields.set(fieldNumber, bytes.slice(valueOffset, endOffset))
      offset = endOffset
    } else {
      throw new Error(`unsupported protobuf wire type: ${wireType}`)
    }
  }
  return fields
}

function stringField(fields: Map<number, ProtobufField>, field: number): string {
  const value = fields.get(field)
  if (!(value instanceof Uint8Array)) throw new Error(`missing string field: ${field}`)
  return Buffer.from(value).toString("utf8")
}

function bytesField(fields: Map<number, ProtobufField>, field: number): Uint8Array {
  const value = fields.get(field)
  if (!(value instanceof Uint8Array)) throw new Error(`missing bytes field: ${field}`)
  return value
}

test("Kaguya Three.js WebXR app boots", async ({ page }) => {
  const pageErrors: Error[] = []
  page.on("pageerror", (error) => pageErrors.push(error))

  await page.goto("/")

  await expect(page).toHaveTitle("Kaguya Three.js WebXR")
  await expect(page.locator("#canvas")).toBeVisible()
  await expect(page.locator("#enter-xr")).toBeVisible()
  await expect(page.locator("#interaction")).toBeVisible()
  await expect(page.locator("#interaction")).toHaveAttribute(
    "data-state",
    /^(ready|error)$/,
  )

  const status = page.locator("#status")
  await expect(status).not.toContainText("Three.js を初期化しています")
  await expect(status).toHaveAttribute("data-kind", /^(success|error)$/)
  expect(pageErrors).toHaveLength(0)
})

test("WebXR support is forwarded to the three.js WebXRManager", async ({ page }) => {
  await page.addInitScript(() => {
    Object.defineProperty(navigator, "xr", {
      configurable: true,
      value: {
        isSessionSupported: async (mode: string) => mode === "immersive-vr",
        requestSession: async () => {
          throw new Error("session start is not part of this smoke test")
        },
      },
    })
  })

  const pageErrors: Error[] = []
  page.on("pageerror", (error) => pageErrors.push(error))

  await page.goto("/")

  await expect(page.locator("#enter-xr")).toHaveText("VR を開始")
  await expect(page.locator("#enter-xr")).toBeEnabled()
  await expect(page.locator("#status")).toContainText(
    "three.js WebGLRenderer initialized",
  )
  expect(pageErrors).toHaveLength(0)
})

test("WebXR session requests optional hand tracking", async ({ page }) => {
  await page.addInitScript(() => {
    Object.defineProperty(navigator, "xr", {
      configurable: true,
      value: {
        isSessionSupported: async (mode: string) => mode === "immersive-vr",
        requestSession: async (
          mode: string,
          options: {
            optionalFeatures?: string[]
          },
        ) => {
          document.documentElement.dataset.xrMode = mode
          document.documentElement.dataset.xrOptionalFeatures =
            options.optionalFeatures?.join(",") ?? ""
          throw new Error("session start is not part of this smoke test")
        },
      },
    })
  })

  await page.goto("/")
  await page.locator("#enter-xr").click()

  await expect(page.locator("html")).toHaveAttribute("data-xr-mode", "immersive-vr")
  await expect(page.locator("html")).toHaveAttribute(
    "data-xr-optional-features",
    "local-floor,hand-tracking",
  )
})

test("IWER provides the test-only WebXR runtime", async ({ page }) => {
  await page.goto("/")

  await expect(page.locator("#enter-xr")).toBeEnabled()
  await expect(page.locator("#enter-xr")).toHaveText("VR を開始")
  const emulator = await page.evaluate(() => {
    const device = window.__kaguyaXrDevice as
      | { primaryInputMode?: string }
      | undefined
    return device?.primaryInputMode
  })
  expect(emulator).toBe("hand")
})

test("WebSocket probe sends a protobuf Frame", async ({ page }) => {
  const server = new WebSocketServer({ port: 0, path: "/ws" })
  const received = new Promise<Buffer>((resolve, reject) => {
    server.once("connection", (socket) => {
      socket.once("message", (data) => resolve(asBuffer(data)))
    })
    server.once("error", reject)
  })
  await new Promise<void>((resolve) => server.once("listening", () => resolve()))

  try {
    const address = server.address()
    if (address == null || typeof address === "string") {
      throw new Error("WebSocket test server did not expose a TCP port")
    }
    await page.goto(
      `/?ws=ws://127.0.0.1:${address.port}/ws&wsProbe=1`,
    )
    const frame = readMessage(await received)
    expect(frame.get(1)).toBe(1)
    expect(stringField(frame, 2)).toBe("kaguya/v1/atlas/debug/probe")

    const envelope = readMessage(bytesField(frame, 3))
    expect(stringField(envelope, 1)).toBe("kaguya.test")
    expect(envelope.get(2)).toBe(1)
    expect(envelope.get(3)).toBe(1)
    expect(stringField(envelope, 5)).toBe("kaguya-test")
    expect(stringField(envelope, 6)).toBe("local-floor")
    expect(envelope.get(7)).toBe(1)
    expect(Buffer.from(bytesField(envelope, 8)).toString("utf8")).toBe("probe")
  } finally {
    for (const socket of server.clients) socket.terminate()
    await new Promise<void>((resolve) => server.close(() => resolve()))
  }
})

test("WebSocket reconnects after the bridge disconnects", async ({ page }) => {
  const server = new WebSocketServer({ port: 0, path: "/ws" })
  await new Promise<void>((resolve) => server.once("listening", resolve))

  const address = server.address()
  if (address == null || typeof address === "string") {
    throw new Error("WebSocket test server did not expose a TCP port")
  }

  const firstConnection = new Promise<import("ws").WebSocket>((resolve) => {
    server.once("connection", (socket) => resolve(socket))
  })

  let replacement: WebSocketServer | undefined
  try {
    await page.goto(`/?ws=ws://127.0.0.1:${address.port}/ws`)
    const socket = await firstConnection

    const disconnected = new Promise<void>((resolve) => {
      socket.once("close", () => resolve())
    })
    socket.terminate()
    await disconnected

    await new Promise<void>((resolve, reject) => {
      server.close((error) => (error == null ? resolve() : reject(error)))
    })

    replacement = new WebSocketServer({ port: address.port, path: "/ws" })
    const reconnected = new Promise<void>((resolve, reject) => {
      replacement?.once("connection", () => resolve())
      replacement?.once("error", reject)
    })
    await new Promise<void>((resolve) => replacement?.once("listening", resolve))
    await reconnected
  } finally {
    for (const socket of server.clients) socket.terminate()
    if (replacement != null) {
      for (const socket of replacement.clients) socket.terminate()
      await new Promise<void>((resolve) => replacement?.close(() => resolve()))
    }
  }
})
