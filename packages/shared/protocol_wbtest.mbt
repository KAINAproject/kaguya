///|
fn sample_pose() -> Pose {
  Pose::{
    position: Point::{ x: 1.0, y: -2.5, z: 3.25, },
    orientation: Quaternion::{ x: 0.0, y: 0.5, z: 0.0, w: 0.8660254, },
  }
}

///|
fn sample_timestamp() -> DeviceDataTimestamp {
  DeviceDataTimestamp::{
    available_time_local_common_clock: 100L,
    sample_time_local_common_clock: 90L,
    sample_time_raw_device_clock: -10L,
  }
}

///|
test "envelope round trip" {
  let original = Envelope::{
    schema_id: "kaguya.input.head_pose",
    schema_version: 1U,
    sequence: 42UL,
    source_time_ns: 123456789UL,
    source_id: "quest3",
    frame_id: "local-floor",
    encoding: Protobuf,
    payload: b"payload",
  }
  let encoded = encode_envelope(original)
  let decoded = match decode_envelope(encoded) {
    Ok(value) => value
    Err(error) => fail(error)
  }
  assert_eq(decoded, original)
}

///|
test "publish frame round trip" {
  let envelope = Envelope::{
    schema_id: "kaguya.input.head_pose",
    schema_version: 1U,
    sequence: 42UL,
    source_time_ns: 123456789UL,
    source_id: "quest3",
    frame_id: "local-floor",
    encoding: Protobuf,
    payload: b"payload",
  }
  let original = Frame::publish("kaguya/v1/atlas/input/head_pose", envelope)
  let decoded = match decode_frame(encode_frame(original)) {
    Ok(value) => value
    Err(error) => fail(error)
  }
  assert_eq(decoded, original)
}

///|
test "subscribe frame round trip" {
  let original = Frame::subscribe("kaguya/v1/atlas/output/joint_state")
  let decoded = match decode_frame(encode_frame(original)) {
    Ok(value) => value
    Err(error) => fail(error)
  }
  assert_eq(decoded, original)
}

///|
test "envelope skips unknown fields" {
  let bytes : Bytes = [
    b'\x4A', b'\x03', b'o', b'l', b'd', // field 9, bytes
     b'\x10', b'\x0B', // schema_version = 11
  ]
  let decoded = match decode_envelope(bytes) {
    Ok(value) => value
    Err(error) => fail(error)
  }
  assert_eq(decoded.schema_version, 11U)
  assert_eq(decoded.schema_id, "")
}

///|
test "truncated envelope is rejected" {
  match decode_envelope(b"\x0A\x05hi") {
    Ok(_) => fail("truncated protobuf must fail")
    Err(_) => ()
  }
}

///|
test "device data timestamp preserves signed values" {
  let original = sample_timestamp()
  let decoded = match
    decode_device_data_timestamp(encode_device_data_timestamp(original)) {
    Ok(value) => value
    Err(error) => fail(error)
  }
  assert_eq(decoded, original)
}

///|
test "head pose record round trip" {
  let original = HeadPoseRecord::{
    data: HeadPose::{ pose: sample_pose(), is_valid: true, is_tracked: true, },
    timestamp: sample_timestamp(),
  }
  let decoded = match
    decode_head_pose_record(encode_head_pose_record(original)) {
    Ok(value) => value
    Err(error) => fail(error)
  }
  assert_eq(decoded, original)
}

///|
test "controller snapshot record round trip" {
  let controller_pose = ControllerPose::{ pose: sample_pose(), is_valid: true, }
  let original = ControllerSnapshotRecord::{
    data: ControllerSnapshot::{
      grip_pose: controller_pose,
      aim_pose: controller_pose,
      inputs: ControllerInputState::{
        primary_click: true,
        secondary_click: false,
        thumbstick_click: true,
        menu_click: false,
        thumbstick_x: 0.25,
        thumbstick_y: -0.5,
        squeeze_value: 0.75,
        trigger_value: 1.0,
      },
    },
    timestamp: sample_timestamp(),
  }
  let decoded = match
    decode_controller_snapshot_record(
      encode_controller_snapshot_record(original),
    ) {
    Ok(value) => value
    Err(error) => fail(error)
  }
  assert_eq(decoded, original)
}

///|
test "hand pose record round trip" {
  let joint_pose = HandJointPose::{
    pose: sample_pose(),
    is_valid: true,
    radius: 0.012,
  }
  let original = HandPoseRecord::{
    data: HandPose::{
      joints: HandJoints::{ poses: [joint_pose, joint_pose], },
    },
    timestamp: sample_timestamp(),
  }
  let decoded = match
    decode_hand_pose_record(encode_hand_pose_record(original)) {
    Ok(value) => value
    Err(error) => fail(error)
  }
  assert_eq(decoded, original)
}

///|
test "joint state output record round trip" {
  let original = JointStateOutputRecord::{
    data: JointStateOutput::{
      joints: [
        JointState::{
          name: "shoulder_pan",
          position: 1.5,
          velocity: 0.1,
          effort: 0.2,
          valid: true,
        },
        JointState::{
          name: "gripper",
          position: 0.25,
          velocity: 0.0,
          effort: 0.0,
          valid: false,
        },
      ],
      device_id: "so101_leader",
      has_velocity: true,
      has_effort: true,
      ee_pose: Some(sample_pose()),
      ee_pose_valid: true,
    },
    timestamp: sample_timestamp(),
  }
  let decoded = match
    decode_joint_state_output_record(encode_joint_state_output_record(original)) {
    Ok(value) => value
    Err(error) => fail(error)
  }
  assert_eq(decoded, original)
}
