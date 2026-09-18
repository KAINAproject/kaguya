///|
test "decode_frame_event reports decode errors" {
  match decode_frame_event(b"not a frame") {
    Ok(_) => fail("invalid frame must fail")
    Err(error) => assert_true(error.contains("frame decode failed"))
  }
}

///|
test "publish_frame turns decode errors into events" {
  let seen = Ref("")
  let bus = EventBus::new()
  bus.subscribe(fn(event) {
    match event {
      BridgeEvent::DecodeError(error) => seen.val = error
      _ => ()
    }
  })
  publish_frame(bus, b"not a frame")
  assert_true(seen.val.contains("frame decode failed"))
}

///|
test "publish_frame emits a summary for non-hand frames" {
  let topic = Ref("")
  let sequence = Ref(0UL)
  let bus = EventBus::new()
  bus.subscribe(fn(event) {
    match event {
      BridgeEvent::FrameReceived(frame) => {
        topic.val = frame.topic
        sequence.val = frame.sequence
      }
      _ => ()
    }
  })
  let envelope = @protocol.Envelope::new(
    "kaguya.test",
    1U,
    7UL,
    8UL,
    "test",
    "world",
    @protocol.Encoding::protobuf(),
    b"payload",
  )
  let frame = @protocol.Frame::publish("kaguya/test", envelope)
  publish_frame(bus, @protocol.encode_frame(frame))
  assert_eq(topic.val, "kaguya/test")
  assert_eq(sequence.val, 7UL)
}
