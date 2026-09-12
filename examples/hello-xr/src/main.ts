import "./style.css"
import { kaguya_start } from "./kaguya.generated.js"

kaguya_start().catch((error: unknown) => {
  console.error("Kaguya initialization failed", error)
})
