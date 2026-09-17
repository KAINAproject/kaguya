///|
pub const TOPIC_ROOT = "kaguya/v1"

///|
pub fn topic(robot_id : String, path : String) -> String {
  "\{TOPIC_ROOT}/\{robot_id}/\{path}"
}

///|
pub fn input(robot_id : String) -> String {
  topic(robot_id, "input/**")
}

///|
pub fn controller_input(robot_id : String) -> String {
  topic(robot_id, "input/controller")
}

///|
pub fn hmd_pose_input(robot_id : String) -> String {
  topic(robot_id, "input/hmd_pose")
}

///|
pub fn hand_landmarks_input(robot_id : String) -> String {
  topic(robot_id, "input/hand_landmarks")
}

///|
pub fn output(robot_id : String) -> String {
  topic(robot_id, "output/**")
}

///|
pub fn joint_state_output(robot_id : String) -> String {
  topic(robot_id, "output/joint_state")
}

///|
pub fn rgb_output(robot_id : String) -> String {
  topic(robot_id, "output/rgb")
}

///|
pub fn state(robot_id : String, name : String) -> String {
  topic(robot_id, "state/\{name}")
}

///|
pub fn event(robot_id : String, name : String) -> String {
  topic(robot_id, "event/\{name}")
}

///|
pub fn debug(robot_id : String, name : String) -> String {
  topic(robot_id, "debug/\{name}")
}
