# Zenoh bindings for MoonBit

This package provides typed MoonBit bindings for the browser-facing
`@eclipse-zenoh/zenoh-ts` API.

The MoonBit API keeps Zenoh objects as opaque types and exposes asynchronous
operations close to the original API:

```moonbit nocheck
let config = @zenoh.Config::new("ws://127.0.0.1:10000", 500)
let session = @zenoh.Session::open(config)
let publisher = session.declare_publisher_with_encoding(
  "kaguya/v1/robot/output/joint_state",
  @zenoh.Encoding::application_protobuf(),
)
publisher.put(payload)
publisher.undeclare()
session.close()
```

The JavaScript companion in `js/` is intentionally small. It imports
`@eclipse-zenoh/zenoh-ts` and adapts its JavaScript object API to MoonBit FFI.
The binding itself is generic; Kaguya topics and protobuf messages belong to
`KAINAproject/kaguya/packages/shared`.

For a browser application, link the companion package from the application
package and install its npm dependency:

```json
"@kaguya/zenoh-mbt": "link:../../packages/zenoh-mbt/js"
```
