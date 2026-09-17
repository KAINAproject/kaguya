///|
pub enum Encoding {
  Unspecified
  Protobuf
  Json
  Jpeg
  Webp
} derive(Eq, Debug)

///|
pub struct Envelope {
  schema_id : String
  schema_version : UInt
  sequence : UInt64
  source_time_ns : UInt64
  source_id : String
  frame_id : String
  encoding : Encoding
  payload : Bytes
} derive(Eq, Debug)

///|
pub enum FrameKind {
  Unspecified
  Publish
  Subscribe
  Unsubscribe
  Data
  Error
} derive(Eq, Debug)

///|
pub struct Frame {
  kind : FrameKind
  topic : String
  envelope : Envelope?
  error : String
} derive(Eq, Debug)

///|
pub struct Point {
  x : Float
  y : Float
  z : Float
} derive(Eq, Debug)

///|
pub struct Quaternion {
  x : Float
  y : Float
  z : Float
  w : Float
} derive(Eq, Debug)

///|
pub struct Pose {
  position : Point
  orientation : Quaternion
} derive(Eq, Debug)

///|
pub struct DeviceDataTimestamp {
  available_time_local_common_clock : Int64
  sample_time_local_common_clock : Int64
  sample_time_raw_device_clock : Int64
} derive(Eq, Debug)

///|
pub struct HeadPose {
  pose : Pose
  is_valid : Bool
  is_tracked : Bool
} derive(Eq, Debug)

///|
pub struct HeadPoseRecord {
  data : HeadPose
  timestamp : DeviceDataTimestamp
} derive(Eq, Debug)

///|
pub struct ControllerInputState {
  primary_click : Bool
  secondary_click : Bool
  thumbstick_click : Bool
  menu_click : Bool
  thumbstick_x : Float
  thumbstick_y : Float
  squeeze_value : Float
  trigger_value : Float
} derive(Eq, Debug)

///|
pub struct ControllerPose {
  pose : Pose
  is_valid : Bool
} derive(Eq, Debug)

///|
pub struct ControllerSnapshot {
  grip_pose : ControllerPose
  aim_pose : ControllerPose
  inputs : ControllerInputState
} derive(Eq, Debug)

///|
pub struct ControllerSnapshotRecord {
  data : ControllerSnapshot
  timestamp : DeviceDataTimestamp
} derive(Eq, Debug)

///|
pub enum HandJoint {
  Palm
  Wrist
  ThumbMetacarpal
  ThumbProximal
  ThumbDistal
  ThumbTip
  IndexMetacarpal
  IndexProximal
  IndexIntermediate
  IndexDistal
  IndexTip
  MiddleMetacarpal
  MiddleProximal
  MiddleIntermediate
  MiddleDistal
  MiddleTip
  RingMetacarpal
  RingProximal
  RingIntermediate
  RingDistal
  RingTip
  LittleMetacarpal
  LittleProximal
  LittleIntermediate
  LittleDistal
  LittleTip
  NumJoints
} derive(Eq, Debug)

///|
pub const NUM_JOINTS : Int = 26

///|
pub fn HandJoint::to_int(self : HandJoint) -> Int {
  match self {
    Palm => 0
    Wrist => 1
    ThumbMetacarpal => 2
    ThumbProximal => 3
    ThumbDistal => 4
    ThumbTip => 5
    IndexMetacarpal => 6
    IndexProximal => 7
    IndexIntermediate => 8
    IndexDistal => 9
    IndexTip => 10
    MiddleMetacarpal => 11
    MiddleProximal => 12
    MiddleIntermediate => 13
    MiddleDistal => 14
    MiddleTip => 15
    RingMetacarpal => 16
    RingProximal => 17
    RingIntermediate => 18
    RingDistal => 19
    RingTip => 20
    LittleMetacarpal => 21
    LittleProximal => 22
    LittleIntermediate => 23
    LittleDistal => 24
    LittleTip => 25
    NumJoints => NUM_JOINTS
  }
}

///|
pub fn HandJoint::from_int(value : Int) -> HandJoint {
  match value {
    0 => Palm
    1 => Wrist
    2 => ThumbMetacarpal
    3 => ThumbProximal
    4 => ThumbDistal
    5 => ThumbTip
    6 => IndexMetacarpal
    7 => IndexProximal
    8 => IndexIntermediate
    9 => IndexDistal
    10 => IndexTip
    11 => MiddleMetacarpal
    12 => MiddleProximal
    13 => MiddleIntermediate
    14 => MiddleDistal
    15 => MiddleTip
    16 => RingMetacarpal
    17 => RingProximal
    18 => RingIntermediate
    19 => RingDistal
    20 => RingTip
    21 => LittleMetacarpal
    22 => LittleProximal
    23 => LittleIntermediate
    24 => LittleDistal
    25 => LittleTip
    _ => NumJoints
  }
}

///|
pub struct HandJointPose {
  pose : Pose
  is_valid : Bool
  radius : Float
} derive(Eq, Debug)

///|
pub struct HandJoints {
  poses : Array[HandJointPose]
} derive(Eq, Debug)

///|
pub struct HandPose {
  joints : HandJoints
} derive(Eq, Debug)

///|
pub struct HandPoseRecord {
  data : HandPose
  timestamp : DeviceDataTimestamp
} derive(Eq, Debug)

///|
pub struct JointState {
  name : String
  position : Float
  velocity : Float
  effort : Float
  valid : Bool
} derive(Eq, Debug)

///|
pub struct JointStateOutput {
  joints : Array[JointState]
  device_id : String
  has_velocity : Bool
  has_effort : Bool
  ee_pose : Pose?
  ee_pose_valid : Bool
} derive(Eq, Debug)

///|
pub struct JointStateOutputRecord {
  data : JointStateOutput
  timestamp : DeviceDataTimestamp
} derive(Eq, Debug)

