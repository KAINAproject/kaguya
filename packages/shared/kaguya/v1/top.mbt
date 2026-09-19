///|
pub(all) enum Encoding {
  ENCODING_UNSPECIFIED
  ENCODING_PROTOBUF
  ENCODING_JSON
  ENCODING_JPEG
  ENCODING_WEBP
  Unknown(@lib.Enum)
} derive(Eq, Debug)

///|
pub fn Encoding::to_enum(self : Encoding) -> @lib.Enum {
  match self {
    Encoding::ENCODING_UNSPECIFIED => 0
    Encoding::ENCODING_PROTOBUF => 1
    Encoding::ENCODING_JSON => 2
    Encoding::ENCODING_JPEG => 3
    Encoding::ENCODING_WEBP => 4
    Encoding::Unknown(value) => value
  }
}

///|
pub fn Encoding::from_enum(i : @lib.Enum) -> Encoding {
  match i.0 {
    0 => Encoding::ENCODING_UNSPECIFIED
    1 => Encoding::ENCODING_PROTOBUF
    2 => Encoding::ENCODING_JSON
    3 => Encoding::ENCODING_JPEG
    4 => Encoding::ENCODING_WEBP
    _ => Encoding::Unknown(i)
  }
}

///|
pub impl Default for Encoding with fn default() -> Encoding {
  Encoding::ENCODING_UNSPECIFIED
}

///|
pub impl @lib.Sized for Encoding with fn size_of(self : Encoding) {
  @lib.Sized::size_of(self.to_enum())
}

///|
pub(all) enum FrameKind {
  FRAME_KIND_UNSPECIFIED
  FRAME_KIND_PUBLISH
  FRAME_KIND_SUBSCRIBE
  FRAME_KIND_UNSUBSCRIBE
  FRAME_KIND_DATA
  FRAME_KIND_ERROR
  Unknown(@lib.Enum)
} derive(Eq, Debug)

///|
pub fn FrameKind::to_enum(self : FrameKind) -> @lib.Enum {
  match self {
    FrameKind::FRAME_KIND_UNSPECIFIED => 0
    FrameKind::FRAME_KIND_PUBLISH => 1
    FrameKind::FRAME_KIND_SUBSCRIBE => 2
    FrameKind::FRAME_KIND_UNSUBSCRIBE => 3
    FrameKind::FRAME_KIND_DATA => 4
    FrameKind::FRAME_KIND_ERROR => 5
    FrameKind::Unknown(value) => value
  }
}

///|
pub fn FrameKind::from_enum(i : @lib.Enum) -> FrameKind {
  match i.0 {
    0 => FrameKind::FRAME_KIND_UNSPECIFIED
    1 => FrameKind::FRAME_KIND_PUBLISH
    2 => FrameKind::FRAME_KIND_SUBSCRIBE
    3 => FrameKind::FRAME_KIND_UNSUBSCRIBE
    4 => FrameKind::FRAME_KIND_DATA
    5 => FrameKind::FRAME_KIND_ERROR
    _ => FrameKind::Unknown(i)
  }
}

///|
pub impl Default for FrameKind with fn default() -> FrameKind {
  FrameKind::FRAME_KIND_UNSPECIFIED
}

///|
pub impl @lib.Sized for FrameKind with fn size_of(self : FrameKind) {
  @lib.Sized::size_of(self.to_enum())
}

///|
pub(all) enum HandJoint {
  HAND_JOINT_PALM
  HAND_JOINT_WRIST
  HAND_JOINT_THUMB_METACARPAL
  HAND_JOINT_THUMB_PROXIMAL
  HAND_JOINT_THUMB_DISTAL
  HAND_JOINT_THUMB_TIP
  HAND_JOINT_INDEX_METACARPAL
  HAND_JOINT_INDEX_PROXIMAL
  HAND_JOINT_INDEX_INTERMEDIATE
  HAND_JOINT_INDEX_DISTAL
  HAND_JOINT_INDEX_TIP
  HAND_JOINT_MIDDLE_METACARPAL
  HAND_JOINT_MIDDLE_PROXIMAL
  HAND_JOINT_MIDDLE_INTERMEDIATE
  HAND_JOINT_MIDDLE_DISTAL
  HAND_JOINT_MIDDLE_TIP
  HAND_JOINT_RING_METACARPAL
  HAND_JOINT_RING_PROXIMAL
  HAND_JOINT_RING_INTERMEDIATE
  HAND_JOINT_RING_DISTAL
  HAND_JOINT_RING_TIP
  HAND_JOINT_LITTLE_METACARPAL
  HAND_JOINT_LITTLE_PROXIMAL
  HAND_JOINT_LITTLE_INTERMEDIATE
  HAND_JOINT_LITTLE_DISTAL
  HAND_JOINT_LITTLE_TIP
  HAND_JOINT_NUM_JOINTS
  Unknown(@lib.Enum)
} derive(Eq, Debug)

///|
pub fn HandJoint::to_enum(self : HandJoint) -> @lib.Enum {
  match self {
    HandJoint::HAND_JOINT_PALM => 0
    HandJoint::HAND_JOINT_WRIST => 1
    HandJoint::HAND_JOINT_THUMB_METACARPAL => 2
    HandJoint::HAND_JOINT_THUMB_PROXIMAL => 3
    HandJoint::HAND_JOINT_THUMB_DISTAL => 4
    HandJoint::HAND_JOINT_THUMB_TIP => 5
    HandJoint::HAND_JOINT_INDEX_METACARPAL => 6
    HandJoint::HAND_JOINT_INDEX_PROXIMAL => 7
    HandJoint::HAND_JOINT_INDEX_INTERMEDIATE => 8
    HandJoint::HAND_JOINT_INDEX_DISTAL => 9
    HandJoint::HAND_JOINT_INDEX_TIP => 10
    HandJoint::HAND_JOINT_MIDDLE_METACARPAL => 11
    HandJoint::HAND_JOINT_MIDDLE_PROXIMAL => 12
    HandJoint::HAND_JOINT_MIDDLE_INTERMEDIATE => 13
    HandJoint::HAND_JOINT_MIDDLE_DISTAL => 14
    HandJoint::HAND_JOINT_MIDDLE_TIP => 15
    HandJoint::HAND_JOINT_RING_METACARPAL => 16
    HandJoint::HAND_JOINT_RING_PROXIMAL => 17
    HandJoint::HAND_JOINT_RING_INTERMEDIATE => 18
    HandJoint::HAND_JOINT_RING_DISTAL => 19
    HandJoint::HAND_JOINT_RING_TIP => 20
    HandJoint::HAND_JOINT_LITTLE_METACARPAL => 21
    HandJoint::HAND_JOINT_LITTLE_PROXIMAL => 22
    HandJoint::HAND_JOINT_LITTLE_INTERMEDIATE => 23
    HandJoint::HAND_JOINT_LITTLE_DISTAL => 24
    HandJoint::HAND_JOINT_LITTLE_TIP => 25
    HandJoint::HAND_JOINT_NUM_JOINTS => 26
    HandJoint::Unknown(value) => value
  }
}

