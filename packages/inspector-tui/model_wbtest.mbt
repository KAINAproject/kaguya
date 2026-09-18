///|
test "inspector state receives connection and frame events" {
  let state = InspectorState::new()
  state.on_event(@bridge.BridgeEvent::connected("127.0.0.1:9001"))
  let protocol_frame = @protocol.Frame::subscribe("kaguya/test")
  state.on_event(
    @bridge.BridgeEvent::frame_received(
      @bridge.FrameSummary::new(
        protocol_frame.kind(),
        "kaguya/test",
        "kaguya.test",
        1U,
        7UL,
        8UL,
        "test",
        "world",
        12,
      ),
    ),
  )
  assert_true(state.connected)
  assert_eq(state.rx_frames, 1UL)
  assert_true(state.logs[0].contains("connected"))
  assert_true(state.logs[1].contains("kaguya/test"))
}
