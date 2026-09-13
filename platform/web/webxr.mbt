///|
async fn check_xr_support(button : @ffi.Button) -> Unit {
  try {
    if !@webxr.is_available() {
      button.set_label("WebXR は利用できません")
      return
    }
    let supported = @webxr.is_session_supported().wait()
    if supported {
      button.set_label("VR を開始")
      button.set_enabled(true)
    } else {
      button.set_label("VR は利用できません")
    }
  } catch {
    _ => button.set_label("WebXR を確認できません")
  } noraise {
    _ => ()
  }
}

///|
async fn enter_xr(button : @ffi.Button) -> Unit {
  let status = @ffi.status()
  button.set_enabled(false)
  button.set_label("VR セッションを開始しています…")
  let mut first_frame = true
  try
    @webxr.start(
      fn(pose) {
        if first_frame {
          first_frame = false
          status.set_message(
            "WebXR session active (\{pose.view_count()} views)",
            "success",
          )
        }
      },
      fn() {
        button.set_label("VR を開始")
        button.set_enabled(true)
        status.set_message("WebXR session ended", "info")
      },
    ).wait()
  catch {
    error => {
      button.set_label("VR を開始")
      button.set_enabled(true)
      status.set_message(error.to_string(), "error")
    }
  } noraise {
    _ => ()
  }
}

///|
pub fn setup_xr_button() -> Unit {
  if !@ffi.has_xr_button() {
    return
  }
  let button = @ffi.xr_button()
  button.set_enabled(false)
  button.on_click(fn() {
    ignore(@js_async.Promise::from_async(() => enter_xr(button)))
  })
  ignore(@js_async.Promise::from_async(() => check_xr_support(button)))
}