///|
pub fn Envelope::new(
  schema_id : String,
  schema_version : UInt,
  sequence : UInt64,
  source_time_ns : UInt64,
  source_id : String,
  frame_id : String,
  encoding : Encoding,
  payload : Bytes,
) -> Envelope {
  {
    schema_id,
    schema_version,
    sequence,
    source_time_ns,
    source_id,
    frame_id,
    encoding,
    payload,
  }
}

///|
pub fn Frame::publish(topic : String, envelope : Envelope) -> Frame {
  { kind: Publish, topic, envelope: Some(envelope), error: "", }
}

///|
pub fn Frame::subscribe(topic : String) -> Frame {
  { kind: Subscribe, topic, envelope: None, error: "", }
}

///|
pub fn Frame::unsubscribe(topic : String) -> Frame {
  { kind: Unsubscribe, topic, envelope: None, error: "", }
}

///|
pub fn Frame::data(topic : String, envelope : Envelope) -> Frame {
  { kind: Data, topic, envelope: Some(envelope), error: "", }
}

///|
pub fn Frame::error(message : String) -> Frame {
  { kind: Error, topic: "", envelope: None, error: message, }
}

///|
pub fn Frame::kind(self : Frame) -> FrameKind {
  self.kind
}

///|
pub fn Frame::topic(self : Frame) -> String {
  self.topic
}

///|
pub fn Frame::envelope(self : Frame) -> Envelope? {
  self.envelope
}

///|
pub fn Frame::error_message(self : Frame) -> String {
  self.error
}

///|
pub fn Point::new(x : Float, y : Float, z : Float) -> Point {
  { x, y, z, }
}

///|
pub fn Quaternion::new(
  x : Float,
  y : Float,
  z : Float,
  w : Float,
) -> Quaternion {
  { x, y, z, w, }
}

///|
pub fn Pose::new(position : Point, orientation : Quaternion) -> Pose {
  { position, orientation, }
}

///|
pub fn DeviceDataTimestamp::new(
  available_time_local_common_clock : Int64,
  sample_time_local_common_clock : Int64,
  sample_time_raw_device_clock : Int64,
) -> DeviceDataTimestamp {
  {
    available_time_local_common_clock,
    sample_time_local_common_clock,
    sample_time_raw_device_clock,
  }
}

///|
pub fn HeadPose::new(
  pose : Pose,
  is_valid : Bool,
  is_tracked : Bool,
) -> HeadPose {
  { pose, is_valid, is_tracked, }
}

///|
pub fn HeadPoseRecord::new(
  data : HeadPose,
  timestamp : DeviceDataTimestamp,
) -> HeadPoseRecord {
  { data, timestamp, }
}

///|
pub fn ControllerInputState::new(
  primary_click : Bool,
  secondary_click : Bool,
  thumbstick_click : Bool,
  menu_click : Bool,
  thumbstick_x : Float,
  thumbstick_y : Float,
  squeeze_value : Float,
  trigger_value : Float,
) -> ControllerInputState {
  {
    primary_click,
    secondary_click,
    thumbstick_click,
    menu_click,
    thumbstick_x,
    thumbstick_y,
    squeeze_value,
    trigger_value,
  }
}

///|
pub fn ControllerPose::new(pose : Pose, is_valid : Bool) -> ControllerPose {
  { pose, is_valid, }
}

///|
pub fn ControllerSnapshot::new(
  grip_pose : ControllerPose,
  aim_pose : ControllerPose,
  inputs : ControllerInputState,
) -> ControllerSnapshot {
  { grip_pose, aim_pose, inputs, }
}

///|
pub fn ControllerSnapshotRecord::new(
  data : ControllerSnapshot,
  timestamp : DeviceDataTimestamp,
) -> ControllerSnapshotRecord {
  { data, timestamp, }
}

///|
pub fn HandJointPose::new(
  pose : Pose,
  is_valid : Bool,
  radius : Float,
) -> HandJointPose {
  { pose, is_valid, radius, }
}

///|
pub fn HandJoints::new(poses : Array[HandJointPose]) -> HandJoints {
  { poses, }
}

///|
pub fn HandPose::new(joints : HandJoints) -> HandPose {
  { joints, }
}

///|
pub fn HandPoseRecord::new(
  data : HandPose,
  timestamp : DeviceDataTimestamp,
) -> HandPoseRecord {
  { data, timestamp, }
}

///|
pub fn JointState::new(
  name : String,
  position : Float,
  velocity : Float,
  effort : Float,
  valid : Bool,
) -> JointState {
  { name, position, velocity, effort, valid, }
}

///|
pub fn JointStateOutput::new(
  joints : Array[JointState],
  device_id : String,
  has_velocity : Bool,
  has_effort : Bool,
  ee_pose : Pose?,
  ee_pose_valid : Bool,
) -> JointStateOutput {
  { joints, device_id, has_velocity, has_effort, ee_pose, ee_pose_valid, }
}

///|
pub fn JointStateOutputRecord::new(
  data : JointStateOutput,
  timestamp : DeviceDataTimestamp,
) -> JointStateOutputRecord {
  { data, timestamp, }
}

///|
fn encoding_to_int(encoding : Encoding) -> UInt {
  match encoding {
    Unspecified => 0U
    Protobuf => 1U
    Json => 2U
    Jpeg => 3U
    Webp => 4U
  }
}

///|
fn int_to_encoding(value : UInt) -> Encoding {
  match value {
    1U => Protobuf
    2U => Json
    3U => Jpeg
    4U => Webp
    _ => Unspecified
  }
}

///|
fn frame_kind_to_int(kind : FrameKind) -> UInt {
  match kind {
    Unspecified => 0U
    Publish => 1U
    Subscribe => 2U
    Unsubscribe => 3U
    Data => 4U
    Error => 5U
  }
}

///|
fn int_to_frame_kind(value : UInt) -> FrameKind {
  match value {
    1U => Publish
    2U => Subscribe
    3U => Unsubscribe
    4U => Data
    5U => Error
    _ => Unspecified
  }
}

