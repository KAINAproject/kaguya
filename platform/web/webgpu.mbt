///|
async fn initialize() -> Unit {
  let canvas = @ffi.canvas()
  let status = @ffi.status()
  status.set_message("WebGPU adapter を取得しています…", "info")

  let gpu = @ffi.gpu()
  let adapter = gpu.request_adapter().wait()
  status.set_message("WebGPU device を取得しています…", "info")
  let device = adapter.request_device().wait()
  let context = canvas.get_context()
  let format = gpu.preferred_canvas_format()
  context.configure(device, format)
  let cube_pipeline = @webgpu.create_cube_pipeline(device, format)
  let cube_vertex_buffer = @webgpu.create_cube_vertex_buffer(device)
  let cube_uniform_buffer = @webgpu.create_cube_uniform_buffer(device)
  let cube_bind_group = @webgpu.create_cube_bind_group(
    device, cube_pipeline, cube_uniform_buffer,
  )
  let dimensions = canvas.resize()
  let mut depth_width = canvas.pixel_width()
  let mut depth_height = canvas.pixel_height()
  let mut depth_texture = device.create_depth_texture(depth_width, depth_height)
  let mut depth_view = depth_texture.create_view()
  let render = (timestamp : Double) => {
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
      device, context, cube_pipeline, cube_vertex_buffer, cube_bind_group, depth_view,
    )
  }
  @ffi.start_animation_frame(render)
  device.on_lost(message => status.set_message(message, "error"))
  status.set_message("WebGPU initialized (\{dimensions})", "success")
}

///|
async fn start_async() -> Unit {
  setup_xr_button()
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
