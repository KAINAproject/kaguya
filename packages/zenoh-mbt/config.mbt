///|
/// Configuration passed to `Session::open`.
#external
pub type Config

///|
#module("@kaguya/zenoh-mbt/config")
pub extern "js" fn Config::new(locator : String, timeout_ms : Int) -> Config = "config"
