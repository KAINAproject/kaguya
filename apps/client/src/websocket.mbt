///|
let active_websocket : Ref[@websocket.Connection?] = Ref(None)

///|
fn handle_websocket_frame(bytes : Bytes) -> Unit {
  match @protocol.decode_frame(bytes) {
    Ok(_) => @core.log(@core.any("Kaguya frame received"))
    Err(_) => @core.log(@core.any("Kaguya frame decode failed"))
  }
}

///|
async fn open_websocket(url : String) -> Unit {
  let connection = @websocket.Connection::open(url, handle_websocket_frame)
  active_websocket.val = Some(connection)
}

///|
#export_name("kaguya_websocket_open")
pub fn kaguya_websocket_open(url : String) -> @js_async.Promise[Unit] {
  @js_async.Promise::from_async(() => open_websocket(url))
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
