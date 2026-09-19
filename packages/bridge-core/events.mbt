///|
pub const HAND_POSE_SCHEMA_ID : String = "kaguya.input.hand_pose"

///|
pub const HEAD_POSE_SCHEMA_ID : String = "kaguya.input.head_pose"

///|
pub const BATTERY_STATUS_SCHEMA_ID : String = "kaguya.input.battery_status"

///|
pub struct FrameSummary {
  kind : @protocol.FrameKind
  topic : String
  schema_id : String
  schema_version : UInt
  sequence : UInt64
  source_time_ns : UInt64
  source_id : String
  frame_id : String
  payload_size : Int
} derive(Eq, Debug)

///|
pub struct HandPoseEvent {
  frame : FrameSummary
  record : @protocol.HandPoseRecord
} derive(Debug)

///|
pub struct HeadPoseEvent {
  frame : FrameSummary
  record : @protocol.HeadPoseRecord
} derive(Debug)

///|
pub struct BatteryStatusEvent {
  frame : FrameSummary
  record : @protocol.BatteryStatusRecord
} derive(Debug)

///|
pub enum BridgeEvent {
  Connected(String)
  Disconnected(String)
  FrameReceived(FrameSummary)
  HeadPoseReceived(HeadPoseEvent)
  HandPoseReceived(HandPoseEvent)
  BatteryStatusReceived(BatteryStatusEvent)
  DecodeError(String)
} derive(Debug)

///|
pub fn BridgeEvent::connected(address : String) -> BridgeEvent {
  Connected(address)
}

///|
pub fn BridgeEvent::disconnected(reason : String) -> BridgeEvent {
  Disconnected(reason)
}

///|
pub fn BridgeEvent::frame_received(frame : FrameSummary) -> BridgeEvent {
  FrameReceived(frame)
}

///|
pub fn BridgeEvent::hand_pose_received(event : HandPoseEvent) -> BridgeEvent {
  HandPoseReceived(event)
}

///|
pub fn BridgeEvent::head_pose_received(event : HeadPoseEvent) -> BridgeEvent {
  HeadPoseReceived(event)
}

///|
pub fn BridgeEvent::battery_status_received(
  event : BatteryStatusEvent,
) -> BridgeEvent {
  BatteryStatusReceived(event)
}

///|
pub fn BridgeEvent::decode_error(error : String) -> BridgeEvent {
  DecodeError(error)
}

///|
pub fn FrameSummary::new(
  kind : @protocol.FrameKind,
  topic : String,
  schema_id : String,
  schema_version : UInt,
  sequence : UInt64,
  source_time_ns : UInt64,
  source_id : String,
  frame_id : String,
  payload_size : Int,
) -> FrameSummary {
  {
    kind,
    topic,
    schema_id,
    schema_version,
    sequence,
    source_time_ns,
    source_id,
    frame_id,
    payload_size,
  }
}

///|
pub fn HandPoseEvent::new(
  frame : FrameSummary,
  record : @protocol.HandPoseRecord,
) -> HandPoseEvent {
  { frame, record, }
}

///|
pub fn HeadPoseEvent::new(
  frame : FrameSummary,
  record : @protocol.HeadPoseRecord,
) -> HeadPoseEvent {
  { frame, record, }
}

///|
pub fn BatteryStatusEvent::new(
  frame : FrameSummary,
  record : @protocol.BatteryStatusRecord,
) -> BatteryStatusEvent {
  { frame, record, }
}

///|
pub type EventSink = (BridgeEvent) -> Unit

///|
pub fn emit(sink : EventSink, event : BridgeEvent) -> Unit {
  sink(event)
}

///|
pub struct EventBus {
  sinks : Array[EventSink]
}

///|
pub fn EventBus::new() -> EventBus {
  { sinks: [], }
}

///|
pub fn EventBus::subscribe(self : EventBus, sink : EventSink) -> Unit {
  self.sinks.push(sink)
}

///|
pub fn EventBus::publish(self : EventBus, event : BridgeEvent) -> Unit {
  for sink in self.sinks {
    sink(event)
  }
}