///|
pub fn encode_frame(value : Frame) -> Bytes {
  let writer = ProtoWriter::new()
  if value.kind != FrameKind::Unspecified {
    writer.write_uint32(1, frame_kind_to_int(value.kind))
  }
  if value.topic != "" {
    writer.write_string(2, value.topic)
  }
  match value.envelope {
    Some(envelope) => writer.write_message(3, encode_envelope(envelope))
    None => ()
  }
  if value.error != "" {
    writer.write_string(4, value.error)
  }
  writer.finish()
}

///|
pub fn decode_frame(bytes : Bytes) -> Result[Frame, String] {
  let reader = ProtoReader::new(bytes)
  let mut kind = FrameKind::Unspecified
  let mut topic = ""
  let mut envelope : Envelope? = None
  let mut error = ""
  while reader.position < reader.bytes.length() {
    let (field_number, wire_type) = match reader.read_key() {
      Ok(key) => key
      Err(error) => return Err(error)
    }
    match (field_number, wire_type) {
      (1, 0) =>
        match reader.read_uint32() {
          Ok(field) => kind = int_to_frame_kind(field)
          Err(error) => return Err(error)
        }
      (2, 2) =>
        match reader.read_string() {
          Ok(field) => topic = field
          Err(error) => return Err(error)
        }
      (3, 2) =>
        match reader.read_bytes() {
          Ok(field) =>
            match decode_envelope(field) {
              Ok(decoded) => envelope = Some(decoded)
              Err(error) => return Err(error)
            }
          Err(error) => return Err(error)
        }
      (4, 2) =>
        match reader.read_string() {
          Ok(field) => error = field
          Err(error) => return Err(error)
        }
      (_, _) =>
        match reader.skip(wire_type) {
          Ok(_) => ()
          Err(error) => return Err(error)
        }
    }
  }
  Ok(Frame::{ kind, topic, envelope, error, })
}

///|
pub fn encode_envelope(value : Envelope) -> Bytes {
  let writer = ProtoWriter::new()
  if value.schema_id != "" {
    writer.write_string(1, value.schema_id)
  }
  if value.schema_version != 0U {
    writer.write_uint32(2, value.schema_version)
  }
  if value.sequence != 0UL {
    writer.write_uint64(3, value.sequence)
  }
  if value.source_time_ns != 0UL {
    writer.write_uint64(4, value.source_time_ns)
  }
  if value.source_id != "" {
    writer.write_string(5, value.source_id)
  }
  if value.frame_id != "" {
    writer.write_string(6, value.frame_id)
  }
  if value.encoding != Encoding::Unspecified {
    writer.write_uint32(7, encoding_to_int(value.encoding))
  }
  if value.payload.length() > 0 {
    writer.write_bytes(8, value.payload)
  }
  writer.finish()
}

///|
pub fn decode_envelope(bytes : Bytes) -> Result[Envelope, String] {
  let reader = ProtoReader::new(bytes)
  let mut schema_id = ""
  let mut schema_version = 0U
  let mut sequence = 0UL
  let mut source_time_ns = 0UL
  let mut source_id = ""
  let mut frame_id = ""
  let mut encoding = Encoding::Unspecified
  let mut payload : Bytes = b""
  while reader.position < reader.bytes.length() {
    let (field_number, wire_type) = match reader.read_key() {
      Ok(key) => key
      Err(error) => return Err(error)
    }
    match (field_number, wire_type) {
      (1, 2) =>
        match reader.read_string() {
          Ok(field) => schema_id = field
          Err(error) => return Err(error)
        }
      (2, 0) =>
        match reader.read_uint32() {
          Ok(field) => schema_version = field
          Err(error) => return Err(error)
        }
      (3, 0) =>
        match reader.read_uint64() {
          Ok(field) => sequence = field
          Err(error) => return Err(error)
        }
      (4, 0) =>
        match reader.read_uint64() {
          Ok(field) => source_time_ns = field
          Err(error) => return Err(error)
        }
      (5, 2) =>
        match reader.read_string() {
          Ok(field) => source_id = field
          Err(error) => return Err(error)
        }
      (6, 2) =>
        match reader.read_string() {
          Ok(field) => frame_id = field
          Err(error) => return Err(error)
        }
      (7, 0) =>
        match reader.read_uint32() {
          Ok(field) => encoding = int_to_encoding(field)
          Err(error) => return Err(error)
        }
      (8, 2) =>
        match reader.read_bytes() {
          Ok(field) => payload = field
          Err(error) => return Err(error)
        }
      (_, _) =>
        match reader.skip(wire_type) {
          Ok(_) => ()
          Err(error) => return Err(error)
        }
    }
  }
  Ok(Envelope::{
    schema_id,
    schema_version,
    sequence,
    source_time_ns,
    source_id,
    frame_id,
    encoding,
    payload,
  })
}

///|
pub fn encode_point(value : Point) -> Bytes {
  let writer = ProtoWriter::new()
  writer.write_float(1, value.x)
  writer.write_float(2, value.y)
  writer.write_float(3, value.z)
  writer.finish()
}

///|
pub fn decode_point(bytes : Bytes) -> Result[Point, String] {
  let reader = ProtoReader::new(bytes)
  let mut x : Float = 0.0
  let mut y : Float = 0.0
  let mut z : Float = 0.0
  while reader.position < reader.bytes.length() {
    let (field_number, wire_type) = match reader.read_key() {
      Ok(key) => key
      Err(error) => return Err(error)
    }
    match (field_number, wire_type) {
      (1, 5) =>
        match reader.read_float() {
          Ok(field) => x = field
          Err(error) => return Err(error)
        }
      (2, 5) =>
        match reader.read_float() {
          Ok(field) => y = field
          Err(error) => return Err(error)
        }
      (3, 5) =>
        match reader.read_float() {
          Ok(field) => z = field
          Err(error) => return Err(error)
        }
      (_, _) =>
        match reader.skip(wire_type) {
          Ok(_) => ()
          Err(error) => return Err(error)
        }
    }
  }
  Ok(Point::{ x, y, z, })
}

