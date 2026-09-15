///|
async fn check_xr_support(button : @ffi.Button) -> Unit {
  try {
    if !@webxr.is_available() || (!@ffi.has_xr_gpu() && !@ffi.has_xr_webgl()) {
      button.set_label("WebXR は利用できません")
      return
    }
    let supported = @ffi.xr().is_session_supported("immersive-vr").wait()
    if supported {
      if @ffi.has_xr_gpu() {
        button.set_label("VR を開始")
      } else {
        button.set_label("VR を開始（WebGL）")
      }
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
async fn start_webgl_async(
  renderer : @ffi.WebGLXRRenderer,
  on_frame : (
    Double,
    @ffi.XRWebGLLayer,
    @ffi.XRViewerPose,
    @ffi.XRControllerPose,
  ) -> Unit,
  on_select : (String, Bool) -> Unit,
  on_end : () -> Unit,
) -> Unit {
  let session = @ffi.xr().request_immersive_vr_session().wait()
  let reference_space = session.request_reference_space().wait()
  let layer = session.create_webgl_layer(renderer.context())
  session.update_render_state_webgl(layer)
  session.on_end(on_end)
  session.on_select(on_select)
  session.request_animation_frame(reference_space, fn(time, pose, controller) {
    on_frame(time, layer, pose, controller)
  })
}

///|
async fn enter_xr_with_webgl_renderer(
  button : @ffi.Button,
  renderer : @ffi.WebGLXRRenderer,
  on_frame : (
    Double,
    @ffi.XRWebGLLayer,
    @ffi.XRViewerPose,
    @ffi.XRControllerPose,
  ) -> Unit,
  on_select : (String, Bool) -> Unit,
  on_started : () -> Unit,
  on_ended : () -> Unit,
) -> Unit {
  let status = @ffi.status()
  button.set_enabled(false)
  button.set_label("VR セッションを開始しています…")
  on_started()
  let mut first_frame = true
  try
    start_webgl_async(
      renderer,
      fn(time, layer, pose, controller) {
        if first_frame {
          first_frame = false
          status.set_message(
            "WebXR session active (\{pose.view_count()} views, WebGL), controller: \{controller.handedness()}",
            "success",
          )
        }
        on_frame(time, layer, pose, controller)
      },
      on_select,
      fn() {
        on_ended()
        button.set_label("VR を開始（WebGL）")
        button.set_enabled(true)
        status.set_message("WebXR session ended", "info")
      },
    )
  catch {
    error => {
      on_ended()
      button.set_label("VR を開始（WebGL）")
      button.set_enabled(true)
      status.set_message(error.to_string(), "error")
    }
  } noraise {
    _ => ()
  }
}

///|
fn setup_xr_button_with_webgl_renderer(
  renderer : @ffi.WebGLXRRenderer,
  on_frame : (
    Double,
    @ffi.XRWebGLLayer,
    @ffi.XRViewerPose,
    @ffi.XRControllerPose,
  ) -> Unit,
  on_select : (String, Bool) -> Unit,
  on_started : () -> Unit,
  on_ended : () -> Unit,
) -> Unit {
  if !@ffi.has_xr_button() {
    return
  }
  let button = @ffi.xr_button()
  button.set_enabled(false)
  button.on_click(fn() {
    ignore(
      @js_async.Promise::from_async(() => {
        enter_xr_with_webgl_renderer(
          button, renderer, on_frame, on_select, on_started, on_ended,
        )
      }),
    )
  })
  ignore(@js_async.Promise::from_async(() => check_xr_support(button)))
}

///|
async fn start_native_async(
  device : @ffi.Device,
  on_frame : (
    Double,
    @ffi.XRGPUBinding,
    @ffi.XRProjectionLayer,
    @ffi.XRViewerPose,
    @ffi.XRControllerPose,
  ) -> Unit,
  on_select : (String, Bool) -> Unit,
  on_end : () -> Unit,
) -> Unit {
  let session = @ffi.xr().request_immersive_vr_webgpu_session().wait()
  let reference_space = session.request_reference_space().wait()
  let binding = session.create_gpu_binding(device)
  let layer = binding.create_projection_layer(
    binding.get_preferred_color_format(),
    "depth24plus",
  )
  session.update_render_state(layer)
  session.on_end(on_end)
  session.on_select(on_select)
  session.request_animation_frame(reference_space, fn(time, pose, controller) {
    on_frame(time, binding, layer, pose, controller)
  })
}

///|
async fn enter_xr_with_renderer(
  button : @ffi.Button,
  device : @ffi.Device,
  on_frame : (
    Double,
    @ffi.XRGPUBinding,
    @ffi.XRProjectionLayer,
    @ffi.XRViewerPose,
    @ffi.XRControllerPose,
  ) -> Unit,
  on_select : (String, Bool) -> Unit,
  on_started : () -> Unit,
  on_ended : () -> Unit,
) -> Unit {
  let status = @ffi.status()
  button.set_enabled(false)
  button.set_label("VR セッションを開始しています…")
  on_started()
  let mut first_frame = true
  try
    start_native_async(
      device,
      fn(time, binding, layer, pose, controller) {
        if first_frame {
          first_frame = false
          status.set_message(
            "WebXR session active (\{pose.view_count()} views), controller: \{controller.handedness()}",
            "success",
          )
        }
        on_frame(time, binding, layer, pose, controller)
      },
      on_select,
      fn() {
        on_ended()
        button.set_label("VR を開始")
        button.set_enabled(true)
        status.set_message("WebXR session ended", "info")
      },
    )
  catch {
    error => {
      on_ended()
      button.set_label("VR を開始")
      button.set_enabled(true)
      status.set_message(error.to_string(), "error")
    }
  } noraise {
    _ => ()
  }
}

///|
fn setup_xr_button_with_renderer(
  device : @ffi.Device,
  on_frame : (
    Double,
    @ffi.XRGPUBinding,
    @ffi.XRProjectionLayer,
    @ffi.XRViewerPose,
    @ffi.XRControllerPose,
  ) -> Unit,
  on_select : (String, Bool) -> Unit,
  on_started : () -> Unit,
  on_ended : () -> Unit,
) -> Unit {
  if !@ffi.has_xr_button() {
    return
  }
  let button = @ffi.xr_button()
  button.set_enabled(false)
  button.on_click(fn() {
    ignore(
      @js_async.Promise::from_async(() => {
        enter_xr_with_renderer(
          button, device, on_frame, on_select, on_started, on_ended,
        )
      }),
    )
  })
  ignore(@js_async.Promise::from_async(() => check_xr_support(button)))
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
