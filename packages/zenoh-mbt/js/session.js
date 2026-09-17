import { Session } from "@eclipse-zenoh/zenoh-ts"

export const sessionOpen = (config) => Session.open(config)

export const sessionDeclarePublisher = (session, keyExpr) =>
  session.declarePublisher(keyExpr)

export const sessionDeclarePublisherWithEncoding = (
  session,
  keyExpr,
  encoding,
) => session.declarePublisher(keyExpr, { encoding })

export const sessionDeclareSubscriber = (session, keyExpr, handler) =>
  session.declareSubscriber(keyExpr, {
    handler: (sample) => {
      handler(sample.keyexpr().toString(), sample.payload().toBytes().slice())
    },
  })

export const sessionClose = (session) => session.close()
