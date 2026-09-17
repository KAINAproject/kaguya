///|
let active_zenoh_session : Ref[@zenoh.Session?] = Ref(None)

///|
async fn open_zenoh(locator : String) -> Unit {
  let config = @zenoh.Config::new(locator, 500)
  let session = @zenoh.Session::open(config)
  active_zenoh_session.val = Some(session)
}

///|
#export_name("kaguya_zenoh_open")
pub fn kaguya_zenoh_open(locator : String) -> @js_async.Promise[Unit] {
  @js_async.Promise::from_async(() => open_zenoh(locator))
}

///|
async fn close_zenoh() -> Unit {
  match active_zenoh_session.val {
    Some(session) => {
      active_zenoh_session.val = None
      session.close()
    }
    None => ()
  }
}

///|
#export_name("kaguya_zenoh_close")
pub fn kaguya_zenoh_close() -> @js_async.Promise[Unit] {
  @js_async.Promise::from_async(close_zenoh)
}
