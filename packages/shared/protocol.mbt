///|
pub enum Encoding {
  Unspecified
  Protobuf
  Json
  Jpeg
  Webp
} derive(Eq, Debug)

///|
pub fn Encoding::protobuf() -> Encoding {
  Protobuf
}

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
fn default_point() -> Point {
  Point::{ x: 0.0, y: 0.0, z: 0.0, }
}

///|
fn default_quaternion() -> Quaternion {
  Quaternion::{ x: 0.0, y: 0.0, z: 0.0, w: 1.0, }
}

///|
fn default_pose() -> Pose {
  Pose::{ position: default_point(), orientation: default_quaternion(), }
}

///|
fn default_timestamp() -> DeviceDataTimestamp {
  DeviceDataTimestamp::{
    available_time_local_common_clock: 0L,
    sample_time_local_common_clock: 0L,
    sample_time_raw_device_clock: 0L,
  }
}

///|
fn default_controller_input_state() -> ControllerInputState {
  ControllerInputState::{
    primary_click: false,
    secondary_click: false,
    thumbstick_click: false,
    menu_click: false,
    thumbstick_x: 0.0,
    thumbstick_y: 0.0,
    squeeze_value: 0.0,
    trigger_value: 0.0,
  }
}

///|
fn default_controller_pose() -> ControllerPose {
  ControllerPose::{ pose: default_pose(), is_valid: false, }
}

///|
fn default_controller_snapshot() -> ControllerSnapshot {
  ControllerSnapshot::{
    grip_pose: default_controller_pose(),
    aim_pose: default_controller_pose(),
    inputs: default_controller_input_state(),
  }
}

///|
fn default_head_pose() -> HeadPose {
  HeadPose::{ pose: default_pose(), is_valid: false, is_tracked: false, }
}

///|
fn default_hand_pose() -> HandPose {
  HandPose::{ joints: HandJoints::{ poses: [], }, }
}

///|
fn default_joint_state_output() -> JointStateOutput {
  JointStateOutput::{
    joints: [],
    device_id: "",
    has_velocity: false,
    has_effort: false,
    ee_pose: None,
    ee_pose_valid: false,
  }
}

///|
fn to_wire_encoding(value : Encoding) -> @wire.Encoding {
  match value {
    Unspecified => @wire.Encoding::ENCODING_UNSPECIFIED
    Protobuf => @wire.Encoding::ENCODING_PROTOBUF
    Json => @wire.Encoding::ENCODING_JSON
    Jpeg => @wire.Encoding::ENCODING_JPEG
    Webp => @wire.Encoding::ENCODING_WEBP
  }
}

///|
fn from_wire_encoding(value : @wire.Encoding) -> Encoding {
  match value {
    @wire.Encoding::ENCODING_PROTOBUF => Protobuf
    @wire.Encoding::ENCODING_JSON => Json
    @wire.Encoding::ENCODING_JPEG => Jpeg
    @wire.Encoding::ENCODING_WEBP => Webp
    _ => Unspecified
  }
}

///|
fn to_wire_frame_kind(value : FrameKind) -> @wire.FrameKind {
  match value {
    Unspecified => @wire.FrameKind::FRAME_KIND_UNSPECIFIED
    Publish => @wire.FrameKind::FRAME_KIND_PUBLISH
    Subscribe => @wire.FrameKind::FRAME_KIND_SUBSCRIBE
    Unsubscribe => @wire.FrameKind::FRAME_KIND_UNSUBSCRIBE
    Data => @wire.FrameKind::FRAME_KIND_DATA
    Error => @wire.FrameKind::FRAME_KIND_ERROR
  }
}

///|
fn from_wire_frame_kind(value : @wire.FrameKind) -> FrameKind {
  match value {
    @wire.FrameKind::FRAME_KIND_PUBLISH => Publish
    @wire.FrameKind::FRAME_KIND_SUBSCRIBE => Subscribe
    @wire.FrameKind::FRAME_KIND_UNSUBSCRIBE => Unsubscribe
    @wire.FrameKind::FRAME_KIND_DATA => Data
    @wire.FrameKind::FRAME_KIND_ERROR => Error
    _ => Unspecified
  }
}

///|
fn to_wire_point(value : Point) -> @wire.Point {
  @wire.Point::{ x: value.x, y: value.y, z: value.z, }
}

///|
fn from_wire_point(value : @wire.Point) -> Point {
  Point::{ x: value.x, y: value.y, z: value.z, }
}