///|
pub fn encode_quaternion(value : Quaternion) -> Bytes {
  let writer = ProtoWriter::new()
  writer.write_float(1, value.x)
  writer.write_float(2, value.y)
  writer.write_float(3, value.z)
  writer.write_float(4, value.w)
  writer.finish()
}

///|
pub fn decode_quaternion(bytes : Bytes) -> Result[Quaternion, String] {
  let reader = ProtoReader::new(bytes)
  let mut x : Float = 0.0
  let mut y : Float = 0.0
  let mut z : Float = 0.0
  let mut w : Float = 1.0
  while reader.position < reader.bytes.length() {
    let (field_number, wire_type) = match reader.read_key() {
      Ok(key) => key
      Err(error) => return Err(error)
    }
    match (field_number, wire_type) {
      (1, 5) =>
        match reader.read_float() {
          Ok(field) => x = field
          Err(error) => return Err(error)
        }
      (2, 5) =>
        match reader.read_float() {
          Ok(field) => y = field
          Err(error) => return Err(error)
        }
      (3, 5) =>
        match reader.read_float() {
          Ok(field) => z = field
          Err(error) => return Err(error)
        }
      (4, 5) =>
        match reader.read_float() {
          Ok(field) => w = field
          Err(error) => return Err(error)
        }
      (_, _) =>
        match reader.skip(wire_type) {
          Ok(_) => ()
          Err(error) => return Err(error)
        }
    }
  }
  Ok(Quaternion::{ x, y, z, w, })
}

///|
pub fn encode_pose(value : Pose) -> Bytes {
  let writer = ProtoWriter::new()
  writer.write_message(1, encode_point(value.position))
  writer.write_message(2, encode_quaternion(value.orientation))
  writer.finish()
}

///|
pub fn decode_pose(bytes : Bytes) -> Result[Pose, String] {
  let reader = ProtoReader::new(bytes)
  let mut position = Point::{ x: 0.0, y: 0.0, z: 0.0, }
  let mut orientation = Quaternion::{ x: 0.0, y: 0.0, z: 0.0, w: 1.0, }
  while reader.position < reader.bytes.length() {
    let (field_number, wire_type) = match reader.read_key() {
      Ok(key) => key
      Err(error) => return Err(error)
    }
    match (field_number, wire_type) {
      (1, 2) =>
        match reader.read_bytes() {
          Ok(field) =>
            match decode_point(field) {
              Ok(decoded) => position = decoded
              Err(error) => return Err(error)
            }
          Err(error) => return Err(error)
        }
      (2, 2) =>
        match reader.read_bytes() {
          Ok(field) =>
            match decode_quaternion(field) {
              Ok(decoded) => orientation = decoded
              Err(error) => return Err(error)
            }
          Err(error) => return Err(error)
        }
      (_, _) =>
        match reader.skip(wire_type) {
          Ok(_) => ()
          Err(error) => return Err(error)
        }
    }
  }
  Ok(Pose::{ position, orientation, })
}

///|
pub fn encode_device_data_timestamp(value : DeviceDataTimestamp) -> Bytes {
  let writer = ProtoWriter::new()
  if value.available_time_local_common_clock != 0L {
    writer.write_int64(1, value.available_time_local_common_clock)
  }
  if value.sample_time_local_common_clock != 0L {
    writer.write_int64(2, value.sample_time_local_common_clock)
  }
  if value.sample_time_raw_device_clock != 0L {
    writer.write_int64(3, value.sample_time_raw_device_clock)
  }
  writer.finish()
}

///|
pub fn decode_device_data_timestamp(
  bytes : Bytes,
) -> Result[DeviceDataTimestamp, String] {
  let reader = ProtoReader::new(bytes)
  let mut available_time_local_common_clock = 0L
  let mut sample_time_local_common_clock = 0L
  let mut sample_time_raw_device_clock = 0L
  while reader.position < reader.bytes.length() {
    let (field_number, wire_type) = match reader.read_key() {
      Ok(key) => key
      Err(error) => return Err(error)
    }
    match (field_number, wire_type) {
      (1, 0) =>
        match reader.read_int64() {
          Ok(field) => available_time_local_common_clock = field
          Err(error) => return Err(error)
        }
      (2, 0) =>
        match reader.read_int64() {
          Ok(field) => sample_time_local_common_clock = field
          Err(error) => return Err(error)
        }
      (3, 0) =>
        match reader.read_int64() {
          Ok(field) => sample_time_raw_device_clock = field
          Err(error) => return Err(error)
        }
      (_, _) =>
        match reader.skip(wire_type) {
          Ok(_) => ()
          Err(error) => return Err(error)
        }
    }
  }
  Ok(DeviceDataTimestamp::{
    available_time_local_common_clock,
    sample_time_local_common_clock,
    sample_time_raw_device_clock,
  })
}

///|
pub fn encode_head_pose(value : HeadPose) -> Bytes {
  let writer = ProtoWriter::new()
  writer.write_message(1, encode_pose(value.pose))
  if value.is_valid {
    writer.write_bool(2, true)
  }
  if value.is_tracked {
    writer.write_bool(3, true)
  }
  writer.finish()
}

