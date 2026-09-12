import { defineConfig } from "vite"
import basicSsl from "@vitejs/plugin-basic-ssl"

const kaguyaRuntime = new URL(
  "./.moonbit-build/js/release/build/examples/hello-xr/hello-xr.js",
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
