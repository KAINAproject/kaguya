///|
test "Vec3 cross product and normalization" {
  let x = @math.Vec3::new(1.0, 0.0, 0.0)
  let y = @math.Vec3::new(0.0, 1.0, 0.0)
  let z = x.cross(y)
  assert_eq(z.x, 0.0)
  assert_eq(z.y, 0.0)
  assert_eq(z.z, 1.0)
  let normalized = @math.Vec3::new(3.0, 0.0, 4.0).normalize()
  assert_true((normalized.x - 0.6).abs() < 0.000000000000001)
  assert_true((normalized.z - 0.8).abs() < 0.000000000000001)
}

///|
test "ray intersects an axis-aligned cube" {
  let hit = @math.ray_intersects_aabb(
    @math.Vec3::new(0.0, 0.0, 0.0),
    @math.Vec3::new(0.0, 0.0, -1.0),
    @math.Vec3::new(-0.5, -0.5, -2.5),
    @math.Vec3::new(0.5, 0.5, -1.5),
  )
  assert_true(hit)
  let miss = @math.ray_intersects_aabb(
    @math.Vec3::new(1.0, 0.0, 0.0),
    @math.Vec3::new(0.0, 0.0, -1.0),
    @math.Vec3::new(-0.5, -0.5, -2.5),
    @math.Vec3::new(0.5, 0.5, -1.5),
  )
  assert_false(miss)
}

///|
test "Mat4 multiplication preserves identity and translation" {
  let identity = @math.Mat4::identity()
  let translation = @math.Mat4::translation(1.0, 2.0, 3.0)
  let result = identity
    .mul(translation)
    .transform_point(@math.Vec3::new(4.0, 5.0, 6.0))
  assert_eq(result.x, 5.0)
  assert_eq(result.y, 7.0)
  assert_eq(result.z, 9.0)
}

///|
test "Mat4 rigid inverse preserves a rotated point" {
  let transform = @math.Mat4::translation(1.0, 2.0, 3.0).mul(
    @math.Mat4::rotation_y(3.141592653589793 / 2.0),
  )
  let result = transform
    .mul(transform.inverse_rigid())
    .transform_point(@math.Vec3::new(4.0, 5.0, 6.0))
  assert_true((result.x - 4.0).abs() < 0.000000000000001)
  assert_true((result.y - 5.0).abs() < 0.000000000000001)
  assert_true((result.z - 6.0).abs() < 0.000000000000001)
}

///|
test "Mat4 scale transforms points" {
  let result = @math.Mat4::scale(2.0, 3.0, 4.0).transform_point(
    @math.Vec3::new(1.0, 1.0, 1.0),
  )
  assert_eq(result.x, 2.0)
  assert_eq(result.y, 3.0)
  assert_eq(result.z, 4.0)
}

///|
test "Mat4 perspective maps WebGPU depth to zero through one" {
  let projection = @math.Mat4::perspective(
    3.141592653589793 / 2.0,
    1.0,
    1.0,
    100.0,
  )
  let near = projection.transform_point(@math.Vec3::new(0.0, 0.0, -1.0))
  let far = projection.transform_point(@math.Vec3::new(0.0, 0.0, -100.0))
  assert_true(near.z.abs() < 0.000000000000001)
  assert_true((far.z - 1.0).abs() < 0.000000000000001)
}
