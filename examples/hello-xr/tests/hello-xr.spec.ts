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
