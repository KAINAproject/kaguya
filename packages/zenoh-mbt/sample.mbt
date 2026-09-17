///|
/// A sample delivered to a subscriber.
pub struct Sample {
  key_expr : String
  payload : Bytes
}

///|
pub fn Sample::new(key_expr : String, payload : Bytes) -> Sample {
  { key_expr, payload, }
}

///|
pub fn Sample::key_expr(self : Sample) -> String {
  self.key_expr
}

///|
pub fn Sample::payload(self : Sample) -> Bytes {
  self.payload
}
