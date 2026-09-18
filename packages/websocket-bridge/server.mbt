///|
pub const WEBSOCKET_PATH : String = "/ws"

///|
fn is_websocket_path(path : String) -> Bool {
  path == WEBSOCKET_PATH
}

///|
async fn handle_connection(
  request : @http.Request,
  connection : @http.ServerConnection,
  bus : @bridge.EventBus,
) -> Unit {
  let address = "\{connection.client_addr()}"
  let websocket = @websocket.from_http_server(request, connection)
  bus.publish(@bridge.BridgeEvent::connected(address))
  defer websocket.close()
  try {
    for ;; {
      let message = websocket.recv()
      match message.kind {
        @websocket.MessageKind::Binary => {
          let bytes = message.read_all().binary()
          @bridge.publish_frame(bus, bytes)
        }
        @websocket.MessageKind::Text =>
          bus.publish(
            @bridge.BridgeEvent::decode_error(
              "text WebSocket message is not a protocol frame",
            ),
          )
      }
    }
  } catch {
    @websocket.ConnectionClosed(code, reason) => {
      let reason_text = match reason {
        Some(value) => value
        None => ""
      }
      bus.publish(
        @bridge.BridgeEvent::disconnected(
          "\{@debug.to_string(code)} \{reason_text}",
        ),
      )
    }
    error => bus.publish(@bridge.BridgeEvent::disconnected("\{error}"))
  }
}

///|
async fn handle_request(
  request : @http.Request,
  connection : @http.ServerConnection,
  bus : @bridge.EventBus,
) -> Unit {
  if is_websocket_path(request.path) {
    handle_connection(request, connection, bus)
  } else {
    connection
    ..send_response(404, "Not Found")
    ..write("WebSocket endpoint is \{WEBSOCKET_PATH}\n")
    .end_response()
  }
}

///|
pub async fn serve(address : String, bus : @bridge.EventBus) -> Unit {
  let server = @http.Server(@socket.Addr::parse(address))
  server.run_forever((request, _, connection) => {
    handle_request(request, connection, bus)
  })
}
