///|
const MAX_LOG_LINES : Int = 12

///|
pub struct InspectorState {
  mut connected : Bool
  mut rx_frames : UInt64
  mut hand_frames : UInt64
  mut decode_errors : UInt64
  mut left_valid_joints : Int
  mut right_valid_joints : Int
  mut left_sequence : UInt64
  mut right_sequence : UInt64
  mut left_joints : Array[@protocol.HandJointPose]
  mut right_joints : Array[@protocol.HandJointPose]
  mut logs : Array[String]
} derive(Debug)

///|
pub fn InspectorState::new() -> InspectorState {
  {
    connected: false,
    rx_frames: 0UL,
    hand_frames: 0UL,
    decode_errors: 0UL,
    left_valid_joints: 0,
    right_valid_joints: 0,
    left_sequence: 0UL,
    right_sequence: 0UL,
    left_joints: [],
    right_joints: [],
    logs: [],
  }
}

///|
fn InspectorState::push_log(self : InspectorState, message : String) -> Unit {
  if self.logs.length() >= MAX_LOG_LINES {
    let next : Array[String] = []
    let mut index = 1
    while index < self.logs.length() {
      next.push(self.logs[index])
      index += 1
    }
    self.logs = next
  }
  self.logs.push(message)
}

///|
fn valid_joint_count(record : @bridge.HandPoseEvent) -> Int {
  let mut count = 0
  for joint in record.record.data.joints.poses {
    if joint.is_valid {
      count += 1
    }
  }
  count
}

///|
fn source_side(source_id : String) -> String {
  if source_id.has_suffix(":left") {
    "left"
  } else if source_id.has_suffix(":right") {
    "right"
  } else {
    "unknown"
  }
}

///|
pub fn InspectorState::on_event(
  self : InspectorState,
  event : @bridge.BridgeEvent,
) -> Unit {
  match event {
    @bridge.BridgeEvent::Connected(address) => {
      self.connected = true
      self.push_log("connected " + address)
    }
    @bridge.BridgeEvent::Disconnected(reason) => {
      self.connected = false
      self.push_log("disconnected " + reason)
    }
    @bridge.BridgeEvent::FrameReceived(frame) => {
      self.rx_frames += 1UL
      self.push_log(
        "frame \{frame.topic} seq=\{frame.sequence} bytes=\{frame.payload_size}",
      )
    }
    @bridge.BridgeEvent::HandPoseReceived(hand) => {
      self.rx_frames += 1UL
      self.hand_frames += 1UL
      let valid = valid_joint_count(hand)
      let side = source_side(hand.frame.source_id)
      if side == "left" {
        self.left_valid_joints = valid
        self.left_sequence = hand.frame.sequence
        self.left_joints = hand.record.data.joints.poses
      } else if side == "right" {
        self.right_valid_joints = valid
        self.right_sequence = hand.frame.sequence
        self.right_joints = hand.record.data.joints.poses
      }
      self.push_log("hand_pose \{side} \{valid}/26 seq=\{hand.frame.sequence}")
    }
    @bridge.BridgeEvent::DecodeError(error) => {
      self.decode_errors += 1UL
      self.push_log("decode error " + error)
    }
  }
}
