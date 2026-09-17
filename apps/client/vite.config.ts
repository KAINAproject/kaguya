import { defineConfig } from "vite"
import basicSsl from "@vitejs/plugin-basic-ssl"
import wasm from "vite-plugin-wasm"

const kaguyaRuntime = new URL(
  "./.moonbit-build/js/release/build/apps/client/src/src.js",
  import.meta.url,
).pathname

export default defineConfig({
  plugins: [basicSsl(), wasm()],
  build: {
    target: "esnext",
  },
  resolve: {
    alias: {
      "@kaguya/runtime": kaguyaRuntime,
    },
  },
})
