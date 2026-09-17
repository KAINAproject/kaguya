///|
test "envelope round trip" {
  let original = Envelope::{
    schema_id: "kaguya.input.hmd_pose",
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
test "hmd pose round trip" {
  let original = HmdPose::{
    pose: Pose::{
      position: Vec3::{ x: 1.0, y: -2.5, z: 3.25, },
      orientation: Quaternion::{ x: 0.0, y: 0.5, z: 0.0, w: 0.8660254, },
      reference_frame: "local-floor",
    },
  }
  let encoded = encode_hmd_pose(original)
  let decoded = match decode_hmd_pose(encoded) {
    Ok(value) => value
    Err(error) => fail(error)
  }
  assert_eq(decoded, original)
}

///|
test "joint state round trip" {
  let original = JointState::{
    positions: [0.0, 1.5, -2.0],
    velocities: [0.1, 0.2, 0.3],
    efforts: [],
    source_time_ns: 999UL,
  }
  let encoded = encode_joint_state(original)
  let decoded = match decode_joint_state(encoded) {
    Ok(value) => value
    Err(error) => fail(error)
  }
  assert_eq(decoded, original)
}
