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

///|
test "inspector state keeps the latest hand joints" {
  let state = InspectorState::new()
  let pose = @protocol.Pose::new(
    @protocol.Point::new(1.25, -2.5, 0.125),
    @protocol.Quaternion::new(0.0, 0.0, 0.0, 1.0),
  )
  let joint = @protocol.HandJointPose::new(pose, true, 0.01)
  let record = @protocol.HandPoseRecord::new(
    @protocol.HandPose::new(@protocol.HandJoints::new([joint])),
    @protocol.DeviceDataTimestamp::new(1L, 1L, 0L),
  )
  let frame = @protocol.Frame::publish(
    "kaguya/v1/atlas/input/hand_pose",
    @protocol.Envelope::new(
      "kaguya.input.hand_pose",
      1U,
      3UL,
      4UL,
      "webxr:left",
      "local-floor",
      @protocol.Encoding::protobuf(),
      b"",
    ),
  )
  state.on_event(
    @bridge.BridgeEvent::hand_pose_received(
      @bridge.HandPoseEvent::new(
        @bridge.FrameSummary::new(
          frame.kind(),
          frame.topic(),
          "kaguya.input.hand_pose",
          1U,
          3UL,
          4UL,
          "webxr:left",
          "local-floor",
          0,
        ),
        record,
      ),
    ),
  )
  assert_eq(state.left_joints.length(), 1)
  assert_true(state.left_joints[0].is_valid)
  assert_eq(state.left_sequence, 3UL)
}

///|
test "inspector state keeps head pose and battery status" {
  let state = InspectorState::new()
  let pose = @protocol.Pose::new(
    @protocol.Point::new(1.0, 2.0, 3.0),
    @protocol.Quaternion::new(0.0, 0.0, 0.0, 1.0),
  )
  let head = @protocol.HeadPoseRecord::new(
    @protocol.HeadPose::new(pose, true, true),
    @protocol.DeviceDataTimestamp::new(1L, 1L, 0L),
  )
  let battery = @protocol.BatteryStatusRecord::new(
    @protocol.BatteryStatus::new(0.5, true, true),
    @protocol.DeviceDataTimestamp::new(1L, 1L, 0L),
  )
  let frame = @protocol.Frame::publish(
    "kaguya/v1/atlas/input/head_pose",
    @protocol.Envelope::new(
      "kaguya.input.head_pose",
      1U,
      4UL,
      5UL,
      "webxr:head",
      "local-floor",
      @protocol.Encoding::protobuf(),
      b"",
    ),
  )
  state.on_event(
    @bridge.BridgeEvent::head_pose_received(
      @bridge.HeadPoseEvent::new(
        @bridge.FrameSummary::new(
          frame.kind(),
          frame.topic(),
          "kaguya.input.head_pose",
          1U,
          4UL,
          5UL,
          "webxr:head",
          "local-floor",
          0,
        ),
        head,
      ),
    ),
  )
  state.on_event(
    @bridge.BridgeEvent::battery_status_received(
      @bridge.BatteryStatusEvent::new(
        @bridge.FrameSummary::new(
          frame.kind(),
          "kaguya/v1/atlas/input/battery_status",
          "kaguya.input.battery_status",
          1U,
          5UL,
          6UL,
          "browser:battery",
          "local-floor",
          0,
        ),
        battery,
      ),
    ),
  )
  assert_eq(state.head_pose_frames, 1UL)
  assert_eq(state.head_pose_sequence, 4UL)
  assert_eq(state.battery_frames, 1UL)
  assert_eq(state.battery_sequence, 5UL)
  match state.head_pose {
    Some(value) => assert_eq(value.pose.position.x, 1.0)
    None => fail("head pose must be stored")
  }
  match state.battery_status {
    Some(value) => assert_eq(value.level, 0.5)
    None => fail("battery status must be stored")
  }
}
