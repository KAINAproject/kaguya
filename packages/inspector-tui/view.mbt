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
fn hand_stats_view(
  title : String,
  valid_joints : Int,
  sequence : UInt64,
) -> @vnode.TuiNode {
  @vnode.column(border="rounded", border_color="cyan", padding=1.0, [
    @vnode.text(title, fg="cyan", bold=true),
    @vnode.text("valid joints: \{valid_joints}/26"),
    @vnode.text("sequence: \{sequence}"),
    @vnode.text("latest telemetry", fg="gray"),
  ])
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
        ),
        hand_stats_view(
          "Right hand",
          state.right_valid_joints,
          state.right_sequence,
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