///|
pub fn decode_head_pose(bytes : Bytes) -> Result[HeadPose, String] {
  let reader = ProtoReader::new(bytes)
  let mut pose = Pose::{
    position: Point::{ x: 0.0, y: 0.0, z: 0.0, },
    orientation: Quaternion::{ x: 0.0, y: 0.0, z: 0.0, w: 1.0, },
  }
  let mut is_valid = false
  let mut is_tracked = false
  while reader.position < reader.bytes.length() {
    let (field_number, wire_type) = match reader.read_key() {
      Ok(key) => key
      Err(error) => return Err(error)
    }
    match (field_number, wire_type) {
      (1, 2) =>
        match reader.read_bytes() {
          Ok(field) =>
            match decode_pose(field) {
              Ok(decoded) => pose = decoded
              Err(error) => return Err(error)
            }
          Err(error) => return Err(error)
        }
      (2, 0) =>
        match reader.read_bool() {
          Ok(field) => is_valid = field
          Err(error) => return Err(error)
        }
      (3, 0) =>
        match reader.read_bool() {
          Ok(field) => is_tracked = field
          Err(error) => return Err(error)
        }
      (_, _) =>
        match reader.skip(wire_type) {
          Ok(_) => ()
          Err(error) => return Err(error)
        }
    }
  }
  Ok(HeadPose::{ pose, is_valid, is_tracked, })
}

///|
pub fn encode_head_pose_record(value : HeadPoseRecord) -> Bytes {
  let writer = ProtoWriter::new()
  writer.write_message(1, encode_head_pose(value.data))
  writer.write_message(2, encode_device_data_timestamp(value.timestamp))
  writer.finish()
}

///|
pub fn decode_head_pose_record(bytes : Bytes) -> Result[HeadPoseRecord, String] {
  let reader = ProtoReader::new(bytes)
  let mut data = HeadPose::{
    pose: Pose::{
      position: Point::{ x: 0.0, y: 0.0, z: 0.0, },
      orientation: Quaternion::{ x: 0.0, y: 0.0, z: 0.0, w: 1.0, },
    },
    is_valid: false,
    is_tracked: false,
  }
  let mut timestamp = DeviceDataTimestamp::{
    available_time_local_common_clock: 0L,
    sample_time_local_common_clock: 0L,
    sample_time_raw_device_clock: 0L,
  }
  while reader.position < reader.bytes.length() {
    let (field_number, wire_type) = match reader.read_key() {
      Ok(key) => key
      Err(error) => return Err(error)
    }
    match (field_number, wire_type) {
      (1, 2) =>
        match reader.read_bytes() {
          Ok(field) =>
            match decode_head_pose(field) {
              Ok(decoded) => data = decoded
              Err(error) => return Err(error)
            }
          Err(error) => return Err(error)
        }
      (2, 2) =>
        match reader.read_bytes() {
          Ok(field) =>
            match decode_device_data_timestamp(field) {
              Ok(decoded) => timestamp = decoded
              Err(error) => return Err(error)
            }
          Err(error) => return Err(error)
        }
      (_, _) =>
        match reader.skip(wire_type) {
          Ok(_) => ()
          Err(error) => return Err(error)
        }
    }
  }
  Ok(HeadPoseRecord::{ data, timestamp, })
}

///|
pub fn encode_controller_input_state(value : ControllerInputState) -> Bytes {
  let writer = ProtoWriter::new()
  if value.primary_click {
    writer.write_bool(1, true)
  }
  if value.secondary_click {
    writer.write_bool(2, true)
  }
  if value.thumbstick_click {
    writer.write_bool(3, true)
  }
  if value.menu_click {
    writer.write_bool(4, true)
  }
  if value.thumbstick_x != 0.0 {
    writer.write_float(5, value.thumbstick_x)
  }
  if value.thumbstick_y != 0.0 {
    writer.write_float(6, value.thumbstick_y)
  }
  if value.squeeze_value != 0.0 {
    writer.write_float(7, value.squeeze_value)
  }
  if value.trigger_value != 0.0 {
    writer.write_float(8, value.trigger_value)
  }
  writer.finish()
}

///|
pub fn decode_controller_input_state(
  bytes : Bytes,
) -> Result[ControllerInputState, String] {
  let reader = ProtoReader::new(bytes)
  let mut primary_click = false
  let mut secondary_click = false
  let mut thumbstick_click = false
  let mut menu_click = false
  let mut thumbstick_x : Float = 0.0
  let mut thumbstick_y : Float = 0.0
  let mut squeeze_value : Float = 0.0
  let mut trigger_value : Float = 0.0
  while reader.position < reader.bytes.length() {
    let (field_number, wire_type) = match reader.read_key() {
      Ok(key) => key
      Err(error) => return Err(error)
    }
    match (field_number, wire_type) {
      (1, 0) =>
        match reader.read_bool() {
          Ok(field) => primary_click = field
          Err(error) => return Err(error)
        }
      (2, 0) =>
        match reader.read_bool() {
          Ok(field) => secondary_click = field
          Err(error) => return Err(error)
        }
      (3, 0) =>
        match reader.read_bool() {
          Ok(field) => thumbstick_click = field
          Err(error) => return Err(error)
        }
      (4, 0) =>
        match reader.read_bool() {
          Ok(field) => menu_click = field
          Err(error) => return Err(error)
        }
      (5, 5) =>
        match reader.read_float() {
          Ok(field) => thumbstick_x = field
          Err(error) => return Err(error)
        }
      (6, 5) =>
        match reader.read_float() {
          Ok(field) => thumbstick_y = field
          Err(error) => return Err(error)
        }
      (7, 5) =>
        match reader.read_float() {
          Ok(field) => squeeze_value = field
          Err(error) => return Err(error)
        }
      (8, 5) =>
        match reader.read_float() {
          Ok(field) => trigger_value = field
          Err(error) => return Err(error)
        }
      (_, _) =>
        match reader.skip(wire_type) {
          Ok(_) => ()
          Err(error) => return Err(error)
        }
    }
  }
  Ok(ControllerInputState::{
    primary_click,
    secondary_click,
    thumbstick_click,
    menu_click,
    thumbstick_x,
    thumbstick_y,
    squeeze_value,
    trigger_value,
  })
}

///|
fn encode_controller_pose(value : ControllerPose) -> Bytes {
  let writer = ProtoWriter::new()
  writer.write_message(1, encode_pose(value.pose))
  if value.is_valid {
    writer.write_bool(2, true)
  }
  writer.finish()
}

