///|
const XR_MODE_VR : String = "vr"

///|
const XR_MODE_AR : String = "ar"

///|
let xr_mode : Ref[String] = Ref(XR_MODE_VR)

///|
#export_name("kaguya_set_xr_mode")
pub fn kaguya_set_xr_mode(mode : String) -> Unit {
  if mode == XR_MODE_AR {
    xr_mode.val = XR_MODE_AR
  } else {
    xr_mode.val = XR_MODE_VR
  }
}

///|
fn xr_is_passthrough() -> Bool {
  xr_mode.val == XR_MODE_AR
}

///|
fn xr_mode_label() -> String {
  if xr_is_passthrough() {
    "パススルー"
  } else {
    "VR"
  }
}

///|
async fn enter_xr(
  button : @dom.HTMLButtonElement,
  manager : @three_xr.WebXRManager,
  status : @dom.Element,
  passthrough : Bool,
) -> Unit {
  button_set_enabled(button, false)
  let label = if passthrough { "パススルー" } else { "VR" }
  button_set_label(
    button,
    "\{label} セッションを開始しています…",
  )
  try {
    let session = if passthrough {
      @three_xr.request_immersive_ar_session().wait()
    } else {
      @three_xr.request_immersive_vr_session().wait()
    }
    manager.set_session(session).wait()
    status_set_message(
      status,
      "WebXR \{label} session active (three.js WebGLRenderer)",
      "success",
    )
  } catch {
    error => {
      button_set_label(button, "\{label} を開始")
      button_set_enabled(button, true)
      status_set_message(status, error.to_string(), "error")
    }
  } noraise {
    _ => ()
  }
}
