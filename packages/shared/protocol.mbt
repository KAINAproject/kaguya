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
pub struct Vec3 {
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
  position : Vec3
  orientation : Quaternion
  reference_frame : String
} derive(Eq, Debug)

///|
pub struct HmdPose {
  pose : Pose
} derive(Eq, Debug)

///|
pub struct ControllerState {
  handedness : String
  buttons : UInt
  axes : Array[Float]
  pose : Pose?
} derive(Eq, Debug)

///|
pub struct Landmark {
  x : Float
  y : Float
  z : Float
  confidence : Float
} derive(Eq, Debug)

///|
pub struct HandLandmarks {
  handedness : String
  landmarks : Array[Landmark]
} derive(Eq, Debug)

///|
pub struct JointState {
  positions : Array[Float]
  velocities : Array[Float]
  efforts : Array[Float]
  source_time_ns : UInt64
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
pub fn Vec3::new(x : Float, y : Float, z : Float) -> Vec3 {
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
pub fn Pose::new(
  position : Vec3,
  orientation : Quaternion,
  reference_frame : String,
) -> Pose {
  { position, orientation, reference_frame, }
}

///|
pub fn HmdPose::new(pose : Pose) -> HmdPose {
  { pose, }
}

///|
pub fn ControllerState::new(
  handedness : String,
  buttons : UInt,
  axes : Array[Float],
  pose : Pose?,
) -> ControllerState {
  { handedness, buttons, axes, pose, }
}

///|
pub fn Landmark::new(
  x : Float,
  y : Float,
  z : Float,
  confidence : Float,
) -> Landmark {
  { x, y, z, confidence, }
}

///|
pub fn HandLandmarks::new(
  handedness : String,
  landmarks : Array[Landmark],
) -> HandLandmarks {
  { handedness, landmarks, }
}

///|
pub fn JointState::new(
  positions : Array[Float],
  velocities : Array[Float],
  efforts : Array[Float],
  source_time_ns : UInt64,
) -> JointState {
  { positions, velocities, efforts, source_time_ns, }
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
  if value.kind != Unspecified {
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
  if value.encoding != Unspecified {
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
fn encode_vec3(value : Vec3) -> Bytes {
  let writer = ProtoWriter::new()
  writer.write_float(1, value.x)
  writer.write_float(2, value.y)
  writer.write_float(3, value.z)
  writer.finish()
}

///|
fn decode_vec3(bytes : Bytes) -> Result[Vec3, String] {
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
  Ok(Vec3::{ x, y, z, })
}

///|
fn encode_quaternion(value : Quaternion) -> Bytes {
  let writer = ProtoWriter::new()
  writer.write_float(1, value.x)
  writer.write_float(2, value.y)
  writer.write_float(3, value.z)
  writer.write_float(4, value.w)
  writer.finish()
}

///|
fn decode_quaternion(bytes : Bytes) -> Result[Quaternion, String] {
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
fn encode_pose(value : Pose) -> Bytes {
  let writer = ProtoWriter::new()
  writer.write_message(1, encode_vec3(value.position))
  writer.write_message(2, encode_quaternion(value.orientation))
  if value.reference_frame != "" {
    writer.write_string(3, value.reference_frame)
  }
  writer.finish()
}

///|
fn decode_pose(bytes : Bytes) -> Result[Pose, String] {
  let reader = ProtoReader::new(bytes)
  let mut position = Vec3::{ x: 0.0, y: 0.0, z: 0.0, }
  let mut orientation = Quaternion::{ x: 0.0, y: 0.0, z: 0.0, w: 1.0, }
  let mut reference_frame = ""
  while reader.position < reader.bytes.length() {
    let (field_number, wire_type) = match reader.read_key() {
      Ok(key) => key
      Err(error) => return Err(error)
    }
    match (field_number, wire_type) {
      (1, 2) =>
        match reader.read_bytes() {
          Ok(field) =>
            match decode_vec3(field) {
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
      (3, 2) =>
        match reader.read_string() {
          Ok(field) => reference_frame = field
          Err(error) => return Err(error)
        }
      (_, _) =>
        match reader.skip(wire_type) {
          Ok(_) => ()
          Err(error) => return Err(error)
        }
    }
  }
  Ok(Pose::{ position, orientation, reference_frame, })
}

///|
pub fn encode_hmd_pose(value : HmdPose) -> Bytes {
  let writer = ProtoWriter::new()
  writer.write_message(1, encode_pose(value.pose))
  writer.finish()
}

///|
pub fn decode_hmd_pose(bytes : Bytes) -> Result[HmdPose, String] {
  let reader = ProtoReader::new(bytes)
  let mut pose = Pose::{
    position: Vec3::{ x: 0.0, y: 0.0, z: 0.0, },
    orientation: Quaternion::{ x: 0.0, y: 0.0, z: 0.0, w: 1.0, },
    reference_frame: "",
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
            match decode_pose(field) {
              Ok(decoded) => pose = decoded
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
  Ok(HmdPose::{ pose, })
}

///|
pub fn encode_controller_state(value : ControllerState) -> Bytes {
  let writer = ProtoWriter::new()
  if value.handedness != "" {
    writer.write_string(1, value.handedness)
  }
  if value.buttons != 0U {
    writer.write_uint32(2, value.buttons)
  }
  encode_float_array(writer, 3, value.axes)
  match value.pose {
    Some(pose) => writer.write_message(4, encode_pose(pose))
    None => ()
  }
  writer.finish()
}

///|
pub fn decode_controller_state(
  bytes : Bytes,
) -> Result[ControllerState, String] {
  let reader = ProtoReader::new(bytes)
  let mut handedness = ""
  let mut buttons = 0U
  let axes : Array[Float] = []
  let mut pose : Pose? = None
  while reader.position < reader.bytes.length() {
    let (field_number, wire_type) = match reader.read_key() {
      Ok(key) => key
      Err(error) => return Err(error)
    }
    match (field_number, wire_type) {
      (1, 2) =>
        match reader.read_string() {
          Ok(field) => handedness = field
          Err(error) => return Err(error)
        }
      (2, 0) =>
        match reader.read_uint32() {
          Ok(field) => buttons = field
          Err(error) => return Err(error)
        }
      (3, 2) =>
        match reader.read_packed_floats() {
          Ok(fields) =>
            for field in fields {
              axes.push(field)
            }
          Err(error) => return Err(error)
        }
      (3, 5) =>
        match reader.read_float() {
          Ok(field) => axes.push(field)
          Err(error) => return Err(error)
        }
      (4, 2) =>
        match reader.read_bytes() {
          Ok(field) =>
            match decode_pose(field) {
              Ok(decoded) => pose = Some(decoded)
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
  Ok(ControllerState::{ handedness, buttons, axes, pose, })
}

///|
fn encode_landmark(value : Landmark) -> Bytes {
  let writer = ProtoWriter::new()
  writer.write_float(1, value.x)
  writer.write_float(2, value.y)
  writer.write_float(3, value.z)
  writer.write_float(4, value.confidence)
  writer.finish()
}

///|
fn decode_landmark(bytes : Bytes) -> Result[Landmark, String] {
  let reader = ProtoReader::new(bytes)
  let mut x : Float = 0.0
  let mut y : Float = 0.0
  let mut z : Float = 0.0
  let mut confidence : Float = 0.0
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
          Ok(field) => confidence = field
          Err(error) => return Err(error)
        }
      (_, _) =>
        match reader.skip(wire_type) {
          Ok(_) => ()
          Err(error) => return Err(error)
        }
    }
  }
  Ok(Landmark::{ x, y, z, confidence, })
}

///|
pub fn encode_hand_landmarks(value : HandLandmarks) -> Bytes {
  let writer = ProtoWriter::new()
  if value.handedness != "" {
    writer.write_string(1, value.handedness)
  }
  for landmark in value.landmarks {
    writer.write_message(2, encode_landmark(landmark))
  }
  writer.finish()
}

///|
pub fn decode_hand_landmarks(bytes : Bytes) -> Result[HandLandmarks, String] {
  let reader = ProtoReader::new(bytes)
  let mut handedness = ""
  let landmarks : Array[Landmark] = []
  while reader.position < reader.bytes.length() {
    let (field_number, wire_type) = match reader.read_key() {
      Ok(key) => key
      Err(error) => return Err(error)
    }
    match (field_number, wire_type) {
      (1, 2) =>
        match reader.read_string() {
          Ok(field) => handedness = field
          Err(error) => return Err(error)
        }
      (2, 2) =>
        match reader.read_bytes() {
          Ok(field) =>
            match decode_landmark(field) {
              Ok(decoded) => landmarks.push(decoded)
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
  Ok(HandLandmarks::{ handedness, landmarks, })
}

///|
fn encode_float_array(
  writer : ProtoWriter,
  field_number : Int,
  values : Array[Float],
) -> Unit {
  if values.length() > 0 {
    writer.write_packed_floats(field_number, values)
  }
}

///|
pub fn encode_joint_state(value : JointState) -> Bytes {
  let writer = ProtoWriter::new()
  encode_float_array(writer, 1, value.positions)
  encode_float_array(writer, 2, value.velocities)
  encode_float_array(writer, 3, value.efforts)
  if value.source_time_ns != 0UL {
    writer.write_uint64(4, value.source_time_ns)
  }
  writer.finish()
}

///|
pub fn decode_joint_state(bytes : Bytes) -> Result[JointState, String] {
  let reader = ProtoReader::new(bytes)
  let positions : Array[Float] = []
  let velocities : Array[Float] = []
  let efforts : Array[Float] = []
  let mut source_time_ns = 0UL
  while reader.position < reader.bytes.length() {
    let (field_number, wire_type) = match reader.read_key() {
      Ok(key) => key
      Err(error) => return Err(error)
    }
    match (field_number, wire_type) {
      (1, 2) =>
        match reader.read_packed_floats() {
          Ok(fields) =>
            for field in fields {
              positions.push(field)
            }
          Err(error) => return Err(error)
        }
      (2, 2) =>
        match reader.read_packed_floats() {
          Ok(fields) =>
            for field in fields {
              velocities.push(field)
            }
          Err(error) => return Err(error)
        }
      (3, 2) =>
        match reader.read_packed_floats() {
          Ok(fields) =>
            for field in fields {
              efforts.push(field)
            }
          Err(error) => return Err(error)
        }
      (1, 5) =>
        match reader.read_float() {
          Ok(field) => positions.push(field)
          Err(error) => return Err(error)
        }
      (2, 5) =>
        match reader.read_float() {
          Ok(field) => velocities.push(field)
          Err(error) => return Err(error)
        }
      (3, 5) =>
        match reader.read_float() {
          Ok(field) => efforts.push(field)
          Err(error) => return Err(error)
        }
      (4, 0) =>
        match reader.read_uint64() {
          Ok(field) => source_time_ns = field
          Err(error) => return Err(error)
        }
      (_, _) =>
        match reader.skip(wire_type) {
          Ok(_) => ()
          Err(error) => return Err(error)
        }
    }
  }
  Ok(JointState::{ positions, velocities, efforts, source_time_ns, })
}
