///|
async fn enter_xr(
  button : @dom.HTMLButtonElement,
  manager : @three_xr.WebXRManager,
  status : @dom.Element,
) -> Unit {
  button_set_enabled(button, false)
  button_set_label(button, "VR セッションを開始しています…")
  try {
    let session = @three_xr.request_immersive_vr_session().wait()
    manager.set_session(session).wait()
    status_set_message(
      status, "WebXR session active (three.js WebGLRenderer)", "success",
    )
  } catch {
    error => {
      button_set_label(button, "VR を開始")
      button_set_enabled(button, true)
      status_set_message(status, error.to_string(), "error")
    }
  } noraise {
    _ => ()
  }
}
