///|
#export_name("kaguya_start")
pub fn kaguya_start() -> @js_async.Promise[Unit] {
  start()
}

///|
pub fn start() -> @js_async.Promise[Unit] {
  @js_async.Promise::from_async(initialize)
}