///|
fn to_wire_quaternion(value : Quaternion) -> @wire.Quaternion {
  @wire.Quaternion::{ x: value.x, y: value.y, z: value.z, w: value.w, }
}

///|
fn from_wire_quaternion(value : @wire.Quaternion) -> Quaternion {
  Quaternion::{ x: value.x, y: value.y, z: value.z, w: value.w, }
}

///|
fn to_wire_pose(value : Pose) -> @wire.Pose {
  @wire.Pose::{
    position: Some(to_wire_point(value.position)),
    orientation: Some(to_wire_quaternion(value.orientation)),
  }
}

///|
fn from_wire_pose(value : @wire.Pose) -> Pose {
  let position = match value.position {
    Some(value) => from_wire_point(value)
    None => default_point()
  }
  let orientation = match value.orientation {
    Some(value) => from_wire_quaternion(value)
    None => default_quaternion()
  }
  Pose::{ position, orientation, }
}

///|
fn to_wire_timestamp(value : DeviceDataTimestamp) -> @wire.DeviceDataTimestamp {
  @wire.DeviceDataTimestamp::{
    available_time_local_common_clock: value.available_time_local_common_clock,
    sample_time_local_common_clock: value.sample_time_local_common_clock,
    sample_time_raw_device_clock: value.sample_time_raw_device_clock,
  }
}

///|
fn from_wire_timestamp(
  value : @wire.DeviceDataTimestamp,
) -> DeviceDataTimestamp {
  DeviceDataTimestamp::{
    available_time_local_common_clock: value.available_time_local_common_clock,
    sample_time_local_common_clock: value.sample_time_local_common_clock,
    sample_time_raw_device_clock: value.sample_time_raw_device_clock,
  }
}

///|
fn to_wire_envelope(value : Envelope) -> @wire.Envelope {
  @wire.Envelope::{
    schema_id: value.schema_id,
    schema_version: value.schema_version,
    sequence: value.sequence,
    source_time_ns: value.source_time_ns,
    source_id: value.source_id,
    frame_id: value.frame_id,
    encoding: to_wire_encoding(value.encoding),
    payload: value.payload,
  }
}

///|
fn from_wire_envelope(value : @wire.Envelope) -> Envelope {
  Envelope::{
    schema_id: value.schema_id,
    schema_version: value.schema_version,
    sequence: value.sequence,
    source_time_ns: value.source_time_ns,
    source_id: value.source_id,
    frame_id: value.frame_id,
    encoding: from_wire_encoding(value.encoding),
    payload: value.payload,
  }
}

///|
fn to_wire_frame(value : Frame) -> @wire.Frame {
  @wire.Frame::{
    kind: to_wire_frame_kind(value.kind),
    topic: value.topic,
    envelope: value.envelope.map(to_wire_envelope),
    error: value.error,
  }
}

///|
fn from_wire_frame(value : @wire.Frame) -> Frame {
  Frame::{
    kind: from_wire_frame_kind(value.kind),
    topic: value.topic,
    envelope: value.envelope.map(from_wire_envelope),
    error: value.error,
  }
}

///|
fn to_wire_head_pose(value : HeadPose) -> @wire.HeadPose {
  @wire.HeadPose::{
    pose: Some(to_wire_pose(value.pose)),
    is_valid: value.is_valid,
    is_tracked: value.is_tracked,
  }
}

///|
fn from_wire_head_pose(value : @wire.HeadPose) -> HeadPose {
  HeadPose::{
    pose: value.pose.map(from_wire_pose).unwrap_or(default_pose()),
    is_valid: value.is_valid,
    is_tracked: value.is_tracked,
  }
}

///|
fn to_wire_head_pose_record(value : HeadPoseRecord) -> @wire.HeadPoseRecord {
  @wire.HeadPoseRecord::{
    data: Some(to_wire_head_pose(value.data)),
    timestamp: Some(to_wire_timestamp(value.timestamp)),
  }
}

///|
fn from_wire_head_pose_record(value : @wire.HeadPoseRecord) -> HeadPoseRecord {
  HeadPoseRecord::{
    data: value.data.map(from_wire_head_pose).unwrap_or(default_head_pose()),
    timestamp: value.timestamp
    .map(from_wire_timestamp)
    .unwrap_or(default_timestamp()),
  }
}

///|
fn to_wire_controller_input_state(
  value : ControllerInputState,
) -> @wire.ControllerInputState {
  @wire.ControllerInputState::{
    primary_click: value.primary_click,
    secondary_click: value.secondary_click,
    thumbstick_click: value.thumbstick_click,
    menu_click: value.menu_click,
    thumbstick_x: value.thumbstick_x,
    thumbstick_y: value.thumbstick_y,
    squeeze_value: value.squeeze_value,
    trigger_value: value.trigger_value,
  }
}

