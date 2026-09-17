///|
/// Zenoh payload encoding.
#external
pub type Encoding

///|
/// The protobuf encoding used by Kaguya protocol payloads.
#module("@kaguya/zenoh-mbt/encoding")
pub extern "js" fn Encoding::application_protobuf() -> Encoding = "applicationProtobuf"
