///|
/// A connection to a Zenoh session exposed by the remote API.
#external
pub type Session

///|
#module("@kaguya/zenoh-mbt/session")
extern "js" fn Session::ffi_open(config : Config) -> @js_async.Promise[Session] = "sessionOpen"

///|
/// Opens a Zenoh session.
pub async fn Session::open(config : Config) -> Session {
  Session::ffi_open(config).wait()
}

///|
#module("@kaguya/zenoh-mbt/session")
extern "js" fn Session::ffi_declare_publisher(
  self : Session,
  key_expr : String,
) -> @js_async.Promise[Publisher] = "sessionDeclarePublisher"

///|
/// Declares a publisher for a key expression.
pub async fn Session::declare_publisher(
  self : Session,
  key_expr : String,
) -> Publisher {
  self.ffi_declare_publisher(key_expr).wait()
}

///|
#module("@kaguya/zenoh-mbt/session")
extern "js" fn Session::ffi_declare_publisher_with_encoding(
  self : Session,
  key_expr : String,
  encoding : Encoding,
) -> @js_async.Promise[Publisher] = "sessionDeclarePublisherWithEncoding"

///|
/// Declares a publisher with an explicit payload encoding.
pub async fn Session::declare_publisher_with_encoding(
  self : Session,
  key_expr : String,
  encoding : Encoding,
) -> Publisher {
  self.ffi_declare_publisher_with_encoding(key_expr, encoding).wait()
}

///|
#module("@kaguya/zenoh-mbt/session")
extern "js" fn Session::ffi_declare_subscriber(
  self : Session,
  key_expr : String,
  handler : (String, Bytes) -> Unit,
) -> @js_async.Promise[Subscriber] = "sessionDeclareSubscriber"

///|
/// Declares a subscriber and invokes `handler` for every received sample.
pub async fn Session::declare_subscriber(
  self : Session,
  key_expr : String,
  handler : (Sample) -> Unit,
) -> Subscriber {
  self
  .ffi_declare_subscriber(key_expr, fn(key_expr, payload) {
    handler(Sample::new(key_expr, payload))
  })
  .wait()
}

///|
#module("@kaguya/zenoh-mbt/session")
extern "js" fn Session::ffi_close(self : Session) -> @js_async.Promise[Unit] = "sessionClose"

///|
/// Closes the session.
pub async fn Session::close(self : Session) -> Unit {
  self.ffi_close().wait()
}
