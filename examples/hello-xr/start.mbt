///|
#export_name("kaguya_start")
pub fn kaguya_start() -> @js_async.Promise[Unit] {
  @web.start()
}
