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
  build: {
    target: "esnext",
  },
})