///|
fn from_wire_controller_input_state(
  value : @wire.ControllerInputState,
) -> ControllerInputState {
  ControllerInputState::{
    primary_click: value.primary_click,
    secondary_click: value.secondary_click,
    thumbstick_click: value.thumbstick_click,
    menu_click: value.menu_click,
    thumbstick_x: value.thumbstick_x,
    thumbstick_y: value.thumbstick_y,
    squeeze_value: value.squeeze_value,
    trigger_value: value.trigger_value,
  }
}

///|
fn to_wire_controller_pose(value : ControllerPose) -> @wire.ControllerPose {
  @wire.ControllerPose::{
    pose: Some(to_wire_pose(value.pose)),
    is_valid: value.is_valid,
  }
}

///|
fn from_wire_controller_pose(value : @wire.ControllerPose) -> ControllerPose {
  ControllerPose::{
    pose: value.pose.map(from_wire_pose).unwrap_or(default_pose()),
    is_valid: value.is_valid,
  }
}

///|
fn to_wire_controller_snapshot(
  value : ControllerSnapshot,
) -> @wire.ControllerSnapshot {
  @wire.ControllerSnapshot::{
    grip_pose: Some(to_wire_controller_pose(value.grip_pose)),
    aim_pose: Some(to_wire_controller_pose(value.aim_pose)),
    inputs: Some(to_wire_controller_input_state(value.inputs)),
  }
}

///|
fn from_wire_controller_snapshot(
  value : @wire.ControllerSnapshot,
) -> ControllerSnapshot {
  ControllerSnapshot::{
    grip_pose: value.grip_pose
    .map(from_wire_controller_pose)
    .unwrap_or(default_controller_pose()),
    aim_pose: value.aim_pose
    .map(from_wire_controller_pose)
    .unwrap_or(default_controller_pose()),
    inputs: value.inputs
    .map(from_wire_controller_input_state)
    .unwrap_or(default_controller_input_state()),
  }
}

///|
fn to_wire_controller_snapshot_record(
  value : ControllerSnapshotRecord,
) -> @wire.ControllerSnapshotRecord {
  @wire.ControllerSnapshotRecord::{
    data: Some(to_wire_controller_snapshot(value.data)),
    timestamp: Some(to_wire_timestamp(value.timestamp)),
  }
}

///|
fn from_wire_controller_snapshot_record(
  value : @wire.ControllerSnapshotRecord,
) -> ControllerSnapshotRecord {
  ControllerSnapshotRecord::{
    data: value.data
    .map(from_wire_controller_snapshot)
    .unwrap_or(default_controller_snapshot()),
    timestamp: value.timestamp
    .map(from_wire_timestamp)
    .unwrap_or(default_timestamp()),
  }
}

///|
fn to_wire_hand_joint_pose(value : HandJointPose) -> @wire.HandJointPose {
  @wire.HandJointPose::{
    pose: Some(to_wire_pose(value.pose)),
    is_valid: value.is_valid,
    radius: value.radius,
  }
}

///|
fn from_wire_hand_joint_pose(value : @wire.HandJointPose) -> HandJointPose {
  HandJointPose::{
    pose: value.pose.map(from_wire_pose).unwrap_or(default_pose()),
    is_valid: value.is_valid,
    radius: value.radius,
  }
}

///|
fn to_wire_hand_joints(value : HandJoints) -> @wire.HandJoints {
  @wire.HandJoints::{ poses: value.poses.map(to_wire_hand_joint_pose), }
}

///|
fn from_wire_hand_joints(value : @wire.HandJoints) -> HandJoints {
  HandJoints::{ poses: value.poses.map(from_wire_hand_joint_pose), }
}

///|
fn to_wire_hand_pose(value : HandPose) -> @wire.HandPose {
  @wire.HandPose::{ joints: Some(to_wire_hand_joints(value.joints)), }
}

///|
fn from_wire_hand_pose(value : @wire.HandPose) -> HandPose {
  HandPose::{
    joints: value.joints
    .map(from_wire_hand_joints)
    .unwrap_or(HandJoints::{ poses: [], }),
  }
}

///|
fn to_wire_hand_pose_record(value : HandPoseRecord) -> @wire.HandPoseRecord {
  @wire.HandPoseRecord::{
    data: Some(to_wire_hand_pose(value.data)),
    timestamp: Some(to_wire_timestamp(value.timestamp)),
  }
}

