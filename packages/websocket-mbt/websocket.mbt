///|
/// A browser WebSocket connection carrying binary MoonBit protocol frames.
#external
pub type Connection

///|
#module("@kaguya/websocket-mbt/websocket")
extern "js" fn Connection::ffi_open(
  url : String,
  on_message : (Bytes) -> Unit,
) -> @js_async.Promise[Connection] = "websocketOpen"

///|
/// Opens a WebSocket and waits until its connection is established.
pub async fn Connection::open(
  url : String,
  on_message : (Bytes) -> Unit,
) -> Connection {
  Connection::ffi_open(url, on_message).wait()
}

///|
#module("@kaguya/websocket-mbt/websocket")
extern "js" fn Connection::ffi_send(self : Connection, payload : Bytes) -> Unit = "websocketSend"

///|
/// Sends one binary frame.
pub fn Connection::send(self : Connection, payload : Bytes) -> Unit {
  self.ffi_send(payload)
}

///|
#module("@kaguya/websocket-mbt/websocket")
extern "js" fn Connection::ffi_is_open(self : Connection) -> Bool = "websocketIsOpen"

///|
/// Returns whether the browser WebSocket is ready to send binary frames.
pub fn Connection::is_open(self : Connection) -> Bool {
  self.ffi_is_open()
}

///|
#module("@kaguya/websocket-mbt/websocket")
extern "js" fn Connection::ffi_buffered_amount(self : Connection) -> Int = "websocketBufferedAmount"

///|
/// Returns the number of bytes queued by the browser for this connection.
pub fn Connection::buffered_amount(self : Connection) -> Int {
  self.ffi_buffered_amount()
}

///|
#module("@kaguya/websocket-mbt/websocket")
extern "js" fn Connection::ffi_close(self : Connection) -> Unit = "websocketClose"

///|
/// Closes the connection.
pub fn Connection::close(self : Connection) -> Unit {
  self.ffi_close()
}
