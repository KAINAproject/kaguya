///|
fn empty_frame_summary(frame : @protocol.Frame) -> FrameSummary {
  FrameSummary::new(frame.kind(), frame.topic(), "", 0U, 0UL, 0UL, "", "", 0)
}

///|
fn frame_summary(
  frame : @protocol.Frame,
  envelope : @protocol.Envelope,
) -> FrameSummary {
  FrameSummary::new(
    frame.kind(),
    frame.topic(),
    envelope.schema_id,
    envelope.schema_version,
    envelope.sequence,
    envelope.source_time_ns,
    envelope.source_id,
    envelope.frame_id,
    envelope.payload.length(),
  )
}

///|
pub fn decode_frame_event(bytes : Bytes) -> Result[BridgeEvent, String] {
  match @protocol.decode_frame(bytes) {
    Err(error) => Err("frame decode failed: " + error)
    Ok(frame) =>
      match frame.envelope() {
        None => Ok(BridgeEvent::FrameReceived(empty_frame_summary(frame)))
        Some(envelope) => {
          let summary = frame_summary(frame, envelope)
          if envelope.encoding != @protocol.Encoding::protobuf() {
            Ok(BridgeEvent::FrameReceived(summary))
          } else if envelope.schema_id == HEAD_POSE_SCHEMA_ID {
            match @protocol.decode_head_pose_record(envelope.payload) {
              Ok(record) =>
                Ok(
                  BridgeEvent::HeadPoseReceived(
                    HeadPoseEvent::new(summary, record),
                  ),
                )
              Err(error) => Err("head pose decode failed: " + error)
            }
          } else if envelope.schema_id == HAND_POSE_SCHEMA_ID {
            match @protocol.decode_hand_pose_record(envelope.payload) {
              Ok(record) =>
                Ok(
                  BridgeEvent::HandPoseReceived(
                    HandPoseEvent::new(summary, record),
                  ),
                )
              Err(error) => Err("hand pose decode failed: " + error)
            }
          } else if envelope.schema_id == BATTERY_STATUS_SCHEMA_ID {
            match @protocol.decode_battery_status_record(envelope.payload) {
              Ok(record) =>
                Ok(
                  BridgeEvent::BatteryStatusReceived(
                    BatteryStatusEvent::new(summary, record),
                  ),
                )
              Err(error) => Err("battery status decode failed: " + error)
            }
          } else {
            Ok(BridgeEvent::FrameReceived(summary))
          }
        }
      }
  }
}

///|
pub fn publish_frame(bus : EventBus, bytes : Bytes) -> Unit {
  match decode_frame_event(bytes) {
    Ok(event) => bus.publish(event)
    Err(error) => bus.publish(BridgeEvent::DecodeError(error))
  }
}