///|
pub fn HandJoint::from_enum(i : @lib.Enum) -> HandJoint {
  match i.0 {
    0 => HandJoint::HAND_JOINT_PALM
    1 => HandJoint::HAND_JOINT_WRIST
    2 => HandJoint::HAND_JOINT_THUMB_METACARPAL
    3 => HandJoint::HAND_JOINT_THUMB_PROXIMAL
    4 => HandJoint::HAND_JOINT_THUMB_DISTAL
    5 => HandJoint::HAND_JOINT_THUMB_TIP
    6 => HandJoint::HAND_JOINT_INDEX_METACARPAL
    7 => HandJoint::HAND_JOINT_INDEX_PROXIMAL
    8 => HandJoint::HAND_JOINT_INDEX_INTERMEDIATE
    9 => HandJoint::HAND_JOINT_INDEX_DISTAL
    10 => HandJoint::HAND_JOINT_INDEX_TIP
    11 => HandJoint::HAND_JOINT_MIDDLE_METACARPAL
    12 => HandJoint::HAND_JOINT_MIDDLE_PROXIMAL
    13 => HandJoint::HAND_JOINT_MIDDLE_INTERMEDIATE
    14 => HandJoint::HAND_JOINT_MIDDLE_DISTAL
    15 => HandJoint::HAND_JOINT_MIDDLE_TIP
    16 => HandJoint::HAND_JOINT_RING_METACARPAL
    17 => HandJoint::HAND_JOINT_RING_PROXIMAL
    18 => HandJoint::HAND_JOINT_RING_INTERMEDIATE
    19 => HandJoint::HAND_JOINT_RING_DISTAL
    20 => HandJoint::HAND_JOINT_RING_TIP
    21 => HandJoint::HAND_JOINT_LITTLE_METACARPAL
    22 => HandJoint::HAND_JOINT_LITTLE_PROXIMAL
    23 => HandJoint::HAND_JOINT_LITTLE_INTERMEDIATE
    24 => HandJoint::HAND_JOINT_LITTLE_DISTAL
    25 => HandJoint::HAND_JOINT_LITTLE_TIP
    26 => HandJoint::HAND_JOINT_NUM_JOINTS
    _ => HandJoint::Unknown(i)
  }
}

///|
pub impl Default for HandJoint with fn default() -> HandJoint {
  HandJoint::HAND_JOINT_PALM
}

///|
pub impl @lib.Sized for HandJoint with fn size_of(self : HandJoint) {
  @lib.Sized::size_of(self.to_enum())
}

///|
pub(all) struct Envelope {
  mut schema_id : String
  mut schema_version : UInt
  mut sequence : UInt64
  mut source_time_ns : UInt64
  mut source_id : String
  mut frame_id : String
  mut encoding : Encoding
  mut payload : Bytes
} derive(Eq, Debug)

///|
pub impl @lib.Sized for Envelope with fn size_of(self) {
  let mut size = 0U
  if self.schema_id != Default::default() {
    size += @lib.size_of_length_delimited_field(
      1U,
      @lib.size_of(self.schema_id),
    )
  }
  if self.schema_version != Default::default() {
    size += @lib.size_of_field(2U, @lib.size_of(self.schema_version))
  }
  if self.sequence != Default::default() {
    size += @lib.size_of_field(3U, @lib.size_of(self.sequence))
  }
  if self.source_time_ns != Default::default() {
    size += @lib.size_of_field(4U, @lib.size_of(self.source_time_ns))
  }
  if self.source_id != Default::default() {
    size += @lib.size_of_length_delimited_field(
      5U,
      @lib.size_of(self.source_id),
    )
  }
  if self.frame_id != Default::default() {
    size += @lib.size_of_length_delimited_field(6U, @lib.size_of(self.frame_id))
  }
  if self.encoding != Default::default() {
    size += @lib.size_of_field(7U, @lib.size_of(self.encoding))
  }
  if self.payload != Default::default() {
    size += @lib.size_of_length_delimited_field(8U, @lib.size_of(self.payload))
  }
  size
}

///|
pub impl Default for Envelope with fn default() -> Envelope {
  Envelope::{
    schema_id: Default::default(),
    schema_version: Default::default(),
    sequence: Default::default(),
    source_time_ns: Default::default(),
    source_id: Default::default(),
    frame_id: Default::default(),
    encoding: Default::default(),
    payload: Default::default(),
  }
}

