///|
test "websocket endpoint only accepts /ws" {
  assert_true(is_websocket_path("/ws"))
  assert_false(is_websocket_path("/"))
  assert_false(is_websocket_path("/other"))
}
