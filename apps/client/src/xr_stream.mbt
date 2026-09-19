///|
const DEFAULT_XR_ROBOT_ID : String = "atlas"

///|
let xr_robot_id : Ref[String] = Ref(DEFAULT_XR_ROBOT_ID)

///|
#export_name("kaguya_set_xr_robot_id")
pub fn kaguya_set_xr_robot_id(robot_id : String) -> Unit {
  if robot_id != "" {
    xr_robot_id.val = robot_id
  }
}

///|
const XR_REFERENCE_FRAME : String = "local-floor"

///|
const HEAD_POSE_SCHEMA_ID : String = "kaguya.input.head_pose"

///|
const BATTERY_STATUS_SCHEMA_ID : String = "kaguya.input.battery_status"

///|
const CONTROLLER_SNAPSHOT_SCHEMA_ID : String = "kaguya.input.controller_snapshot"

///|
const HAND_POSE_SCHEMA_ID : String = "kaguya.input.hand_pose"

///|
let xr_sequence : Ref[UInt64] = Ref(0UL)

///|
let last_battery_publish_time : Ref[Double?] = Ref(None)

///|
fn next_xr_sequence() -> UInt64 {
  let sequence = xr_sequence.val
  xr_sequence.val = sequence + 1UL
  sequence
}

///|
fn default_protocol_pose() -> @protocol.Pose {
  @protocol.Pose::new(
    @protocol.Point::new(0.0, 0.0, 0.0),
    @protocol.Quaternion::new(0.0, 0.0, 0.0, 1.0),
  )
}

///|
fn protocol_pose(pose : @three_xr.Pose) -> @protocol.Pose {
  @protocol.Pose::new(
    @protocol.Point::new(
      pose.position_x(),
      pose.position_y(),
      pose.position_z(),
    ),
    @protocol.Quaternion::new(
      pose.orientation_x(),
      pose.orientation_y(),
      pose.orientation_z(),
      pose.orientation_w(),
    ),
  )
}

///|
fn sample_timestamp(time : Double) -> @protocol.DeviceDataTimestamp {
  let sample_time = @three_xr.frame_time_to_sample_time_ns(time)
  @protocol.DeviceDataTimestamp::new(sample_time, sample_time, 0L)
}

///|
fn publish_payload(
  topic : String,
  schema_id : String,
  source_id : String,
  time : Double,
  payload : Bytes,
) -> Bool {
  let source_time_ns = @three_xr.frame_time_to_source_time_ns(time)
  let envelope = @protocol.Envelope::new(
    schema_id,
    1U,
    next_xr_sequence(),
    source_time_ns,
    source_id,
    XR_REFERENCE_FRAME,
    @protocol.Encoding::protobuf(),
    payload,
  )
  send_protocol_frame(@protocol.Frame::publish(topic, envelope))
}

///|
fn protocol_controller_input(
  source : @three_xr.XRInputSource?,
) -> @protocol.ControllerInputState {
  match source {
    Some(source) =>
      match source.input_state() {
        Some(state) =>
          @protocol.ControllerInputState::new(
            state.primary_click(),
            state.secondary_click(),
            state.thumbstick_click(),
            state.menu_click(),
            state.thumbstick_x(),
            state.thumbstick_y(),
            state.squeeze_value(),
            state.trigger_value(),
          )
        None =>
          @protocol.ControllerInputState::new(
            false, false, false, false, 0.0, 0.0, 0.0, 0.0,
          )
      }
    None =>
      @protocol.ControllerInputState::new(
        false, false, false, false, 0.0, 0.0, 0.0, 0.0,
      )
  }
}

///|
fn publish_head_pose(manager : @three_xr.WebXRManager, time : Double) -> Unit {
  match manager.current_head_pose() {
    Some(pose) => {
      let data = @protocol.HeadPose::new(protocol_pose(pose), true, true)
      let record = @protocol.HeadPoseRecord::new(data, sample_timestamp(time))
      ignore(
        publish_payload(
          @protocol.head_pose_input(xr_robot_id.val),
          HEAD_POSE_SCHEMA_ID,
          "webxr:head",
          time,
          @protocol.encode_head_pose_record(record),
        ),
      )
    }
    None => ()
  }
}

