///|
test "topics use the stable namespace" {
  assert_eq(TOPIC_ROOT, "kaguya/v1")
  assert_eq(
    controller_snapshot_input("atlas"),
    "kaguya/v1/atlas/input/controller_snapshot",
  )
  assert_eq(rgb_output("atlas"), "kaguya/v1/atlas/output/rgb")
  assert_eq(
    event("atlas", "episode_started"),
    "kaguya/v1/atlas/event/episode_started",
  )
}
