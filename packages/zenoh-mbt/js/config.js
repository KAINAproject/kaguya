import { Config } from "@eclipse-zenoh/zenoh-ts"

export const config = (locator, timeoutMs) => new Config(locator, timeoutMs)
