///|
pub const HAND_POSE_SCHEMA_ID : String = "kaguya.input.hand_pose"

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
pub enum BridgeEvent {
  Connected(String)
  Disconnected(String)
  FrameReceived(FrameSummary)
  HandPoseReceived(HandPoseEvent)
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
