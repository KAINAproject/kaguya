///|
test "sample keeps key expression and payload" {
  let sample = Sample::new("kaguya/test", b"payload")
  assert_eq(sample.key_expr(), "kaguya/test")
  assert_eq(sample.payload(), b"payload")
}
