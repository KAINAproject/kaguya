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

///|
test "decode_frame_event decodes head pose" {
  let pose = @protocol.Pose::new(
    @protocol.Point::new(1.0, 2.0, 3.0),
    @protocol.Quaternion::new(0.0, 0.0, 0.0, 1.0),
  )
  let record = @protocol.HeadPoseRecord::new(
    @protocol.HeadPose::new(pose, true, true),
    @protocol.DeviceDataTimestamp::new(1L, 2L, 3L),
  )
  let frame = @protocol.Frame::publish(
    "kaguya/v1/atlas/input/head_pose",
    @protocol.Envelope::new(
      HEAD_POSE_SCHEMA_ID,
      1U,
      9UL,
      10UL,
      "webxr:head",
      "local-floor",
      @protocol.Encoding::protobuf(),
      @protocol.encode_head_pose_record(record),
    ),
  )
  match decode_frame_event(@protocol.encode_frame(frame)) {
    Ok(BridgeEvent::HeadPoseReceived(event)) => {
      assert_eq(event.frame.sequence, 9UL)
      assert_true(event.record.data.is_tracked)
      assert_eq(event.record.data.pose.position.x, 1.0)
    }
    Ok(_) => fail("head pose must produce a head pose event")
    Err(error) => fail(error)
  }
}

///|
test "decode_frame_event decodes battery status" {
  let record = @protocol.BatteryStatusRecord::new(
    @protocol.BatteryStatus::new(0.8, false, true),
    @protocol.DeviceDataTimestamp::new(1L, 2L, 3L),
  )
  let frame = @protocol.Frame::publish(
    "kaguya/v1/atlas/input/battery_status",
    @protocol.Envelope::new(
      BATTERY_STATUS_SCHEMA_ID,
      1U,
      11UL,
      12UL,
      "browser:battery",
      "local-floor",
      @protocol.Encoding::protobuf(),
      @protocol.encode_battery_status_record(record),
    ),
  )
  match decode_frame_event(@protocol.encode_frame(frame)) {
    Ok(BridgeEvent::BatteryStatusReceived(event)) => {
      assert_eq(event.frame.sequence, 11UL)
      assert_eq(event.record.data.level, 0.8)
      assert_false(event.record.data.is_charging)
    }
    Ok(_) => fail("battery status must produce a battery status event")
    Err(error) => fail(error)
  }
}
