///|
fn connection_label(state : InspectorState) -> String {
  if state.connected {
    "● connected"
  } else {
    "○ disconnected"
  }
}

///|
fn logs_view(state : InspectorState) -> @vnode.TuiNode {
  let lines : Array[@vnode.TuiNode] = [
    @vnode.text("Logs", fg="yellow", bold=true),
  ]
  for line in state.logs {
    lines.push(@vnode.text(line, fg="gray"))
  }
  @vnode.column(border="rounded", border_color="gray", padding=1.0, lines)
}

///|
let joint_names : Array[String] = [
  "palm", "wrist", "thumb_meta", "thumb_prox", "thumb_dist", "thumb_tip", "index_meta",
  "index_prox", "index_inter", "index_dist", "index_tip", "middle_meta", "middle_prox",
  "middle_inter", "middle_dist", "middle_tip", "ring_meta", "ring_prox", "ring_inter",
  "ring_dist", "ring_tip", "little_meta", "little_prox", "little_inter", "little_dist",
  "little_tip",
]

///|
fn joint_name(index : Int) -> String {
  if index < joint_names.length() {
    joint_names[index]
  } else {
    "unknown"
  }
}

///|
fn pad_fraction(value : Int) -> String {
  if value < 10 {
    "00" + value.to_string()
  } else if value < 100 {
    "0" + value.to_string()
  } else {
    value.to_string()
  }
}

///|
fn format_coordinate(value : Float) -> String {
  let scaled = (value * 1000.0).round().to_int()
  let sign = if scaled < 0 { "-" } else { "+" }
  let absolute = if scaled < 0 { -scaled } else { scaled }
  let whole = absolute / 1000
  let fraction = absolute % 1000
  let whole_text = if whole < 10 {
    "0" + whole.to_string()
  } else {
    whole.to_string()
  }
  sign + whole_text + "." + pad_fraction(fraction)
}

///|
fn format_joint_line(index : Int, joint : @protocol.HandJointPose?) -> String {
  let missing = "  n/a  "
  match joint {
    None => "\{joint_name(index)} = (\{missing}, \{missing}, \{missing})"
    Some(joint) if !joint.is_valid =>
      "\{joint_name(index)} = (\{missing}, \{missing}, \{missing})"
    Some(joint) => {
      let point = joint.pose.position
      "\{joint_name(index)} = (\{format_coordinate(point.x)}, \{format_coordinate(point.y)}, \{format_coordinate(point.z)})"
    }
  }
}

///|
fn hand_stats_view(
  title : String,
  valid_joints : Int,
  sequence : UInt64,
  joints : Array[@protocol.HandJointPose],
) -> @vnode.TuiNode {
  let lines : Array[@vnode.TuiNode] = [
    @vnode.text(title, fg="cyan", bold=true),
    @vnode.text("valid joints: \{valid_joints}/26"),
    @vnode.text("sequence: \{sequence}"),
  ]
  let mut index = 0
  while index < joint_names.length() {
    let joint = if index < joints.length() { Some(joints[index]) } else { None }
    lines.push(@vnode.text(format_joint_line(index, joint)))
    index += 1
  }
  @vnode.column(border="rounded", border_color="cyan", padding=1.0, lines)
}

///|
pub fn render(
  state : InspectorState,
  width : Int,
  height : Int,
) -> @vnode.TuiNode {
  @vnode.column(
    width=width.to_double(),
    height=height.to_double(),
    padding=1.0,
    [
      @vnode.row(justify="space-between", [
        @vnode.text("Kaguya Bridge Inspector", fg="green", bold=true),
        @vnode.text(connection_label(state)),
      ]),
      @vnode.row(flex_grow=1.0, gap=1.0, [
        hand_stats_view(
          "Left hand",
          state.left_valid_joints,
          state.left_sequence,
          state.left_joints,
        ),
        hand_stats_view(
          "Right hand",
          state.right_valid_joints,
          state.right_sequence,
          state.right_joints,
        ),
        @vnode.column(border="rounded", border_color="magenta", padding=1.0, [
          @vnode.text("Metrics", fg="magenta", bold=true),
          @vnode.text("rx frames: \{state.rx_frames}"),
          @vnode.text("hand frames: \{state.hand_frames}"),
          @vnode.text("decode errors: \{state.decode_errors}"),
        ]),
      ]),
      logs_view(state),
    ],
  )
}
