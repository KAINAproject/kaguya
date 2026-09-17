import {
  Config,
  Encoding,
  Session,
  type Publisher,
  type Subscriber,
} from "@eclipse-zenoh/zenoh-ts"

export const KAGUYA_TOPIC_ROOT = "kaguya/v1"

export function kaguyaTopic(robotId: string, path: string): string {
  return `${KAGUYA_TOPIC_ROOT}/${robotId}/${path}`
}

export function controllerInputTopic(robotId: string): string {
  return kaguyaTopic(robotId, "input/controller")
}

export function hmdPoseInputTopic(robotId: string): string {
  return kaguyaTopic(robotId, "input/hmd_pose")
}

export function handLandmarksInputTopic(robotId: string): string {
  return kaguyaTopic(robotId, "input/hand_landmarks")
}

export function jointStateOutputTopic(robotId: string): string {
  return kaguyaTopic(robotId, "output/joint_state")
}

export function rgbOutputTopic(robotId: string): string {
  return kaguyaTopic(robotId, "output/rgb")
}

export function stateTopic(robotId: string, name: string): string {
  return kaguyaTopic(robotId, `state/${name}`)
}

export function eventTopic(robotId: string, name: string): string {
  return kaguyaTopic(robotId, `event/${name}`)
}

export function debugTopic(robotId: string, name: string): string {
  return kaguyaTopic(robotId, `debug/${name}`)
}

export type ZenohMessage = {
  keyExpr: string
  payload: Uint8Array
}

export type ZenohMessageHandler = (message: ZenohMessage) => void

export type ZenohSubscription = {
  close: () => Promise<void>
}

/**
 * Browser-side transport for the Zenoh remote API.
 *
 * The payload is intentionally opaque here. Callers can pass protobuf bytes
 * from packages/shared, while the same transport can also carry arbitrary
 * debug or event payloads.
 */
export class ZenohTransport {
  private readonly publishers = new Map<string, Promise<Publisher>>()
  private readonly subscribers = new Set<Subscriber>()

  private constructor(private readonly session: Session) {}

  static async open(locator: string, timeoutMs = 500): Promise<ZenohTransport> {
    const session = await Session.open(new Config(locator, timeoutMs))
    return new ZenohTransport(session)
  }

  async publish(keyExpr: string, payload: Uint8Array): Promise<void> {
    const publisher = await this.publisher(keyExpr)
    await publisher.put(payload)
  }

  async subscribe(
    keyExpr: string,
    handler: ZenohMessageHandler,
  ): Promise<ZenohSubscription> {
    const subscriber = await this.session.declareSubscriber(keyExpr, {
      handler: (sample) => {
        handler({
          keyExpr: sample.keyexpr().toString(),
          payload: sample.payload().toBytes().slice(),
        })
      },
    })
    this.subscribers.add(subscriber)

    let closed = false
    return {
      close: async () => {
        if (closed) return
        closed = true
        this.subscribers.delete(subscriber)
        await subscriber.undeclare()
      },
    }
  }

  async close(): Promise<void> {
    const subscribers = [...this.subscribers]
    this.subscribers.clear()
    await Promise.all(subscribers.map((subscriber) => subscriber.undeclare()))

    const publishers = await Promise.all(this.publishers.values())
    this.publishers.clear()
    await Promise.all(publishers.map((publisher) => publisher.undeclare()))

    await this.session.close()
  }

  private async publisher(keyExpr: string): Promise<Publisher> {
    const existing = this.publishers.get(keyExpr)
    if (existing != null) return existing

    const pending = this.session.declarePublisher(keyExpr, {
      encoding: Encoding.APPLICATION_PROTOBUF,
    })
    this.publishers.set(keyExpr, pending)
    try {
      return await pending
    } catch (error) {
      this.publishers.delete(keyExpr)
      throw error
    }
  }
}

export function openZenohTransport(
  locator: string,
  timeoutMs = 500,
): Promise<ZenohTransport> {
  return ZenohTransport.open(locator, timeoutMs)
}
