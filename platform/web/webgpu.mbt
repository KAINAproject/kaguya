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
  let triangle_pipeline = @webgpu.create_triangle_pipeline(device, format)

  let render = () => {
    ignore(canvas.resize())
    @webgpu.draw_triangle(device, context, triangle_pipeline)
  }
  let dimensions = canvas.resize()
  @webgpu.draw_triangle(device, context, triangle_pipeline)
  canvas.on_resize(render)
  device.on_lost(message => status.set_message(message, "error"))
  status.set_message("WebGPU initialized (\{dimensions})", "success")
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