///|
fn from_wire_hand_pose_record(value : @wire.HandPoseRecord) -> HandPoseRecord {
  HandPoseRecord::{
    data: value.data.map(from_wire_hand_pose).unwrap_or(default_hand_pose()),
    timestamp: value.timestamp
    .map(from_wire_timestamp)
    .unwrap_or(default_timestamp()),
  }
}

///|
fn to_wire_joint_state(value : JointState) -> @wire.JointState {
  @wire.JointState::{
    name: value.name,
    position: value.position,
    velocity: value.velocity,
    effort: value.effort,
    valid: if value.valid {
      None
    } else {
      Some(false)
    },
  }
}

///|
fn from_wire_joint_state(value : @wire.JointState) -> JointState {
  JointState::{
    name: value.name,
    position: value.position,
    velocity: value.velocity,
    effort: value.effort,
    valid: value.valid.unwrap_or(true),
  }
}

///|
fn to_wire_joint_state_output(
  value : JointStateOutput,
) -> @wire.JointStateOutput {
  @wire.JointStateOutput::{
    joints: value.joints.map(to_wire_joint_state),
    device_id: value.device_id,
    has_velocity: value.has_velocity,
    has_effort: value.has_effort,
    ee_pose: value.ee_pose.map(to_wire_pose),
    ee_pose_valid: value.ee_pose_valid,
  }
}

///|
fn from_wire_joint_state_output(
  value : @wire.JointStateOutput,
) -> JointStateOutput {
  JointStateOutput::{
    joints: value.joints.map(from_wire_joint_state),
    device_id: value.device_id,
    has_velocity: value.has_velocity,
    has_effort: value.has_effort,
    ee_pose: value.ee_pose.map(from_wire_pose),
    ee_pose_valid: value.ee_pose_valid,
  }
}

///|
fn to_wire_joint_state_output_record(
  value : JointStateOutputRecord,
) -> @wire.JointStateOutputRecord {
  @wire.JointStateOutputRecord::{
    data: Some(to_wire_joint_state_output(value.data)),
    timestamp: Some(to_wire_timestamp(value.timestamp)),
  }
}

///|
fn from_wire_joint_state_output_record(
  value : @wire.JointStateOutputRecord,
) -> JointStateOutputRecord {
  JointStateOutputRecord::{
    data: value.data
    .map(from_wire_joint_state_output)
    .unwrap_or(default_joint_state_output()),
    timestamp: value.timestamp
    .map(from_wire_timestamp)
    .unwrap_or(default_timestamp()),
  }
}

///|
fn[T : @protobuf.Write] encode_wire(value : T) -> Bytes {
  let writer = @buffer.Buffer()
  try! @protobuf.Write::write(value, writer)
  writer.to_bytes()
}

///|
fn[T : @protobuf.Read] decode_wire(bytes : Bytes) -> Result[T, String] {
  try {
    let reader = @protobuf.BytesReader::from_bytes(bytes)
    let value : T = @protobuf.Read::read(reader)
    Ok(value)
  } catch {
    error => Err(error.to_string())
  }
}

///|
pub fn encode_frame(value : Frame) -> Bytes {
  encode_wire(to_wire_frame(value))
}

///|
pub fn decode_frame(bytes : Bytes) -> Result[Frame, String] {
  match decode_wire(bytes) {
    Ok(value) => Ok(from_wire_frame(value))
    Err(error) => Err(error)
  }
}

///|
pub fn encode_envelope(value : Envelope) -> Bytes {
  encode_wire(to_wire_envelope(value))
}

///|
pub fn decode_envelope(bytes : Bytes) -> Result[Envelope, String] {
  match decode_wire(bytes) {
    Ok(value) => Ok(from_wire_envelope(value))
    Err(error) => Err(error)
  }
}

///|
pub fn encode_point(value : Point) -> Bytes {
  encode_wire(to_wire_point(value))
}

///|
pub fn decode_point(bytes : Bytes) -> Result[Point, String] {
  match decode_wire(bytes) {
    Ok(value) => Ok(from_wire_point(value))
    Err(error) => Err(error)
  }
}

///|
pub fn encode_quaternion(value : Quaternion) -> Bytes {
  encode_wire(to_wire_quaternion(value))
}

///|
pub fn decode_quaternion(bytes : Bytes) -> Result[Quaternion, String] {
  match decode_wire(bytes) {
    Ok(value) => Ok(from_wire_quaternion(value))
    Err(error) => Err(error)
  }
}

