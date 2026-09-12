///|
#export_name("kaguya_start")
pub fn start() -> @js_async.Promise[Unit] {
  @web.start()
}
