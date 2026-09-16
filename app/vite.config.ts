import { defineConfig } from "vite"
import basicSsl from "@vitejs/plugin-basic-ssl"

const kaguyaRuntime = new URL(
  "./.moonbit-build/js/release/build/app/app.js",
  import.meta.url,
).pathname

export default defineConfig({
  plugins: [basicSsl()],
  resolve: {
    alias: {
      "@kaguya/runtime": kaguyaRuntime,
    },
  },
})
