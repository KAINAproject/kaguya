import "./style.css"
import { kaguya_start } from "@kaguya/runtime"

kaguya_start().catch((error: unknown) => {
  console.error("Kaguya initialization failed", error)
})
