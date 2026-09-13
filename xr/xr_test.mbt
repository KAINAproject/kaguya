///|
test "ViewerPose exposes the views in frame order" {
  let left = @xr.View::new("left", [1.0, 0.0, 0.0, 0.0], [1.0, 0.0, 0.0, 0.0])
  let right = @xr.View::new("right", [2.0, 0.0, 0.0, 0.0], [2.0, 0.0, 0.0, 0.0])
  let pose = @xr.ViewerPose::new([left, right])
  assert_eq(pose.view_count(), 2)
  assert_eq(pose.view(0).eye(), "left")
  assert_eq(pose.view(1).projection_matrix()[0], 2.0)
}
