///|
fn read_xr_matrix(view : @ffi.XRView, projection : Bool) -> Array[Double] {
  Array::makei(16, fn(index) {
    if projection {
      view.projection_value(index)
    } else {
      view.view_value(index)
    }
  })
}

///|
async fn initialize() -> Unit {
  let canvas = @ffi.canvas()
  let status = @ffi.status()
  status.set_message("WebGPU adapter を取得しています…", "info")

  let gpu = @ffi.gpu()
  let adapter = gpu.request_adapter(true).wait()
  status.set_message("WebGPU device を取得しています…", "info")
  let device = adapter.request_device().wait()
  let context = canvas.get_context()
  let format = gpu.preferred_canvas_format()
  context.configure(device, format)
  let canvas_pipeline = @webgpu.create_cube_pipeline(device, format)
  let cube_vertex_buffer = @webgpu.create_cube_vertex_buffer(device)
  let cube_uniform_buffer = @webgpu.create_cube_uniform_buffer(device)
  let canvas_bind_group = @webgpu.create_cube_bind_group(
    device, canvas_pipeline, cube_uniform_buffer,
  )
  let mut active_pipeline = canvas_pipeline
  let mut active_bind_group = canvas_bind_group
  let mut active_format = format
  let mut in_xr = false
  let mut select_pressed = false
  let dimensions = canvas.resize()
  let mut depth_width = canvas.pixel_width()
  let mut depth_height = canvas.pixel_height()
  let mut depth_texture = device.create_depth_texture(depth_width, depth_height)
  let mut depth_view = depth_texture.create_view()
  let render = (timestamp : Double) => {
    if in_xr {
      return
    }
    ignore(canvas.resize())
    let width = canvas.pixel_width()
    let height = canvas.pixel_height()
    if width != depth_width || height != depth_height {
      depth_width = width
      depth_height = height
      depth_texture.destroy()
      depth_texture = device.create_depth_texture(width, height)
      depth_view = depth_texture.create_view()
    }
    let aspect = width.to_double() / height.to_double()
    let projection = @math.Mat4::perspective(
      3.141592653589793 / 3.0,
      aspect,
      0.1,
      100.0,
    )
    let view = @math.Mat4::translation(0.0, 0.0, -4.0)
    let model = @math.Mat4::rotation_y(timestamp / 2000.0)
    let mvp = projection.mul(view.mul(model))
    @webgpu.update_cube_uniform(device, cube_uniform_buffer, mvp)
    @webgpu.draw_cube(
      device, context, active_pipeline, cube_vertex_buffer, active_bind_group, depth_view,
    )
  }
  @ffi.start_animation_frame(render)
  device.on_lost(message => status.set_message(message, "error"))
  status.set_message("WebGPU initialized (\{dimensions})", "success")
  let draw_xr = fn(
    timestamp : Double,
    binding : @ffi.XRGPUBinding,
    layer : @ffi.XRProjectionLayer,
    pose : @ffi.XRViewerPose,
  ) {
    let xr_format = binding.get_preferred_color_format()
    if active_format != xr_format {
      active_pipeline = @webgpu.create_cube_pipeline(device, xr_format)
      active_bind_group = @webgpu.create_cube_bind_group(
        device, active_pipeline, cube_uniform_buffer,
      )
      active_format = xr_format
    }
    let model = @math.Mat4::rotation_y(timestamp / 2000.0)
    for index = 0; index < pose.view_count(); index = index + 1 {
      let xr_view = pose.view(index)
      let projection = @math.Mat4::from_array(read_xr_matrix(xr_view, true))
      let view = @math.Mat4::from_array(read_xr_matrix(xr_view, false))
      let mvp = projection.mul(view.mul(model))
      @webgpu.update_cube_uniform(device, cube_uniform_buffer, mvp)
      let encoder = device.create_command_encoder()
      let sub_image = binding.get_view_sub_image(layer, xr_view)
      let clear_red = if select_pressed { 0.65 } else { 0.05 }
      let clear_green = if select_pressed { 0.12 } else { 0.08 }
      let clear_blue = if select_pressed { 0.08 } else { 0.16 }
      let pass = encoder.begin_depth_pass(
        sub_image.color_view(),
        sub_image.depth_view(),
        clear_red,
        clear_green,
        clear_blue,
        1.0,
      )
      pass.set_viewport(
        sub_image.viewport_value(0),
        sub_image.viewport_value(1),
        sub_image.viewport_value(2),
        sub_image.viewport_value(3),
      )
      pass.set_pipeline(active_pipeline)
      pass.set_bind_group(0, active_bind_group)
      pass.set_vertex_buffer(0, cube_vertex_buffer)
      pass.draw(36)
      pass.end()
      device.submit(encoder.finish())
    }
  }
  let on_started = fn() { in_xr = true }
  let on_ended = fn() {
    in_xr = false
    select_pressed = false
    active_pipeline = canvas_pipeline
    active_bind_group = canvas_bind_group
    active_format = format
  }
  let on_select = fn(handedness, pressed) {
    select_pressed = pressed
    if pressed {
      status.set_message("XR selectstart (\{handedness})", "success")
    } else {
      status.set_message("XR selectend (\{handedness})", "info")
    }
  }
  if @ffi.has_xr_gpu() {
    setup_xr_button_with_renderer(
      device, draw_xr, on_select, on_started, on_ended,
    )
  } else if @ffi.has_xr_webgl() {
    let renderer = @webgpu.create_cube_webgl_xr_renderer()
    let draw_xr_webgl = fn(
      timestamp : Double,
      layer : @ffi.XRWebGLLayer,
      pose : @ffi.XRViewerPose,
    ) {
      let model = @math.Mat4::rotation_y(timestamp / 2000.0)
      for index = 0; index < pose.view_count(); index = index + 1 {
        let xr_view = pose.view(index)
        let projection = @math.Mat4::from_array(read_xr_matrix(xr_view, true))
        let view = @math.Mat4::from_array(read_xr_matrix(xr_view, false))
        let mvp = projection.mul(view.mul(model))
        renderer.draw_cube(layer, xr_view, mvp.to_fixed_array(), select_pressed)
      }
    }
    setup_xr_button_with_webgl_renderer(
      renderer, draw_xr_webgl, on_select, on_started, on_ended,
    )
  } else {
    setup_xr_button()
  }
}

///|
async fn start_async() -> Unit {
  try initialize() catch {
    error => {
      let status = @ffi.status()
      status.set_message(error.to_string(), "error")
    }
  } noraise {
    _ => ()
  }
}

///|
pub fn start() -> @js_async.Promise[Unit] {
  @js_async.Promise::from_async(start_async)
}
