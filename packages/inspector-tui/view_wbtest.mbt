///|
test "render includes bridge inspector panes" {
  let state = InspectorState::new()
  let output = @vnode.render_vnode_once(100, 48, render(state, 100, 48))
  assert_true(output.contains("Kaguya Bridge Inspector"))
  assert_true(output.contains("Left hand"))
  assert_true(output.contains("Right hand"))
  assert_true(output.contains("palm ="))
  assert_true(output.contains("Metrics"))
  assert_true(output.contains("Logs"))
}

///|
test "landmark coordinates use fixed-width formatting" {
  assert_eq(format_coordinate(1.25), "+01.250")
  assert_eq(format_coordinate(-2.5), "-02.500")
}