///|
fn decode_controller_pose(bytes : Bytes) -> Result[ControllerPose, String] {
  let reader = ProtoReader::new(bytes)
  let mut pose = Pose::{
    position: Point::{ x: 0.0, y: 0.0, z: 0.0, },
    orientation: Quaternion::{ x: 0.0, y: 0.0, z: 0.0, w: 1.0, },
  }
  let mut is_valid = false
  while reader.position < reader.bytes.length() {
    let (field_number, wire_type) = match reader.read_key() {
      Ok(key) => key
      Err(error) => return Err(error)
    }
    match (field_number, wire_type) {
      (1, 2) =>
        match reader.read_bytes() {
          Ok(field) =>
            match decode_pose(field) {
              Ok(decoded) => pose = decoded
              Err(error) => return Err(error)
            }
          Err(error) => return Err(error)
        }
      (2, 0) =>
        match reader.read_bool() {
          Ok(field) => is_valid = field
          Err(error) => return Err(error)
        }
      (_, _) =>
        match reader.skip(wire_type) {
          Ok(_) => ()
          Err(error) => return Err(error)
        }
    }
  }
  Ok(ControllerPose::{ pose, is_valid, })
}

///|
pub fn encode_controller_snapshot(value : ControllerSnapshot) -> Bytes {
  let writer = ProtoWriter::new()
  writer.write_message(1, encode_controller_pose(value.grip_pose))
  writer.write_message(2, encode_controller_pose(value.aim_pose))
  writer.write_message(3, encode_controller_input_state(value.inputs))
  writer.finish()
}

///|
pub fn decode_controller_snapshot(
  bytes : Bytes,
) -> Result[ControllerSnapshot, String] {
  let reader = ProtoReader::new(bytes)
  let mut grip_pose = ControllerPose::{
    pose: Pose::{
      position: Point::{ x: 0.0, y: 0.0, z: 0.0, },
      orientation: Quaternion::{ x: 0.0, y: 0.0, z: 0.0, w: 1.0, },
    },
    is_valid: false,
  }
  let mut aim_pose = grip_pose
  let mut inputs = ControllerInputState::{
    primary_click: false,
    secondary_click: false,
    thumbstick_click: false,
    menu_click: false,
    thumbstick_x: 0.0,
    thumbstick_y: 0.0,
    squeeze_value: 0.0,
    trigger_value: 0.0,
  }
  while reader.position < reader.bytes.length() {
    let (field_number, wire_type) = match reader.read_key() {
      Ok(key) => key
      Err(error) => return Err(error)
    }
    match (field_number, wire_type) {
      (1, 2) =>
        match reader.read_bytes() {
          Ok(field) =>
            match decode_controller_pose(field) {
              Ok(decoded) => grip_pose = decoded
              Err(error) => return Err(error)
            }
          Err(error) => return Err(error)
        }
      (2, 2) =>
        match reader.read_bytes() {
          Ok(field) =>
            match decode_controller_pose(field) {
              Ok(decoded) => aim_pose = decoded
              Err(error) => return Err(error)
            }
          Err(error) => return Err(error)
        }
      (3, 2) =>
        match reader.read_bytes() {
          Ok(field) =>
            match decode_controller_input_state(field) {
              Ok(decoded) => inputs = decoded
              Err(error) => return Err(error)
            }
          Err(error) => return Err(error)
        }
      (_, _) =>
        match reader.skip(wire_type) {
          Ok(_) => ()
          Err(error) => return Err(error)
        }
    }
  }
  Ok(ControllerSnapshot::{ grip_pose, aim_pose, inputs, })
}

///|
pub fn encode_controller_snapshot_record(
  value : ControllerSnapshotRecord,
) -> Bytes {
  let writer = ProtoWriter::new()
  writer.write_message(1, encode_controller_snapshot(value.data))
  writer.write_message(2, encode_device_data_timestamp(value.timestamp))
  writer.finish()
}

///|
pub fn decode_controller_snapshot_record(
  bytes : Bytes,
) -> Result[ControllerSnapshotRecord, String] {
  let reader = ProtoReader::new(bytes)
  let mut data = ControllerSnapshot::{
    grip_pose: ControllerPose::{
      pose: Pose::{
        position: Point::{ x: 0.0, y: 0.0, z: 0.0, },
        orientation: Quaternion::{ x: 0.0, y: 0.0, z: 0.0, w: 1.0, },
      },
      is_valid: false,
    },
    aim_pose: ControllerPose::{
      pose: Pose::{
        position: Point::{ x: 0.0, y: 0.0, z: 0.0, },
        orientation: Quaternion::{ x: 0.0, y: 0.0, z: 0.0, w: 1.0, },
      },
      is_valid: false,
    },
    inputs: ControllerInputState::{
      primary_click: false,
      secondary_click: false,
      thumbstick_click: false,
      menu_click: false,
      thumbstick_x: 0.0,
      thumbstick_y: 0.0,
      squeeze_value: 0.0,
      trigger_value: 0.0,
    },
  }
  let mut timestamp = DeviceDataTimestamp::{
    available_time_local_common_clock: 0L,
    sample_time_local_common_clock: 0L,
    sample_time_raw_device_clock: 0L,
  }
  while reader.position < reader.bytes.length() {
    let (field_number, wire_type) = match reader.read_key() {
      Ok(key) => key
      Err(error) => return Err(error)
    }
    match (field_number, wire_type) {
      (1, 2) =>
        match reader.read_bytes() {
          Ok(field) =>
            match decode_controller_snapshot(field) {
              Ok(decoded) => data = decoded
              Err(error) => return Err(error)
            }
          Err(error) => return Err(error)
        }
      (2, 2) =>
        match reader.read_bytes() {
          Ok(field) =>
            match decode_device_data_timestamp(field) {
              Ok(decoded) => timestamp = decoded
              Err(error) => return Err(error)
            }
          Err(error) => return Err(error)
        }
      (_, _) =>
        match reader.skip(wire_type) {
          Ok(_) => ()
          Err(error) => return Err(error)
        }
    }
  }
  Ok(ControllerSnapshotRecord::{ data, timestamp, })
}

