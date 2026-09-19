///|
let active_websocket : Ref[@websocket.Connection?] = Ref(None)

///|
const MAX_BUFFERED_BYTES : Int = 524288

///|
fn handle_websocket_frame(bytes : Bytes) -> Unit {
  match @protocol.decode_frame(bytes) {
    Ok(_) => @core.log(@core.any("Kaguya frame received"))
    Err(_) => @core.log(@core.any("Kaguya frame decode failed"))
  }
}

///|
async fn open_websocket(url : String) -> Unit {
  let connection = @websocket.Connection::new(url, handle_websocket_frame)
  active_websocket.val = Some(connection)
  connection.wait_until_open()
}

///|
#export_name("kaguya_websocket_open")
pub fn kaguya_websocket_open(url : String) -> @js_async.Promise[Unit] {
  @js_async.Promise::from_async(() => open_websocket(url))
}

///|
fn protocol_stream_ready() -> Bool {
  match active_websocket.val {
    Some(connection) =>
      connection.is_open() && connection.buffered_amount() <= MAX_BUFFERED_BYTES
    None => false
  }
}

///|
/// Sends a protocol frame when the WebSocket is ready and its queue is bounded.
fn send_protocol_frame(frame : @protocol.Frame) -> Bool {
  if !protocol_stream_ready() {
    false
  } else {
    match active_websocket.val {
      Some(connection) => {
        connection.send(@protocol.encode_frame(frame))
        true
      }
      None => false
    }
  }
}

///|
/// Sends one deterministic protobuf frame for transport smoke tests.
#export_name("kaguya_websocket_send_probe")
pub fn kaguya_websocket_send_probe() -> Bool {
  let envelope = @protocol.Envelope::new(
    "kaguya.test",
    1U,
    1UL,
    0UL,
    "kaguya-test",
    "local-floor",
    @protocol.Encoding::protobuf(),
    b"probe",
  )
  send_protocol_frame(
    @protocol.Frame::publish("kaguya/v1/atlas/debug/probe", envelope),
  )
}

///|
fn close_websocket() -> Unit {
  match active_websocket.val {
    Some(connection) => {
      active_websocket.val = None
      connection.close()
    }
    None => ()
  }
}

///|
#export_name("kaguya_websocket_close")
pub fn kaguya_websocket_close() -> Unit {
  close_websocket()
}
