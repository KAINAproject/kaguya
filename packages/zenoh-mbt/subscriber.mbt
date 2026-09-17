///|
/// A declared Zenoh subscriber.
#external
pub type Subscriber

///|
#module("@kaguya/zenoh-mbt/subscriber")
extern "js" fn Subscriber::ffi_undeclare(
  self : Subscriber,
) -> @js_async.Promise[Unit] = "subscriberUndeclare"

///|
/// Undeclares the subscriber.
pub async fn Subscriber::undeclare(self : Subscriber) -> Unit {
  self.ffi_undeclare().wait()
}