///|
fn encode_hand_joint_pose(value : HandJointPose) -> Bytes {
  let writer = ProtoWriter::new()
  writer.write_message(1, encode_pose(value.pose))
  if value.is_valid {
    writer.write_bool(2, true)
  }
  if value.radius != 0.0 {
    writer.write_float(3, value.radius)
  }
  writer.finish()
}

///|
fn decode_hand_joint_pose(bytes : Bytes) -> Result[HandJointPose, String] {
  let reader = ProtoReader::new(bytes)
  let mut pose = Pose::{
    position: Point::{ x: 0.0, y: 0.0, z: 0.0, },
    orientation: Quaternion::{ x: 0.0, y: 0.0, z: 0.0, w: 1.0, },
  }
  let mut is_valid = false
  let mut radius : Float = 0.0
  while reader.position < reader.bytes.length() {
    let (field_number, wire_type) = match reader.read_key() {
      Ok(key) => key
      Err(error) => return Err(error)
    }
    match (field_number, wire_type) {
      (1, 2) =>
        match reader.read_bytes() {
          Ok(field) =>
            match decode_pose(field) {
              Ok(decoded) => pose = decoded
              Err(error) => return Err(error)
            }
          Err(error) => return Err(error)
        }
      (2, 0) =>
        match reader.read_bool() {
          Ok(field) => is_valid = field
          Err(error) => return Err(error)
        }
      (3, 5) =>
        match reader.read_float() {
          Ok(field) => radius = field
          Err(error) => return Err(error)
        }
      (_, _) =>
        match reader.skip(wire_type) {
          Ok(_) => ()
          Err(error) => return Err(error)
        }
    }
  }
  Ok(HandJointPose::{ pose, is_valid, radius, })
}

///|
fn encode_hand_joints(value : HandJoints) -> Bytes {
  let writer = ProtoWriter::new()
  for pose in value.poses {
    writer.write_message(1, encode_hand_joint_pose(pose))
  }
  writer.finish()
}

///|
fn decode_hand_joints(bytes : Bytes) -> Result[HandJoints, String] {
  let reader = ProtoReader::new(bytes)
  let poses : Array[HandJointPose] = []
  while reader.position < reader.bytes.length() {
    let (field_number, wire_type) = match reader.read_key() {
      Ok(key) => key
      Err(error) => return Err(error)
    }
    match (field_number, wire_type) {
      (1, 2) =>
        match reader.read_bytes() {
          Ok(field) =>
            match decode_hand_joint_pose(field) {
              Ok(decoded) => poses.push(decoded)
              Err(error) => return Err(error)
            }
          Err(error) => return Err(error)
        }
      (_, _) =>
        match reader.skip(wire_type) {
          Ok(_) => ()
          Err(error) => return Err(error)
        }
    }
  }
  Ok(HandJoints::{ poses, })
}

///|
pub fn encode_hand_pose(value : HandPose) -> Bytes {
  let writer = ProtoWriter::new()
  writer.write_message(1, encode_hand_joints(value.joints))
  writer.finish()
}

///|
pub fn decode_hand_pose(bytes : Bytes) -> Result[HandPose, String] {
  let reader = ProtoReader::new(bytes)
  let mut joints = HandJoints::{ poses: [], }
  while reader.position < reader.bytes.length() {
    let (field_number, wire_type) = match reader.read_key() {
      Ok(key) => key
      Err(error) => return Err(error)
    }
    match (field_number, wire_type) {
      (1, 2) =>
        match reader.read_bytes() {
          Ok(field) =>
            match decode_hand_joints(field) {
              Ok(decoded) => joints = decoded
              Err(error) => return Err(error)
            }
          Err(error) => return Err(error)
        }
      (_, _) =>
        match reader.skip(wire_type) {
          Ok(_) => ()
          Err(error) => return Err(error)
        }
    }
  }
  Ok(HandPose::{ joints, })
}

///|
pub fn encode_hand_pose_record(value : HandPoseRecord) -> Bytes {
  let writer = ProtoWriter::new()
  writer.write_message(1, encode_hand_pose(value.data))
  writer.write_message(2, encode_device_data_timestamp(value.timestamp))
  writer.finish()
}

///|
pub fn decode_hand_pose_record(bytes : Bytes) -> Result[HandPoseRecord, String] {
  let reader = ProtoReader::new(bytes)
  let mut data = HandPose::{ joints: HandJoints::{ poses: [], }, }
  let mut timestamp = DeviceDataTimestamp::{
    available_time_local_common_clock: 0L,
    sample_time_local_common_clock: 0L,
    sample_time_raw_device_clock: 0L,
  }
  while reader.position < reader.bytes.length() {
    let (field_number, wire_type) = match reader.read_key() {
      Ok(key) => key
      Err(error) => return Err(error)
    }
    match (field_number, wire_type) {
      (1, 2) =>
        match reader.read_bytes() {
          Ok(field) =>
            match decode_hand_pose(field) {
              Ok(decoded) => data = decoded
              Err(error) => return Err(error)
            }
          Err(error) => return Err(error)
        }
      (2, 2) =>
        match reader.read_bytes() {
          Ok(field) =>
            match decode_device_data_timestamp(field) {
              Ok(decoded) => timestamp = decoded
              Err(error) => return Err(error)
            }
          Err(error) => return Err(error)
        }
      (_, _) =>
        match reader.skip(wire_type) {
          Ok(_) => ()
          Err(error) => return Err(error)
        }
    }
  }
  Ok(HandPoseRecord::{ data, timestamp, })
}

///|
fn encode_joint_state(value : JointState) -> Bytes {
  let writer = ProtoWriter::new()
  if value.name != "" {
    writer.write_string(1, value.name)
  }
  if value.position != 0.0 {
    writer.write_float(2, value.position)
  }
  if value.velocity != 0.0 {
    writer.write_float(3, value.velocity)
  }
  if value.effort != 0.0 {
    writer.write_float(4, value.effort)
  }
  if value.valid == false {
    writer.write_bool(5, false)
  }
  writer.finish()
}