///|
#alias(new, deprecated)
pub fn Envelope::Envelope(
  schema_id : String,
  schema_version : UInt,
  sequence : UInt64,
  source_time_ns : UInt64,
  source_id : String,
  frame_id : String,
  encoding : Encoding,
  payload : Bytes,
) -> Envelope {
  Envelope::{
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
pub impl @lib.Read for Envelope with fn read_with_limit(
  reader : @lib.LimitedReader[&@lib.Reader],
) -> Envelope raise {
  let msg : Envelope = Default::default()
  while (reader |> @lib.read_next_message_field()) is Some((field_number, wire)) {
    match (field_number, wire) {
      (1, _) => msg.schema_id = reader |> @lib.read_string()
      (2, _) => msg.schema_version = reader |> @lib.read_uint32()
      (3, _) => msg.sequence = reader |> @lib.read_uint64()
      (4, _) => msg.source_time_ns = reader |> @lib.read_uint64()
      (5, _) => msg.source_id = reader |> @lib.read_string()
      (6, _) => msg.frame_id = reader |> @lib.read_string()
      (7, _) => msg.encoding = reader |> @lib.read_enum() |> Encoding::from_enum
      (8, _) => msg.payload = reader |> @lib.read_bytes()
      _ => reader |> @lib.skip_message_field_by_number(field_number, wire)
    }
  }
  msg
}

///|
pub impl @lib.Write for Envelope with fn write(
  self : Envelope,
  writer : &@lib.Writer,
) -> Unit raise {
  if self.schema_id != Default::default() {
    writer |> @lib.write_varint(10UL)
    writer |> @lib.write_string(self.schema_id)
  }
  if self.schema_version != Default::default() {
    writer |> @lib.write_varint(16UL)
    writer |> @lib.write_uint32(self.schema_version)
  }
  if self.sequence != Default::default() {
    writer |> @lib.write_varint(24UL)
    writer |> @lib.write_uint64(self.sequence)
  }
  if self.source_time_ns != Default::default() {
    writer |> @lib.write_varint(32UL)
    writer |> @lib.write_uint64(self.source_time_ns)
  }
  if self.source_id != Default::default() {
    writer |> @lib.write_varint(42UL)
    writer |> @lib.write_string(self.source_id)
  }
  if self.frame_id != Default::default() {
    writer |> @lib.write_varint(50UL)
    writer |> @lib.write_string(self.frame_id)
  }
  if self.encoding != Default::default() {
    writer |> @lib.write_varint(56UL)
    writer |> @lib.write_enum(self.encoding.to_enum())
  }
  if self.payload != Default::default() {
    writer |> @lib.write_varint(66UL)
    writer |> @lib.write_bytes(self.payload)
  }
}

///|
pub(all) struct Frame {
  mut kind : FrameKind
  mut topic : String
  mut envelope : Envelope?
  mut error : String
} derive(Eq, Debug)

///|
pub impl @lib.Sized for Frame with fn size_of(self) {
  let mut size = 0U
  if self.kind != Default::default() {
    size += @lib.size_of_field(1U, @lib.size_of(self.kind))
  }
  if self.topic != Default::default() {
    size += @lib.size_of_length_delimited_field(2U, @lib.size_of(self.topic))
  }
  if self.envelope is Some(v) {
    size += @lib.size_of_length_delimited_field(3U, @lib.size_of(v))
  }
  if self.error != Default::default() {
    size += @lib.size_of_length_delimited_field(4U, @lib.size_of(self.error))
  }
  size
}

///|
pub impl Default for Frame with fn default() -> Frame {
  Frame::{
    kind: Default::default(),
    topic: Default::default(),
    envelope: None,
    error: Default::default(),
  }
}

///|
#alias(new, deprecated)
pub fn Frame::Frame(
  kind : FrameKind,
  topic : String,
  envelope? : Envelope,
  error : String,
) -> Frame {
  Frame::{ kind, topic, envelope, error, }
}

///|
pub impl @lib.Read for Frame with fn read_with_limit(
  reader : @lib.LimitedReader[&@lib.Reader],
) -> Frame raise {
  let msg : Frame = Default::default()
  while (reader |> @lib.read_next_message_field()) is Some((field_number, wire)) {
    match (field_number, wire) {
      (1, _) => msg.kind = reader |> @lib.read_enum() |> FrameKind::from_enum
      (2, _) => msg.topic = reader |> @lib.read_string()
      (3, @lib.WIRE_TYPE_LENGTH_DELIMITED) =>
        msg.envelope = (reader |> @lib.read_message() : Envelope) |> Some
      (4, _) => msg.error = reader |> @lib.read_string()
      _ => reader |> @lib.skip_message_field_by_number(field_number, wire)
    }
  }
  msg
}

///|
pub impl @lib.Write for Frame with fn write(self : Frame, writer : &@lib.Writer) -> Unit raise {
  if self.kind != Default::default() {
    writer |> @lib.write_varint(8UL)
    writer |> @lib.write_enum(self.kind.to_enum())
  }
  if self.topic != Default::default() {
    writer |> @lib.write_varint(18UL)
    writer |> @lib.write_string(self.topic)
  }
  if self.envelope is Some(v) {
    writer |> @lib.write_varint(26UL)
    writer |> @lib.write_message(v)
  }
  if self.error != Default::default() {
    writer |> @lib.write_varint(34UL)
    writer |> @lib.write_string(self.error)
  }
}

///|
pub(all) struct Point {
  mut x : Float
  mut y : Float
  mut z : Float
} derive(Eq, Debug)

///|
pub impl @lib.Sized for Point with fn size_of(self) {
  let mut size = 0U
  if self.x != Default::default() {
    size += @lib.size_of_field(1U, 4U)
  }
  if self.y != Default::default() {
    size += @lib.size_of_field(2U, 4U)
  }
  if self.z != Default::default() {
    size += @lib.size_of_field(3U, 4U)
  }
  size
}

///|
pub impl Default for Point with fn default() -> Point {
  Point::{
    x: Default::default(),
    y: Default::default(),
    z: Default::default(),
  }
}

///|
#alias(new, deprecated)
pub fn Point::Point(x : Float, y : Float, z : Float) -> Point {
  Point::{ x, y, z, }
}

///|
pub impl @lib.Read for Point with fn read_with_limit(
  reader : @lib.LimitedReader[&@lib.Reader],
) -> Point raise {
  let msg : Point = Default::default()
  while (reader |> @lib.read_next_message_field()) is Some((field_number, wire)) {
    match (field_number, wire) {
      (1, _) => msg.x = reader |> @lib.read_float()
      (2, _) => msg.y = reader |> @lib.read_float()
      (3, _) => msg.z = reader |> @lib.read_float()
      _ => reader |> @lib.skip_message_field_by_number(field_number, wire)
    }
  }
  msg
}

///|
pub impl @lib.Write for Point with fn write(self : Point, writer : &@lib.Writer) -> Unit raise {
  if self.x != Default::default() {
    writer |> @lib.write_varint(13UL)
    writer |> @lib.write_float(self.x)
  }
  if self.y != Default::default() {
    writer |> @lib.write_varint(21UL)
    writer |> @lib.write_float(self.y)
  }
  if self.z != Default::default() {
    writer |> @lib.write_varint(29UL)
    writer |> @lib.write_float(self.z)
  }
}

///|
pub(all) struct Quaternion {
  mut x : Float
  mut y : Float
  mut z : Float
  mut w : Float
} derive(Eq, Debug)

///|
pub impl @lib.Sized for Quaternion with fn size_of(self) {
  let mut size = 0U
  if self.x != Default::default() {
    size += @lib.size_of_field(1U, 4U)
  }
  if self.y != Default::default() {
    size += @lib.size_of_field(2U, 4U)
  }
  if self.z != Default::default() {
    size += @lib.size_of_field(3U, 4U)
  }
  if self.w != Default::default() {
    size += @lib.size_of_field(4U, 4U)
  }
  size
}

///|
pub impl Default for Quaternion with fn default() -> Quaternion {
  Quaternion::{
    x: Default::default(),
    y: Default::default(),
    z: Default::default(),
    w: Default::default(),
  }
}

///|
#alias(new, deprecated)
pub fn Quaternion::Quaternion(
  x : Float,
  y : Float,
  z : Float,
  w : Float,
) -> Quaternion {
  Quaternion::{ x, y, z, w, }
}

///|
pub impl @lib.Read for Quaternion with fn read_with_limit(
  reader : @lib.LimitedReader[&@lib.Reader],
) -> Quaternion raise {
  let msg : Quaternion = Default::default()
  while (reader |> @lib.read_next_message_field()) is Some((field_number, wire)) {
    match (field_number, wire) {
      (1, _) => msg.x = reader |> @lib.read_float()
      (2, _) => msg.y = reader |> @lib.read_float()
      (3, _) => msg.z = reader |> @lib.read_float()
      (4, _) => msg.w = reader |> @lib.read_float()
      _ => reader |> @lib.skip_message_field_by_number(field_number, wire)
    }
  }
  msg
}

///|
pub impl @lib.Write for Quaternion with fn write(
  self : Quaternion,
  writer : &@lib.Writer,
) -> Unit raise {
  if self.x != Default::default() {
    writer |> @lib.write_varint(13UL)
    writer |> @lib.write_float(self.x)
  }
  if self.y != Default::default() {
    writer |> @lib.write_varint(21UL)
    writer |> @lib.write_float(self.y)
  }
  if self.z != Default::default() {
    writer |> @lib.write_varint(29UL)
    writer |> @lib.write_float(self.z)
  }
  if self.w != Default::default() {
    writer |> @lib.write_varint(37UL)
    writer |> @lib.write_float(self.w)
  }
}

///|
pub(all) struct Pose {
  mut position : Point?
  mut orientation : Quaternion?
} derive(Eq, Debug)

///|
pub impl @lib.Sized for Pose with fn size_of(self) {
  let mut size = 0U
  if self.position is Some(v) {
    size += @lib.size_of_length_delimited_field(1U, @lib.size_of(v))
  }
  if self.orientation is Some(v) {
    size += @lib.size_of_length_delimited_field(2U, @lib.size_of(v))
  }
  size
}

///|
pub impl Default for Pose with fn default() -> Pose {
  Pose::{ position: None, orientation: None, }
}

///|
#alias(new, deprecated)
pub fn Pose::Pose(position? : Point, orientation? : Quaternion) -> Pose {
  Pose::{ position, orientation, }
}

///|
pub impl @lib.Read for Pose with fn read_with_limit(
  reader : @lib.LimitedReader[&@lib.Reader],
) -> Pose raise {
  let msg : Pose = Default::default()
  while (reader |> @lib.read_next_message_field()) is Some((field_number, wire)) {
    match (field_number, wire) {
      (1, @lib.WIRE_TYPE_LENGTH_DELIMITED) =>
        msg.position = (reader |> @lib.read_message() : Point) |> Some
      (2, @lib.WIRE_TYPE_LENGTH_DELIMITED) =>
        msg.orientation = (reader |> @lib.read_message() : Quaternion) |> Some
      _ => reader |> @lib.skip_message_field_by_number(field_number, wire)
    }
  }
  msg
}

///|
pub impl @lib.Write for Pose with fn write(self : Pose, writer : &@lib.Writer) -> Unit raise {
  if self.position is Some(v) {
    writer |> @lib.write_varint(10UL)
    writer |> @lib.write_message(v)
  }
  if self.orientation is Some(v) {
    writer |> @lib.write_varint(18UL)
    writer |> @lib.write_message(v)
  }
}

///|
pub(all) struct DeviceDataTimestamp {
  mut available_time_local_common_clock : Int64
  mut sample_time_local_common_clock : Int64
  mut sample_time_raw_device_clock : Int64
} derive(Eq, Debug)

///|
pub impl @lib.Sized for DeviceDataTimestamp with fn size_of(self) {
  let mut size = 0U
  if self.available_time_local_common_clock != Default::default() {
    size += @lib.size_of_field(
      1U,
      @lib.size_of(self.available_time_local_common_clock),
    )
  }
  if self.sample_time_local_common_clock != Default::default() {
    size += @lib.size_of_field(
      2U,
      @lib.size_of(self.sample_time_local_common_clock),
    )
  }
  if self.sample_time_raw_device_clock != Default::default() {
    size += @lib.size_of_field(
      3U,
      @lib.size_of(self.sample_time_raw_device_clock),
    )
  }
  size
}

///|
pub impl Default for DeviceDataTimestamp with fn default() -> DeviceDataTimestamp {
  DeviceDataTimestamp::{
    available_time_local_common_clock: Default::default(),
    sample_time_local_common_clock: Default::default(),
    sample_time_raw_device_clock: Default::default(),
  }
}

///|
#alias(new, deprecated)
pub fn DeviceDataTimestamp::DeviceDataTimestamp(
  available_time_local_common_clock : Int64,
  sample_time_local_common_clock : Int64,
  sample_time_raw_device_clock : Int64,
) -> DeviceDataTimestamp {
  DeviceDataTimestamp::{
    available_time_local_common_clock,
    sample_time_local_common_clock,
    sample_time_raw_device_clock,
  }
}

///|
pub impl @lib.Read for DeviceDataTimestamp with fn read_with_limit(
  reader : @lib.LimitedReader[&@lib.Reader],
) -> DeviceDataTimestamp raise {
  let msg : DeviceDataTimestamp = Default::default()
  while (reader |> @lib.read_next_message_field()) is Some((field_number, wire)) {
    match (field_number, wire) {
      (1, _) =>
        msg.available_time_local_common_clock = reader |> @lib.read_int64()
      (2, _) => msg.sample_time_local_common_clock = reader |> @lib.read_int64()
      (3, _) => msg.sample_time_raw_device_clock = reader |> @lib.read_int64()
      _ => reader |> @lib.skip_message_field_by_number(field_number, wire)
    }
  }
  msg
}

///|
pub impl @lib.Write for DeviceDataTimestamp with fn write(
  self : DeviceDataTimestamp,
  writer : &@lib.Writer,
) -> Unit raise {
  if self.available_time_local_common_clock != Default::default() {
    writer |> @lib.write_varint(8UL)
    writer |> @lib.write_int64(self.available_time_local_common_clock)
  }
  if self.sample_time_local_common_clock != Default::default() {
    writer |> @lib.write_varint(16UL)
    writer |> @lib.write_int64(self.sample_time_local_common_clock)
  }
  if self.sample_time_raw_device_clock != Default::default() {
    writer |> @lib.write_varint(24UL)
    writer |> @lib.write_int64(self.sample_time_raw_device_clock)
  }
}

///|
pub(all) struct HeadPose {
  mut pose : Pose?
  mut is_valid : Bool
  mut is_tracked : Bool
} derive(Eq, Debug)

///|
pub impl @lib.Sized for HeadPose with fn size_of(self) {
  let mut size = 0U
  if self.pose is Some(v) {
    size += @lib.size_of_length_delimited_field(1U, @lib.size_of(v))
  }
  if self.is_valid != Default::default() {
    size += @lib.size_of_field(2U, @lib.size_of(self.is_valid))
  }
  if self.is_tracked != Default::default() {
    size += @lib.size_of_field(3U, @lib.size_of(self.is_tracked))
  }
  size
}

///|
pub impl Default for HeadPose with fn default() -> HeadPose {
  HeadPose::{
    pose: None,
    is_valid: Default::default(),
    is_tracked: Default::default(),
  }
}

///|
#alias(new, deprecated)
pub fn HeadPose::HeadPose(
  pose? : Pose,
  is_valid : Bool,
  is_tracked : Bool,
) -> HeadPose {
  HeadPose::{ pose, is_valid, is_tracked, }
}

///|
pub impl @lib.Read for HeadPose with fn read_with_limit(
  reader : @lib.LimitedReader[&@lib.Reader],
) -> HeadPose raise {
  let msg : HeadPose = Default::default()
  while (reader |> @lib.read_next_message_field()) is Some((field_number, wire)) {
    match (field_number, wire) {
      (1, @lib.WIRE_TYPE_LENGTH_DELIMITED) =>
        msg.pose = (reader |> @lib.read_message() : Pose) |> Some
      (2, _) => msg.is_valid = reader |> @lib.read_bool()
      (3, _) => msg.is_tracked = reader |> @lib.read_bool()
      _ => reader |> @lib.skip_message_field_by_number(field_number, wire)
    }
  }
  msg
}

///|
pub impl @lib.Write for HeadPose with fn write(
  self : HeadPose,
  writer : &@lib.Writer,
) -> Unit raise {
  if self.pose is Some(v) {
    writer |> @lib.write_varint(10UL)
    writer |> @lib.write_message(v)
  }
  if self.is_valid != Default::default() {
    writer |> @lib.write_varint(16UL)
    writer |> @lib.write_bool(self.is_valid)
  }
  if self.is_tracked != Default::default() {
    writer |> @lib.write_varint(24UL)
    writer |> @lib.write_bool(self.is_tracked)
  }
}

///|
pub(all) struct HeadPoseRecord {
  mut data : HeadPose?
  mut timestamp : DeviceDataTimestamp?
} derive(Eq, Debug)

///|
pub impl @lib.Sized for HeadPoseRecord with fn size_of(self) {
  let mut size = 0U
  if self.data is Some(v) {
    size += @lib.size_of_length_delimited_field(1U, @lib.size_of(v))
  }
  if self.timestamp is Some(v) {
    size += @lib.size_of_length_delimited_field(2U, @lib.size_of(v))
  }
  size
}

///|
pub impl Default for HeadPoseRecord with fn default() -> HeadPoseRecord {
  HeadPoseRecord::{ data: None, timestamp: None, }
}

///|
#alias(new, deprecated)
pub fn HeadPoseRecord::HeadPoseRecord(
  data? : HeadPose,
  timestamp? : DeviceDataTimestamp,
) -> HeadPoseRecord {
  HeadPoseRecord::{ data, timestamp, }
}

///|
pub impl @lib.Read for HeadPoseRecord with fn read_with_limit(
  reader : @lib.LimitedReader[&@lib.Reader],
) -> HeadPoseRecord raise {
  let msg : HeadPoseRecord = Default::default()
  while (reader |> @lib.read_next_message_field()) is Some((field_number, wire)) {
    match (field_number, wire) {
      (1, @lib.WIRE_TYPE_LENGTH_DELIMITED) =>
        msg.data = (reader |> @lib.read_message() : HeadPose) |> Some
      (2, @lib.WIRE_TYPE_LENGTH_DELIMITED) =>
        msg.timestamp = (reader |> @lib.read_message() : DeviceDataTimestamp)
          |> Some
      _ => reader |> @lib.skip_message_field_by_number(field_number, wire)
    }
  }
  msg
}

///|
pub impl @lib.Write for HeadPoseRecord with fn write(
  self : HeadPoseRecord,
  writer : &@lib.Writer,
) -> Unit raise {
  if self.data is Some(v) {
    writer |> @lib.write_varint(10UL)
    writer |> @lib.write_message(v)
  }
  if self.timestamp is Some(v) {
    writer |> @lib.write_varint(18UL)
    writer |> @lib.write_message(v)
  }
}

///|
pub(all) struct BatteryStatus {
  mut level : Float
  mut is_charging : Bool
  mut is_valid : Bool
} derive(Eq, Debug)

///|
pub impl @lib.Sized for BatteryStatus with fn size_of(self) {
  let mut size = 0U
  if self.level != Default::default() {
    size += @lib.size_of_field(1U, 4U)
  }
  if self.is_charging != Default::default() {
    size += @lib.size_of_field(2U, @lib.size_of(self.is_charging))
  }
  if self.is_valid != Default::default() {
    size += @lib.size_of_field(3U, @lib.size_of(self.is_valid))
  }
  size
}

///|
pub impl Default for BatteryStatus with fn default() -> BatteryStatus {
  BatteryStatus::{
    level: Default::default(),
    is_charging: Default::default(),
    is_valid: Default::default(),
  }
}

///|
#alias(new, deprecated)
pub fn BatteryStatus::BatteryStatus(
  level : Float,
  is_charging : Bool,
  is_valid : Bool,
) -> BatteryStatus {
  BatteryStatus::{ level, is_charging, is_valid, }
}

///|
pub impl @lib.Read for BatteryStatus with fn read_with_limit(
  reader : @lib.LimitedReader[&@lib.Reader],
) -> BatteryStatus raise {
  let msg : BatteryStatus = Default::default()
  while (reader |> @lib.read_next_message_field()) is Some((field_number, wire)) {
    match (field_number, wire) {
      (1, _) => msg.level = reader |> @lib.read_float()
      (2, _) => msg.is_charging = reader |> @lib.read_bool()
      (3, _) => msg.is_valid = reader |> @lib.read_bool()
      _ => reader |> @lib.skip_message_field_by_number(field_number, wire)
    }
  }
  msg
}

///|
pub impl @lib.Write for BatteryStatus with fn write(
  self : BatteryStatus,
  writer : &@lib.Writer,
) -> Unit raise {
  if self.level != Default::default() {
    writer |> @lib.write_varint(13UL)
    writer |> @lib.write_float(self.level)
  }
  if self.is_charging != Default::default() {
    writer |> @lib.write_varint(16UL)
    writer |> @lib.write_bool(self.is_charging)
  }
  if self.is_valid != Default::default() {
    writer |> @lib.write_varint(24UL)
    writer |> @lib.write_bool(self.is_valid)
  }
}

///|
pub(all) struct BatteryStatusRecord {
  mut data : BatteryStatus?
  mut timestamp : DeviceDataTimestamp?
} derive(Eq, Debug)

///|
pub impl @lib.Sized for BatteryStatusRecord with fn size_of(self) {
  let mut size = 0U
  if self.data is Some(v) {
    size += @lib.size_of_length_delimited_field(1U, @lib.size_of(v))
  }
  if self.timestamp is Some(v) {
    size += @lib.size_of_length_delimited_field(2U, @lib.size_of(v))
  }
  size
}

///|
pub impl Default for BatteryStatusRecord with fn default() -> BatteryStatusRecord {
  BatteryStatusRecord::{ data: None, timestamp: None, }
}

///|
#alias(new, deprecated)
pub fn BatteryStatusRecord::BatteryStatusRecord(
  data? : BatteryStatus,
  timestamp? : DeviceDataTimestamp,
) -> BatteryStatusRecord {
  BatteryStatusRecord::{ data, timestamp, }
}

///|
pub impl @lib.Read for BatteryStatusRecord with fn read_with_limit(
  reader : @lib.LimitedReader[&@lib.Reader],
) -> BatteryStatusRecord raise {
  let msg : BatteryStatusRecord = Default::default()
  while (reader |> @lib.read_next_message_field()) is Some((field_number, wire)) {
    match (field_number, wire) {
      (1, @lib.WIRE_TYPE_LENGTH_DELIMITED) =>
        msg.data = (reader |> @lib.read_message() : BatteryStatus) |> Some
      (2, @lib.WIRE_TYPE_LENGTH_DELIMITED) =>
        msg.timestamp = (reader |> @lib.read_message() : DeviceDataTimestamp)
          |> Some
      _ => reader |> @lib.skip_message_field_by_number(field_number, wire)
    }
  }
  msg
}

///|
pub impl @lib.Write for BatteryStatusRecord with fn write(
  self : BatteryStatusRecord,
  writer : &@lib.Writer,
) -> Unit raise {
  if self.data is Some(v) {
    writer |> @lib.write_varint(10UL)
    writer |> @lib.write_message(v)
  }
  if self.timestamp is Some(v) {
    writer |> @lib.write_varint(18UL)
    writer |> @lib.write_message(v)
  }
}

///|
pub(all) struct ControllerInputState {
  mut primary_click : Bool
  mut secondary_click : Bool
  mut thumbstick_click : Bool
  mut menu_click : Bool
  mut thumbstick_x : Float
  mut thumbstick_y : Float
  mut squeeze_value : Float
  mut trigger_value : Float
} derive(Eq, Debug)

///|
pub impl @lib.Sized for ControllerInputState with fn size_of(self) {
  let mut size = 0U
  if self.primary_click != Default::default() {
    size += @lib.size_of_field(1U, @lib.size_of(self.primary_click))
  }
  if self.secondary_click != Default::default() {
    size += @lib.size_of_field(2U, @lib.size_of(self.secondary_click))
  }
  if self.thumbstick_click != Default::default() {
    size += @lib.size_of_field(3U, @lib.size_of(self.thumbstick_click))
  }
  if self.menu_click != Default::default() {
    size += @lib.size_of_field(4U, @lib.size_of(self.menu_click))
  }
  if self.thumbstick_x != Default::default() {
    size += @lib.size_of_field(5U, 4U)
  }
  if self.thumbstick_y != Default::default() {
    size += @lib.size_of_field(6U, 4U)
  }
  if self.squeeze_value != Default::default() {
    size += @lib.size_of_field(7U, 4U)
  }
  if self.trigger_value != Default::default() {
    size += @lib.size_of_field(8U, 4U)
  }
  size
}

///|
pub impl Default for ControllerInputState with fn default() -> ControllerInputState {
  ControllerInputState::{
    primary_click: Default::default(),
    secondary_click: Default::default(),
    thumbstick_click: Default::default(),
    menu_click: Default::default(),
    thumbstick_x: Default::default(),
    thumbstick_y: Default::default(),
    squeeze_value: Default::default(),
    trigger_value: Default::default(),
  }
}

///|
#alias(new, deprecated)
pub fn ControllerInputState::ControllerInputState(
  primary_click : Bool,
  secondary_click : Bool,
  thumbstick_click : Bool,
  menu_click : Bool,
  thumbstick_x : Float,
  thumbstick_y : Float,
  squeeze_value : Float,
  trigger_value : Float,
) -> ControllerInputState {
  ControllerInputState::{
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
pub impl @lib.Read for ControllerInputState with fn read_with_limit(
  reader : @lib.LimitedReader[&@lib.Reader],
) -> ControllerInputState raise {
  let msg : ControllerInputState = Default::default()
  while (reader |> @lib.read_next_message_field()) is Some((field_number, wire)) {
    match (field_number, wire) {
      (1, _) => msg.primary_click = reader |> @lib.read_bool()
      (2, _) => msg.secondary_click = reader |> @lib.read_bool()
      (3, _) => msg.thumbstick_click = reader |> @lib.read_bool()
      (4, _) => msg.menu_click = reader |> @lib.read_bool()
      (5, _) => msg.thumbstick_x = reader |> @lib.read_float()
      (6, _) => msg.thumbstick_y = reader |> @lib.read_float()
      (7, _) => msg.squeeze_value = reader |> @lib.read_float()
      (8, _) => msg.trigger_value = reader |> @lib.read_float()
      _ => reader |> @lib.skip_message_field_by_number(field_number, wire)
    }
  }
  msg
}

///|
pub impl @lib.Write for ControllerInputState with fn write(
  self : ControllerInputState,
  writer : &@lib.Writer,
) -> Unit raise {
  if self.primary_click != Default::default() {
    writer |> @lib.write_varint(8UL)
    writer |> @lib.write_bool(self.primary_click)
  }
  if self.secondary_click != Default::default() {
    writer |> @lib.write_varint(16UL)
    writer |> @lib.write_bool(self.secondary_click)
  }
  if self.thumbstick_click != Default::default() {
    writer |> @lib.write_varint(24UL)
    writer |> @lib.write_bool(self.thumbstick_click)
  }
  if self.menu_click != Default::default() {
    writer |> @lib.write_varint(32UL)
    writer |> @lib.write_bool(self.menu_click)
  }
  if self.thumbstick_x != Default::default() {
    writer |> @lib.write_varint(45UL)
    writer |> @lib.write_float(self.thumbstick_x)
  }
  if self.thumbstick_y != Default::default() {
    writer |> @lib.write_varint(53UL)
    writer |> @lib.write_float(self.thumbstick_y)
  }
  if self.squeeze_value != Default::default() {
    writer |> @lib.write_varint(61UL)
    writer |> @lib.write_float(self.squeeze_value)
  }
  if self.trigger_value != Default::default() {
    writer |> @lib.write_varint(69UL)
    writer |> @lib.write_float(self.trigger_value)
  }
}

///|
pub(all) struct ControllerPose {
  mut pose : Pose?
  mut is_valid : Bool
} derive(Eq, Debug)

///|
pub impl @lib.Sized for ControllerPose with fn size_of(self) {
  let mut size = 0U
  if self.pose is Some(v) {
    size += @lib.size_of_length_delimited_field(1U, @lib.size_of(v))
  }
  if self.is_valid != Default::default() {
    size += @lib.size_of_field(2U, @lib.size_of(self.is_valid))
  }
  size
}

///|
pub impl Default for ControllerPose with fn default() -> ControllerPose {
  ControllerPose::{ pose: None, is_valid: Default::default(), }
}

///|
#alias(new, deprecated)
pub fn ControllerPose::ControllerPose(
  pose? : Pose,
  is_valid : Bool,
) -> ControllerPose {
  ControllerPose::{ pose, is_valid, }
}

///|
pub impl @lib.Read for ControllerPose with fn read_with_limit(
  reader : @lib.LimitedReader[&@lib.Reader],
) -> ControllerPose raise {
  let msg : ControllerPose = Default::default()
  while (reader |> @lib.read_next_message_field()) is Some((field_number, wire)) {
    match (field_number, wire) {
      (1, @lib.WIRE_TYPE_LENGTH_DELIMITED) =>
        msg.pose = (reader |> @lib.read_message() : Pose) |> Some
      (2, _) => msg.is_valid = reader |> @lib.read_bool()
      _ => reader |> @lib.skip_message_field_by_number(field_number, wire)
    }
  }
  msg
}

///|
pub impl @lib.Write for ControllerPose with fn write(
  self : ControllerPose,
  writer : &@lib.Writer,
) -> Unit raise {
  if self.pose is Some(v) {
    writer |> @lib.write_varint(10UL)
    writer |> @lib.write_message(v)
  }
  if self.is_valid != Default::default() {
    writer |> @lib.write_varint(16UL)
    writer |> @lib.write_bool(self.is_valid)
  }
}

///|
pub(all) struct ControllerSnapshot {
  mut grip_pose : ControllerPose?
  mut aim_pose : ControllerPose?
  mut inputs : ControllerInputState?
} derive(Eq, Debug)

///|
pub impl @lib.Sized for ControllerSnapshot with fn size_of(self) {
  let mut size = 0U
  if self.grip_pose is Some(v) {
    size += @lib.size_of_length_delimited_field(1U, @lib.size_of(v))
  }
  if self.aim_pose is Some(v) {
    size += @lib.size_of_length_delimited_field(2U, @lib.size_of(v))
  }
  if self.inputs is Some(v) {
    size += @lib.size_of_length_delimited_field(3U, @lib.size_of(v))
  }
  size
}

///|
pub impl Default for ControllerSnapshot with fn default() -> ControllerSnapshot {
  ControllerSnapshot::{ grip_pose: None, aim_pose: None, inputs: None, }
}

///|
#alias(new, deprecated)
pub fn ControllerSnapshot::ControllerSnapshot(
  grip_pose? : ControllerPose,
  aim_pose? : ControllerPose,
  inputs? : ControllerInputState,
) -> ControllerSnapshot {
  ControllerSnapshot::{ grip_pose, aim_pose, inputs, }
}

///|
pub impl @lib.Read for ControllerSnapshot with fn read_with_limit(
  reader : @lib.LimitedReader[&@lib.Reader],
) -> ControllerSnapshot raise {
  let msg : ControllerSnapshot = Default::default()
  while (reader |> @lib.read_next_message_field()) is Some((field_number, wire)) {
    match (field_number, wire) {
      (1, @lib.WIRE_TYPE_LENGTH_DELIMITED) =>
        msg.grip_pose = (reader |> @lib.read_message() : ControllerPose) |> Some
      (2, @lib.WIRE_TYPE_LENGTH_DELIMITED) =>
        msg.aim_pose = (reader |> @lib.read_message() : ControllerPose) |> Some
      (3, @lib.WIRE_TYPE_LENGTH_DELIMITED) =>
        msg.inputs = (reader |> @lib.read_message() : ControllerInputState)
          |> Some
      _ => reader |> @lib.skip_message_field_by_number(field_number, wire)
    }
  }
  msg
}

///|
pub impl @lib.Write for ControllerSnapshot with fn write(
  self : ControllerSnapshot,
  writer : &@lib.Writer,
) -> Unit raise {
  if self.grip_pose is Some(v) {
    writer |> @lib.write_varint(10UL)
    writer |> @lib.write_message(v)
  }
  if self.aim_pose is Some(v) {
    writer |> @lib.write_varint(18UL)
    writer |> @lib.write_message(v)
  }
  if self.inputs is Some(v) {
    writer |> @lib.write_varint(26UL)
    writer |> @lib.write_message(v)
  }
}

///|
pub(all) struct ControllerSnapshotRecord {
  mut data : ControllerSnapshot?
  mut timestamp : DeviceDataTimestamp?
} derive(Eq, Debug)

///|
pub impl @lib.Sized for ControllerSnapshotRecord with fn size_of(self) {
  let mut size = 0U
  if self.data is Some(v) {
    size += @lib.size_of_length_delimited_field(1U, @lib.size_of(v))
  }
  if self.timestamp is Some(v) {
    size += @lib.size_of_length_delimited_field(2U, @lib.size_of(v))
  }
  size
}

///|
pub impl Default for ControllerSnapshotRecord with fn default() -> ControllerSnapshotRecord {
  ControllerSnapshotRecord::{ data: None, timestamp: None, }
}

///|
#alias(new, deprecated)
pub fn ControllerSnapshotRecord::ControllerSnapshotRecord(
  data? : ControllerSnapshot,
  timestamp? : DeviceDataTimestamp,
) -> ControllerSnapshotRecord {
  ControllerSnapshotRecord::{ data, timestamp, }
}

///|
pub impl @lib.Read for ControllerSnapshotRecord with fn read_with_limit(
  reader : @lib.LimitedReader[&@lib.Reader],
) -> ControllerSnapshotRecord raise {
  let msg : ControllerSnapshotRecord = Default::default()
  while (reader |> @lib.read_next_message_field()) is Some((field_number, wire)) {
    match (field_number, wire) {
      (1, @lib.WIRE_TYPE_LENGTH_DELIMITED) =>
        msg.data = (reader |> @lib.read_message() : ControllerSnapshot) |> Some
      (2, @lib.WIRE_TYPE_LENGTH_DELIMITED) =>
        msg.timestamp = (reader |> @lib.read_message() : DeviceDataTimestamp)
          |> Some
      _ => reader |> @lib.skip_message_field_by_number(field_number, wire)
    }
  }
  msg
}

///|
pub impl @lib.Write for ControllerSnapshotRecord with fn write(
  self : ControllerSnapshotRecord,
  writer : &@lib.Writer,
) -> Unit raise {
  if self.data is Some(v) {
    writer |> @lib.write_varint(10UL)
    writer |> @lib.write_message(v)
  }
  if self.timestamp is Some(v) {
    writer |> @lib.write_varint(18UL)
    writer |> @lib.write_message(v)
  }
}

///|
pub(all) struct HandJointPose {
  mut pose : Pose?
  mut is_valid : Bool
  mut radius : Float
} derive(Eq, Debug)

///|
pub impl @lib.Sized for HandJointPose with fn size_of(self) {
  let mut size = 0U
  if self.pose is Some(v) {
    size += @lib.size_of_length_delimited_field(1U, @lib.size_of(v))
  }
  if self.is_valid != Default::default() {
    size += @lib.size_of_field(2U, @lib.size_of(self.is_valid))
  }
  if self.radius != Default::default() {
    size += @lib.size_of_field(3U, 4U)
  }
  size
}

///|
pub impl Default for HandJointPose with fn default() -> HandJointPose {
  HandJointPose::{
    pose: None,
    is_valid: Default::default(),
    radius: Default::default(),
  }
}

///|
#alias(new, deprecated)
pub fn HandJointPose::HandJointPose(
  pose? : Pose,
  is_valid : Bool,
  radius : Float,
) -> HandJointPose {
  HandJointPose::{ pose, is_valid, radius, }
}

///|
pub impl @lib.Read for HandJointPose with fn read_with_limit(
  reader : @lib.LimitedReader[&@lib.Reader],
) -> HandJointPose raise {
  let msg : HandJointPose = Default::default()
  while (reader |> @lib.read_next_message_field()) is Some((field_number, wire)) {
    match (field_number, wire) {
      (1, @lib.WIRE_TYPE_LENGTH_DELIMITED) =>
        msg.pose = (reader |> @lib.read_message() : Pose) |> Some
      (2, _) => msg.is_valid = reader |> @lib.read_bool()
      (3, _) => msg.radius = reader |> @lib.read_float()
      _ => reader |> @lib.skip_message_field_by_number(field_number, wire)
    }
  }
  msg
}

///|
pub impl @lib.Write for HandJointPose with fn write(
  self : HandJointPose,
  writer : &@lib.Writer,
) -> Unit raise {
  if self.pose is Some(v) {
    writer |> @lib.write_varint(10UL)
    writer |> @lib.write_message(v)
  }
  if self.is_valid != Default::default() {
    writer |> @lib.write_varint(16UL)
    writer |> @lib.write_bool(self.is_valid)
  }
  if self.radius != Default::default() {
    writer |> @lib.write_varint(29UL)
    writer |> @lib.write_float(self.radius)
  }
}

///|
pub(all) struct HandJoints {
  mut poses : Array[HandJointPose]
} derive(Eq, Debug)

///|
pub impl @lib.Sized for HandJoints with fn size_of(self) {
  let mut size = 0U
  for s in self.poses {
    size += @lib.size_of_length_delimited_field(1U, @lib.size_of(s))
  }
  size
}

///|
pub impl Default for HandJoints with fn default() -> HandJoints {
  HandJoints::{ poses: [], }
}

///|
#alias(new, deprecated)
pub fn HandJoints::HandJoints(poses : Array[HandJointPose]) -> HandJoints {
  HandJoints::{ poses, }
}

///|
pub impl @lib.Read for HandJoints with fn read_with_limit(
  reader : @lib.LimitedReader[&@lib.Reader],
) -> HandJoints raise {
  let msg : HandJoints = Default::default()
  while (reader |> @lib.read_next_message_field()) is Some((field_number, wire)) {
    match (field_number, wire) {
      (1, @lib.WIRE_TYPE_LENGTH_DELIMITED) =>
        msg.poses.push((reader |> @lib.read_message() : HandJointPose))
      _ => reader |> @lib.skip_message_field_by_number(field_number, wire)
    }
  }
  msg
}

///|
pub impl @lib.Write for HandJoints with fn write(
  self : HandJoints,
  writer : &@lib.Writer,
) -> Unit raise {
  for item in self.poses {
    writer |> @lib.write_varint(10UL)
    writer |> @lib.write_message(item)
  }
}

///|
pub(all) struct HandPose {
  mut joints : HandJoints?
} derive(Eq, Debug)

///|
pub impl @lib.Sized for HandPose with fn size_of(self) {
  let mut size = 0U
  if self.joints is Some(v) {
    size += @lib.size_of_length_delimited_field(1U, @lib.size_of(v))
  }
  size
}

///|
pub impl Default for HandPose with fn default() -> HandPose {
  HandPose::{ joints: None, }
}

///|
#alias(new, deprecated)
pub fn HandPose::HandPose(joints? : HandJoints) -> HandPose {
  HandPose::{ joints, }
}

///|
pub impl @lib.Read for HandPose with fn read_with_limit(
  reader : @lib.LimitedReader[&@lib.Reader],
) -> HandPose raise {
  let msg : HandPose = Default::default()
  while (reader |> @lib.read_next_message_field()) is Some((field_number, wire)) {
    match (field_number, wire) {
      (1, @lib.WIRE_TYPE_LENGTH_DELIMITED) =>
        msg.joints = (reader |> @lib.read_message() : HandJoints) |> Some
      _ => reader |> @lib.skip_message_field_by_number(field_number, wire)
    }
  }
  msg
}

///|
pub impl @lib.Write for HandPose with fn write(
  self : HandPose,
  writer : &@lib.Writer,
) -> Unit raise {
  if self.joints is Some(v) {
    writer |> @lib.write_varint(10UL)
    writer |> @lib.write_message(v)
  }
}

///|
pub(all) struct HandPoseRecord {
  mut data : HandPose?
  mut timestamp : DeviceDataTimestamp?
} derive(Eq, Debug)

///|
pub impl @lib.Sized for HandPoseRecord with fn size_of(self) {
  let mut size = 0U
  if self.data is Some(v) {
    size += @lib.size_of_length_delimited_field(1U, @lib.size_of(v))
  }
  if self.timestamp is Some(v) {
    size += @lib.size_of_length_delimited_field(2U, @lib.size_of(v))
  }
  size
}

///|
pub impl Default for HandPoseRecord with fn default() -> HandPoseRecord {
  HandPoseRecord::{ data: None, timestamp: None, }
}

///|
#alias(new, deprecated)
pub fn HandPoseRecord::HandPoseRecord(
  data? : HandPose,
  timestamp? : DeviceDataTimestamp,
) -> HandPoseRecord {
  HandPoseRecord::{ data, timestamp, }
}

///|
pub impl @lib.Read for HandPoseRecord with fn read_with_limit(
  reader : @lib.LimitedReader[&@lib.Reader],
) -> HandPoseRecord raise {
  let msg : HandPoseRecord = Default::default()
  while (reader |> @lib.read_next_message_field()) is Some((field_number, wire)) {
    match (field_number, wire) {
      (1, @lib.WIRE_TYPE_LENGTH_DELIMITED) =>
        msg.data = (reader |> @lib.read_message() : HandPose) |> Some
      (2, @lib.WIRE_TYPE_LENGTH_DELIMITED) =>
        msg.timestamp = (reader |> @lib.read_message() : DeviceDataTimestamp)
          |> Some
      _ => reader |> @lib.skip_message_field_by_number(field_number, wire)
    }
  }
  msg
}

///|
pub impl @lib.Write for HandPoseRecord with fn write(
  self : HandPoseRecord,
  writer : &@lib.Writer,
) -> Unit raise {
  if self.data is Some(v) {
    writer |> @lib.write_varint(10UL)
    writer |> @lib.write_message(v)
  }
  if self.timestamp is Some(v) {
    writer |> @lib.write_varint(18UL)
    writer |> @lib.write_message(v)
  }
}

///|
pub(all) struct JointState {
  mut name : String
  mut position : Float
  mut velocity : Float
  mut effort : Float
  mut valid : Bool?
} derive(Eq, Debug)

///|
pub impl @lib.Sized for JointState with fn size_of(self) {
  let mut size = 0U
  if self.name != Default::default() {
    size += @lib.size_of_length_delimited_field(1U, @lib.size_of(self.name))
  }
  if self.position != Default::default() {
    size += @lib.size_of_field(2U, 4U)
  }
  if self.velocity != Default::default() {
    size += @lib.size_of_field(3U, 4U)
  }
  if self.effort != Default::default() {
    size += @lib.size_of_field(4U, 4U)
  }
  if self.valid is Some(v) {
    size += @lib.size_of_field(5U, @lib.size_of(v))
  }
  size
}

///|
pub impl Default for JointState with fn default() -> JointState {
  JointState::{
    name: Default::default(),
    position: Default::default(),
    velocity: Default::default(),
    effort: Default::default(),
    valid: None,
  }
}

///|
#alias(new, deprecated)
pub fn JointState::JointState(
  name : String,
  position : Float,
  velocity : Float,
  effort : Float,
  valid? : Bool,
) -> JointState {
  JointState::{ name, position, velocity, effort, valid, }
}

///|
pub impl @lib.Read for JointState with fn read_with_limit(
  reader : @lib.LimitedReader[&@lib.Reader],
) -> JointState raise {
  let msg : JointState = Default::default()
  while (reader |> @lib.read_next_message_field()) is Some((field_number, wire)) {
    match (field_number, wire) {
      (1, _) => msg.name = reader |> @lib.read_string()
      (2, _) => msg.position = reader |> @lib.read_float()
      (3, _) => msg.velocity = reader |> @lib.read_float()
      (4, _) => msg.effort = reader |> @lib.read_float()
      (5, _) => msg.valid = reader |> @lib.read_bool() |> Some
      _ => reader |> @lib.skip_message_field_by_number(field_number, wire)
    }
  }
  msg
}

///|
pub impl @lib.Write for JointState with fn write(
  self : JointState,
  writer : &@lib.Writer,
) -> Unit raise {
  if self.name != Default::default() {
    writer |> @lib.write_varint(10UL)
    writer |> @lib.write_string(self.name)
  }
  if self.position != Default::default() {
    writer |> @lib.write_varint(21UL)
    writer |> @lib.write_float(self.position)
  }
  if self.velocity != Default::default() {
    writer |> @lib.write_varint(29UL)
    writer |> @lib.write_float(self.velocity)
  }
  if self.effort != Default::default() {
    writer |> @lib.write_varint(37UL)
    writer |> @lib.write_float(self.effort)
  }
  if self.valid is Some(v) {
    writer |> @lib.write_varint(40UL)
    writer |> @lib.write_bool(v)
  }
}

///|
pub(all) struct JointStateOutput {
  mut joints : Array[JointState]
  mut device_id : String
  mut has_velocity : Bool
  mut has_effort : Bool
  mut ee_pose : Pose?
  mut ee_pose_valid : Bool
} derive(Eq, Debug)

///|
pub impl @lib.Sized for JointStateOutput with fn size_of(self) {
  let mut size = 0U
  for s in self.joints {
    size += @lib.size_of_length_delimited_field(1U, @lib.size_of(s))
  }
  if self.device_id != Default::default() {
    size += @lib.size_of_length_delimited_field(
      2U,
      @lib.size_of(self.device_id),
    )
  }
  if self.has_velocity != Default::default() {
    size += @lib.size_of_field(3U, @lib.size_of(self.has_velocity))
  }
  if self.has_effort != Default::default() {
    size += @lib.size_of_field(4U, @lib.size_of(self.has_effort))
  }
  if self.ee_pose is Some(v) {
    size += @lib.size_of_length_delimited_field(5U, @lib.size_of(v))
  }
  if self.ee_pose_valid != Default::default() {
    size += @lib.size_of_field(6U, @lib.size_of(self.ee_pose_valid))
  }
  size
}

///|
pub impl Default for JointStateOutput with fn default() -> JointStateOutput {
  JointStateOutput::{
    joints: [],
    device_id: Default::default(),
    has_velocity: Default::default(),
    has_effort: Default::default(),
    ee_pose: None,
    ee_pose_valid: Default::default(),
  }
}

///|
#alias(new, deprecated)
pub fn JointStateOutput::JointStateOutput(
  joints : Array[JointState],
  device_id : String,
  has_velocity : Bool,
  has_effort : Bool,
  ee_pose? : Pose,
  ee_pose_valid : Bool,
) -> JointStateOutput {
  JointStateOutput::{
    joints,
    device_id,
    has_velocity,
    has_effort,
    ee_pose,
    ee_pose_valid,
  }
}

///|
pub impl @lib.Read for JointStateOutput with fn read_with_limit(
  reader : @lib.LimitedReader[&@lib.Reader],
) -> JointStateOutput raise {
  let msg : JointStateOutput = Default::default()
  while (reader |> @lib.read_next_message_field()) is Some((field_number, wire)) {
    match (field_number, wire) {
      (1, @lib.WIRE_TYPE_LENGTH_DELIMITED) =>
        msg.joints.push((reader |> @lib.read_message() : JointState))
      (2, _) => msg.device_id = reader |> @lib.read_string()
      (3, _) => msg.has_velocity = reader |> @lib.read_bool()
      (4, _) => msg.has_effort = reader |> @lib.read_bool()
      (5, @lib.WIRE_TYPE_LENGTH_DELIMITED) =>
        msg.ee_pose = (reader |> @lib.read_message() : Pose) |> Some
      (6, _) => msg.ee_pose_valid = reader |> @lib.read_bool()
      _ => reader |> @lib.skip_message_field_by_number(field_number, wire)
    }
  }
  msg
}

///|
pub impl @lib.Write for JointStateOutput with fn write(
  self : JointStateOutput,
  writer : &@lib.Writer,
) -> Unit raise {
  for item in self.joints {
    writer |> @lib.write_varint(10UL)
    writer |> @lib.write_message(item)
  }
  if self.device_id != Default::default() {
    writer |> @lib.write_varint(18UL)
    writer |> @lib.write_string(self.device_id)
  }
  if self.has_velocity != Default::default() {
    writer |> @lib.write_varint(24UL)
    writer |> @lib.write_bool(self.has_velocity)
  }
  if self.has_effort != Default::default() {
    writer |> @lib.write_varint(32UL)
    writer |> @lib.write_bool(self.has_effort)
  }
  if self.ee_pose is Some(v) {
    writer |> @lib.write_varint(42UL)
    writer |> @lib.write_message(v)
  }
  if self.ee_pose_valid != Default::default() {
    writer |> @lib.write_varint(48UL)
    writer |> @lib.write_bool(self.ee_pose_valid)
  }
}

///|
pub(all) struct JointStateOutputRecord {
  mut data : JointStateOutput?
  mut timestamp : DeviceDataTimestamp?
} derive(Eq, Debug)

///|
pub impl @lib.Sized for JointStateOutputRecord with fn size_of(self) {
  let mut size = 0U
  if self.data is Some(v) {
    size += @lib.size_of_length_delimited_field(1U, @lib.size_of(v))
  }
  if self.timestamp is Some(v) {
    size += @lib.size_of_length_delimited_field(2U, @lib.size_of(v))
  }
  size
}

///|
pub impl Default for JointStateOutputRecord with fn default() -> JointStateOutputRecord {
  JointStateOutputRecord::{ data: None, timestamp: None, }
}

///|
#alias(new, deprecated)
pub fn JointStateOutputRecord::JointStateOutputRecord(
  data? : JointStateOutput,
  timestamp? : DeviceDataTimestamp,
) -> JointStateOutputRecord {
  JointStateOutputRecord::{ data, timestamp, }
}

///|
pub impl @lib.Read for JointStateOutputRecord with fn read_with_limit(
  reader : @lib.LimitedReader[&@lib.Reader],
) -> JointStateOutputRecord raise {
  let msg : JointStateOutputRecord = Default::default()
  while (reader |> @lib.read_next_message_field()) is Some((field_number, wire)) {
    match (field_number, wire) {
      (1, @lib.WIRE_TYPE_LENGTH_DELIMITED) =>
        msg.data = (reader |> @lib.read_message() : JointStateOutput) |> Some
      (2, @lib.WIRE_TYPE_LENGTH_DELIMITED) =>
        msg.timestamp = (reader |> @lib.read_message() : DeviceDataTimestamp)
          |> Some
      _ => reader |> @lib.skip_message_field_by_number(field_number, wire)
    }
  }
  msg
}

///|
pub impl @lib.Write for JointStateOutputRecord with fn write(
  self : JointStateOutputRecord,
  writer : &@lib.Writer,
) -> Unit raise {
  if self.data is Some(v) {
    writer |> @lib.write_varint(10UL)
    writer |> @lib.write_message(v)
  }
  if self.timestamp is Some(v) {
    writer |> @lib.write_varint(18UL)
    writer |> @lib.write_message(v)
  }
}