///|
fn publish_battery_status(time : Double) -> Unit {
  match current_battery_status() {
    None => ()
    Some(status) => {
      let should_publish = match last_battery_publish_time.val {
        Some(last_time) => time - last_time >= 1000.0
        None => true
      }
      if should_publish {
        let data = @protocol.BatteryStatus::new(
          status.level(),
          status.is_charging(),
          true,
        )
        let record = @protocol.BatteryStatusRecord::new(
          data,
          sample_timestamp(time),
        )
        ignore(
          publish_payload(
            @protocol.battery_status_input(xr_robot_id.val),
            BATTERY_STATUS_SCHEMA_ID,
            "browser:battery",
            time,
            @protocol.encode_battery_status_record(record),
          ),
        )
        last_battery_publish_time.val = Some(time)
      }
    }
  }
}

///|
fn publish_controller_snapshot(
  controller : @three.Group,
  grip : @three.Group,
  source : @three_xr.XRInputSource?,
  handedness : String,
  time : Double,
) -> Unit {
  match source {
    Some(source) if source.has_hand() => return
    _ => ()
  }
  let aim_pose = @three_xr.pose_from_object(controller.as_object3d())
  let grip_pose = @three_xr.pose_from_object(grip.as_object3d())
  if source is None && aim_pose is None && grip_pose is None {
    return
  }
  let aim = match aim_pose {
    Some(pose) => @protocol.ControllerPose::new(protocol_pose(pose), true)
    None => @protocol.ControllerPose::new(default_protocol_pose(), false)
  }
  let grip = match grip_pose {
    Some(pose) => @protocol.ControllerPose::new(protocol_pose(pose), true)
    None => @protocol.ControllerPose::new(default_protocol_pose(), false)
  }
  let data = @protocol.ControllerSnapshot::new(
    grip,
    aim,
    protocol_controller_input(source),
  )
  let record = @protocol.ControllerSnapshotRecord::new(
    data,
    sample_timestamp(time),
  )
  let source_name = if handedness == "" || handedness == "none" {
    "unknown"
  } else {
    handedness
  }
  ignore(
    publish_payload(
      @protocol.controller_snapshot_input(xr_robot_id.val),
      CONTROLLER_SNAPSHOT_SCHEMA_ID,
      "webxr:" + source_name,
      time,
      @protocol.encode_controller_snapshot_record(record),
    ),
  )
}

///|
fn publish_hand_pose(
  hand : @three.Group,
  handedness : String,
  time : Double,
) -> Unit {
  match @three_xr.hand_sample(hand) {
    Some(sample) => {
      let poses : Array[@protocol.HandJointPose] = []
      let mut index = 0
      while index < @protocol.NUM_JOINTS {
        let joint_pose = sample.joint_pose(index)
        let pose = match joint_pose {
          Some(pose) => protocol_pose(pose)
          None => default_protocol_pose()
        }
        let valid = joint_pose is Some(_)
        poses.push(
          @protocol.HandJointPose::new(pose, valid, sample.joint_radius(index)),
        )
        index += 1
      }
      let data = @protocol.HandPose::new(@protocol.HandJoints::new(poses))
      let record = @protocol.HandPoseRecord::new(data, sample_timestamp(time))
      let source_name = if handedness == "" || handedness == "none" {
        "unknown"
      } else {
        handedness
      }
      ignore(
        publish_payload(
          @protocol.hand_pose_input(xr_robot_id.val),
          HAND_POSE_SCHEMA_ID,
          "webxr:" + source_name,
          time,
          @protocol.encode_hand_pose_record(record),
        ),
      )
    }
    None => ()
  }
}

///|
fn publish_xr_frame(
  manager : @three_xr.WebXRManager,
  controller0 : @three.Group,
  grip0 : @three.Group,
  source0 : @three_xr.XRInputSource?,
  handedness0 : String,
  hand0 : @three.Group,
  controller1 : @three.Group,
  grip1 : @three.Group,
  source1 : @three_xr.XRInputSource?,
  handedness1 : String,
  hand1 : @three.Group,
  time : Double,
) -> Unit {
  if !manager.is_presenting() || !protocol_stream_ready() {
    return
  }
  publish_head_pose(manager, time)
  publish_battery_status(time)
  publish_controller_snapshot(controller0, grip0, source0, handedness0, time)
  publish_controller_snapshot(controller1, grip1, source1, handedness1, time)
  publish_hand_pose(hand0, handedness0, time)
  publish_hand_pose(hand1, handedness1, time)
}
