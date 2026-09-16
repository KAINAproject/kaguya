import { expect, test } from "@playwright/test"

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
