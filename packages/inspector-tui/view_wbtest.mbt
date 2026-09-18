///|
test "render includes bridge inspector panes" {
  let state = InspectorState::new()
  let output = @vnode.render_vnode_once(100, 24, render(state, 100, 24))
  assert_true(output.contains("Kaguya Bridge Inspector"))
  assert_true(output.contains("Left hand"))
  assert_true(output.contains("Right hand"))
  assert_true(output.contains("Metrics"))
  assert_true(output.contains("Logs"))
}
