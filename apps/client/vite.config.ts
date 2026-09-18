import { defineConfig } from "vite"
import basicSsl from "@vitejs/plugin-basic-ssl"
import moonbit from "vite-plugin-moonbit"
import wasm from "vite-plugin-wasm"

const moonbitRoot = new URL("../..", import.meta.url).pathname

export default defineConfig({
  resolve: {
    dedupe: ["three"],
  },
  plugins: [
    basicSsl(),
    wasm(),
    moonbit({
      root: moonbitRoot,
      target: "js",
      mode: "release",
    }),
  ],
  server: {
    proxy: {
      "/ws": {
        target: "ws://127.0.0.1:9001",
        ws: true,
      },
    },
  },
  build: {
    target: "esnext",
  },
})