///|
fn decode_joint_state(bytes : Bytes) -> Result[JointState, String] {
  let reader = ProtoReader::new(bytes)
  let mut name = ""
  let mut position : Float = 0.0
  let mut velocity : Float = 0.0
  let mut effort : Float = 0.0
  let mut valid = true
  while reader.position < reader.bytes.length() {
    let (field_number, wire_type) = match reader.read_key() {
      Ok(key) => key
      Err(error) => return Err(error)
    }
    match (field_number, wire_type) {
      (1, 2) =>
        match reader.read_string() {
          Ok(field) => name = field
          Err(error) => return Err(error)
        }
      (2, 5) =>
        match reader.read_float() {
          Ok(field) => position = field
          Err(error) => return Err(error)
        }
      (3, 5) =>
        match reader.read_float() {
          Ok(field) => velocity = field
          Err(error) => return Err(error)
        }
      (4, 5) =>
        match reader.read_float() {
          Ok(field) => effort = field
          Err(error) => return Err(error)
        }
      (5, 0) =>
        match reader.read_bool() {
          Ok(field) => valid = field
          Err(error) => return Err(error)
        }
      (_, _) =>
        match reader.skip(wire_type) {
          Ok(_) => ()
          Err(error) => return Err(error)
        }
    }
  }
  Ok(JointState::{ name, position, velocity, effort, valid, })
}

///|
pub fn encode_joint_state_output(value : JointStateOutput) -> Bytes {
  let writer = ProtoWriter::new()
  for joint in value.joints {
    writer.write_message(1, encode_joint_state(joint))
  }
  if value.device_id != "" {
    writer.write_string(2, value.device_id)
  }
  if value.has_velocity {
    writer.write_bool(3, true)
  }
  if value.has_effort {
    writer.write_bool(4, true)
  }
  match value.ee_pose {
    Some(pose) => writer.write_message(5, encode_pose(pose))
    None => ()
  }
  if value.ee_pose_valid {
    writer.write_bool(6, true)
  }
  writer.finish()
}

///|
pub fn decode_joint_state_output(
  bytes : Bytes,
) -> Result[JointStateOutput, String] {
  let reader = ProtoReader::new(bytes)
  let joints : Array[JointState] = []
  let mut device_id = ""
  let mut has_velocity = false
  let mut has_effort = false
  let mut ee_pose : Pose? = None
  let mut ee_pose_valid = false
  while reader.position < reader.bytes.length() {
    let (field_number, wire_type) = match reader.read_key() {
      Ok(key) => key
      Err(error) => return Err(error)
    }
    match (field_number, wire_type) {
      (1, 2) =>
        match reader.read_bytes() {
          Ok(field) =>
            match decode_joint_state(field) {
              Ok(decoded) => joints.push(decoded)
              Err(error) => return Err(error)
            }
          Err(error) => return Err(error)
        }
      (2, 2) =>
        match reader.read_string() {
          Ok(field) => device_id = field
          Err(error) => return Err(error)
        }
      (3, 0) =>
        match reader.read_bool() {
          Ok(field) => has_velocity = field
          Err(error) => return Err(error)
        }
      (4, 0) =>
        match reader.read_bool() {
          Ok(field) => has_effort = field
          Err(error) => return Err(error)
        }
      (5, 2) =>
        match reader.read_bytes() {
          Ok(field) =>
            match decode_pose(field) {
              Ok(decoded) => ee_pose = Some(decoded)
              Err(error) => return Err(error)
            }
          Err(error) => return Err(error)
        }
      (6, 0) =>
        match reader.read_bool() {
          Ok(field) => ee_pose_valid = field
          Err(error) => return Err(error)
        }
      (_, _) =>
        match reader.skip(wire_type) {
          Ok(_) => ()
          Err(error) => return Err(error)
        }
    }
  }
  Ok(JointStateOutput::{
    joints,
    device_id,
    has_velocity,
    has_effort,
    ee_pose,
    ee_pose_valid,
  })
}

///|
pub fn encode_joint_state_output_record(
  value : JointStateOutputRecord,
) -> Bytes {
  let writer = ProtoWriter::new()
  writer.write_message(1, encode_joint_state_output(value.data))
  writer.write_message(2, encode_device_data_timestamp(value.timestamp))
  writer.finish()
}

///|
pub fn decode_joint_state_output_record(
  bytes : Bytes,
) -> Result[JointStateOutputRecord, String] {
  let reader = ProtoReader::new(bytes)
  let mut data = JointStateOutput::{
    joints: [],
    device_id: "",
    has_velocity: false,
    has_effort: false,
    ee_pose: None,
    ee_pose_valid: false,
  }
  let mut timestamp = DeviceDataTimestamp::{
    available_time_local_common_clock: 0L,
    sample_time_local_common_clock: 0L,
    sample_time_raw_device_clock: 0L,
  }
  while reader.position < reader.bytes.length() {
    let (field_number, wire_type) = match reader.read_key() {
      Ok(key) => key
      Err(error) => return Err(error)
    }
    match (field_number, wire_type) {
      (1, 2) =>
        match reader.read_bytes() {
          Ok(field) =>
            match decode_joint_state_output(field) {
              Ok(decoded) => data = decoded
              Err(error) => return Err(error)
            }
          Err(error) => return Err(error)
        }
      (2, 2) =>
        match reader.read_bytes() {
          Ok(field) =>
            match decode_device_data_timestamp(field) {
              Ok(decoded) => timestamp = decoded
              Err(error) => return Err(error)
            }
          Err(error) => return Err(error)
        }
      (_, _) =>
        match reader.skip(wire_type) {
          Ok(_) => ()
          Err(error) => return Err(error)
        }
    }
  }
  Ok(JointStateOutputRecord::{ data, timestamp, })
}