///|
pub fn encode_pose(value : Pose) -> Bytes {
  encode_wire(to_wire_pose(value))
}

///|
pub fn decode_pose(bytes : Bytes) -> Result[Pose, String] {
  match decode_wire(bytes) {
    Ok(value) => Ok(from_wire_pose(value))
    Err(error) => Err(error)
  }
}

///|
pub fn encode_device_data_timestamp(value : DeviceDataTimestamp) -> Bytes {
  encode_wire(to_wire_timestamp(value))
}

///|
pub fn decode_device_data_timestamp(
  bytes : Bytes,
) -> Result[DeviceDataTimestamp, String] {
  match decode_wire(bytes) {
    Ok(value) => Ok(from_wire_timestamp(value))
    Err(error) => Err(error)
  }
}

///|
pub fn encode_head_pose(value : HeadPose) -> Bytes {
  encode_wire(to_wire_head_pose(value))
}

///|
pub fn decode_head_pose(bytes : Bytes) -> Result[HeadPose, String] {
  match decode_wire(bytes) {
    Ok(value) => Ok(from_wire_head_pose(value))
    Err(error) => Err(error)
  }
}

///|
pub fn encode_head_pose_record(value : HeadPoseRecord) -> Bytes {
  encode_wire(to_wire_head_pose_record(value))
}

///|
pub fn decode_head_pose_record(bytes : Bytes) -> Result[HeadPoseRecord, String] {
  match decode_wire(bytes) {
    Ok(value) => Ok(from_wire_head_pose_record(value))
    Err(error) => Err(error)
  }
}

///|
pub fn encode_controller_input_state(value : ControllerInputState) -> Bytes {
  encode_wire(to_wire_controller_input_state(value))
}

///|
pub fn decode_controller_input_state(
  bytes : Bytes,
) -> Result[ControllerInputState, String] {
  match decode_wire(bytes) {
    Ok(value) => Ok(from_wire_controller_input_state(value))
    Err(error) => Err(error)
  }
}

///|
pub fn encode_controller_snapshot(value : ControllerSnapshot) -> Bytes {
  encode_wire(to_wire_controller_snapshot(value))
}

///|
pub fn decode_controller_snapshot(
  bytes : Bytes,
) -> Result[ControllerSnapshot, String] {
  match decode_wire(bytes) {
    Ok(value) => Ok(from_wire_controller_snapshot(value))
    Err(error) => Err(error)
  }
}

///|
pub fn encode_controller_snapshot_record(
  value : ControllerSnapshotRecord,
) -> Bytes {
  encode_wire(to_wire_controller_snapshot_record(value))
}

///|
pub fn decode_controller_snapshot_record(
  bytes : Bytes,
) -> Result[ControllerSnapshotRecord, String] {
  match decode_wire(bytes) {
    Ok(value) => Ok(from_wire_controller_snapshot_record(value))
    Err(error) => Err(error)
  }
}

///|
pub fn encode_hand_pose(value : HandPose) -> Bytes {
  encode_wire(to_wire_hand_pose(value))
}

///|
pub fn decode_hand_pose(bytes : Bytes) -> Result[HandPose, String] {
  match decode_wire(bytes) {
    Ok(value) => Ok(from_wire_hand_pose(value))
    Err(error) => Err(error)
  }
}

///|
pub fn encode_hand_pose_record(value : HandPoseRecord) -> Bytes {
  encode_wire(to_wire_hand_pose_record(value))
}

///|
pub fn decode_hand_pose_record(bytes : Bytes) -> Result[HandPoseRecord, String] {
  match decode_wire(bytes) {
    Ok(value) => Ok(from_wire_hand_pose_record(value))
    Err(error) => Err(error)
  }
}

///|
pub fn encode_joint_state_output(value : JointStateOutput) -> Bytes {
  encode_wire(to_wire_joint_state_output(value))
}

///|
pub fn decode_joint_state_output(
  bytes : Bytes,
) -> Result[JointStateOutput, String] {
  match decode_wire(bytes) {
    Ok(value) => Ok(from_wire_joint_state_output(value))
    Err(error) => Err(error)
  }
}

///|
pub fn encode_joint_state_output_record(
  value : JointStateOutputRecord,
) -> Bytes {
  encode_wire(to_wire_joint_state_output_record(value))
}

///|
pub fn decode_joint_state_output_record(
  bytes : Bytes,
) -> Result[JointStateOutputRecord, String] {
  match decode_wire(bytes) {
    Ok(value) => Ok(from_wire_joint_state_output_record(value))
    Err(error) => Err(error)
  }
}
