///|
pub fn is_available() -> Bool {
  @ffi.has_xr()
}

///|
async fn check_session_support() -> Bool {
  if !is_available() {
    false
  } else {
    @ffi.xr().is_session_supported("immersive-vr").wait()
  }
}

///|
pub fn is_session_supported() -> @js_async.Promise[Bool] {
  @js_async.Promise::from_async(check_session_support)
}

///|
fn read_matrix(view : @ffi.XRView, projection : Bool) -> Array[Double] {
  Array::makei(16, fn(index) {
    if projection {
      view.projection_value(index)
    } else {
      view.view_value(index)
    }
  })
}

///|
fn read_view(view : @ffi.XRView) -> @xr.View {
  @xr.View::new(view.eye(), read_matrix(view, true), read_matrix(view, false))
}

///|
fn read_pose(pose : @ffi.XRViewerPose) -> @xr.ViewerPose {
  let views = Array::makei(pose.view_count(), fn(index) {
    read_view(pose.view(index))
  })
  @xr.ViewerPose::new(views)
}

///|
async fn start_async(
  on_frame : (@xr.ViewerPose) -> Unit,
  on_end : () -> Unit,
) -> Unit {
  let session = @ffi.xr().request_immersive_vr_session().wait()
  let reference_space = session.request_reference_space().wait()
  session.on_end(on_end)
  session.request_animation_frame(reference_space, fn(time, pose, _controller) {
    on_frame(read_pose(pose))
    ignore(time)
  })
}

///|
/// Start an immersive VR session and forward each viewer pose to `on_frame`.
pub fn start(
  on_frame : (@xr.ViewerPose) -> Unit,
  on_end : () -> Unit,
) -> @js_async.Promise[Unit] {
  @js_async.Promise::from_async(() => start_async(on_frame, on_end))
}
