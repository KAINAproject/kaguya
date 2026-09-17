///|
/// A declared Zenoh publisher.
#external
pub type Publisher

///|
#module("@kaguya/zenoh-mbt/publisher")
extern "js" fn Publisher::ffi_put(
  self : Publisher,
  payload : Bytes,
) -> @js_async.Promise[Unit] = "publisherPut"

///|
/// Publishes a payload.
pub async fn Publisher::put(self : Publisher, payload : Bytes) -> Unit {
  self.ffi_put(payload).wait()
}

///|
#module("@kaguya/zenoh-mbt/publisher")
extern "js" fn Publisher::ffi_undeclare(
  self : Publisher,
) -> @js_async.Promise[Unit] = "publisherUndeclare"

///|
/// Undeclares the publisher.
pub async fn Publisher::undeclare(self : Publisher) -> Unit {
  self.ffi_undeclare().wait()
}
