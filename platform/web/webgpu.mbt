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
fn read_controller_matrix(controller : @ffi.XRControllerPose) -> Array[Double] {
  Array::makei(16, fn(index) { controller.matrix_value(index) })
}

///|
fn read_controller_ray_matrix(
  controller : @ffi.XRControllerPose,
) -> Array[Double] {
  Array::makei(16, fn(index) { controller.ray_matrix_value(index) })
}

///|
fn target_model(selected : Bool) -> @math.Mat4 {
  let size = if selected { 0.35 } else { 0.25 }
  @math.Mat4::translation(0.0, 0.0, -2.0).mul(
    @math.Mat4::scale(size, size, size),
  )
}

///|
fn controller_marker_model(controller : @ffi.XRControllerPose) -> @math.Mat4 {
  @math.Mat4::from_array(read_controller_matrix(controller)).mul(
    @math.Mat4::scale(0.08, 0.08, 0.08),
  )
}

///|
fn controller_ray_model(controller : @ffi.XRControllerPose) -> @math.Mat4 {
  @math.Mat4::from_array(read_controller_ray_matrix(controller)).mul(
    @math.Mat4::translation(0.0, 0.0, -1.5).mul(
      @math.Mat4::scale(0.015, 0.015, 1.5),
    ),
  )
}

///|
fn controller_ray_hits_target(
  controller : @ffi.XRControllerPose,
  target_size : Double,
) -> Bool {
  let matrix = read_controller_ray_matrix(controller)
  let origin = @math.Vec3::new(matrix[12], matrix[13], matrix[14])
  let direction = @math.Vec3::new(-matrix[8], -matrix[9], -matrix[10]).normalize()
  @math.ray_intersects_aabb(
    origin,
    direction,
    @math.Vec3::new(-target_size, -target_size, -2.0 - target_size),
    @math.Vec3::new(target_size, target_size, -2.0 + target_size),
  )
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
  let controller_uniform_buffer = @webgpu.create_cube_uniform_buffer(device)
  let ray_uniform_buffer = @webgpu.create_cube_uniform_buffer(device)
  let canvas_bind_group = @webgpu.create_cube_bind_group(
    device, canvas_pipeline, cube_uniform_buffer,
  )
  let mut active_controller_bind_group = @webgpu.create_cube_bind_group(
    device, canvas_pipeline, controller_uniform_buffer,
  )
  let mut active_ray_bind_group = @webgpu.create_cube_bind_group(
    device, canvas_pipeline, ray_uniform_buffer,
  )
  let mut active_pipeline = canvas_pipeline
  let mut active_bind_group = canvas_bind_group
  let mut active_format = format
  let mut in_xr = false
  let mut select_pressed = false
  let mut cube_selected = false
  let mut ray_hit = false
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
    controller : @ffi.XRControllerPose,
  ) {
    let xr_format = binding.get_preferred_color_format()
    if active_format != xr_format {
      active_pipeline = @webgpu.create_cube_pipeline(device, xr_format)
      active_bind_group = @webgpu.create_cube_bind_group(
        device, active_pipeline, cube_uniform_buffer,
      )
      active_controller_bind_group = @webgpu.create_cube_bind_group(
        device, active_pipeline, controller_uniform_buffer,
      )
      active_ray_bind_group = @webgpu.create_cube_bind_group(
        device, active_pipeline, ray_uniform_buffer,
      )
      active_format = xr_format
    }
    let target_size = if cube_selected { 0.35 } else { 0.25 }
    ray_hit = controller.is_valid() &&
      controller_ray_hits_target(controller, target_size)
    for index = 0; index < pose.view_count(); index = index + 1 {
      let xr_view = pose.view(index)
      let projection = @math.Mat4::from_array(read_xr_matrix(xr_view, true))
      let view = @math.Mat4::from_array(read_xr_matrix(xr_view, false))
      let model = if controller.is_valid() {
        target_model(cube_selected)
      } else {
        @math.Mat4::rotation_y(timestamp / 2000.0)
      }
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
      if controller.is_valid() {
        let controller_mvp = projection.mul(
          view.mul(controller_marker_model(controller)),
        )
        let ray_mvp = projection.mul(view.mul(controller_ray_model(controller)))
        @webgpu.update_cube_uniform(
          device, controller_uniform_buffer, controller_mvp,
        )
        @webgpu.update_cube_uniform(device, ray_uniform_buffer, ray_mvp)
        pass.set_bind_group(0, active_controller_bind_group)
        pass.draw(36)
        pass.set_bind_group(0, active_ray_bind_group)
        pass.draw(36)
      }
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
    active_controller_bind_group = @webgpu.create_cube_bind_group(
      device, canvas_pipeline, controller_uniform_buffer,
    )
    active_ray_bind_group = @webgpu.create_cube_bind_group(
      device, canvas_pipeline, ray_uniform_buffer,
    )
    active_format = format
    cube_selected = false
    ray_hit = false
  }
  let on_select = fn(handedness, pressed) {
    select_pressed = pressed
    if pressed {
      if ray_hit {
        cube_selected = true
        status.set_message(
          "XR selectstart (\{handedness}), Cube selected",
          "success",
        )
      } else {
        status.set_message("XR selectstart (\{handedness})", "success")
      }
    } else if cube_selected {
      status.set_message("XR selectend (\{handedness}), Cube selected", "info")
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
      controller : @ffi.XRControllerPose,
    ) {
      let target_size = if cube_selected { 0.35 } else { 0.25 }
      ray_hit = controller.is_valid() &&
        controller_ray_hits_target(controller, target_size)
      for index = 0; index < pose.view_count(); index = index + 1 {
        let xr_view = pose.view(index)
        let projection = @math.Mat4::from_array(read_xr_matrix(xr_view, true))
        let view = @math.Mat4::from_array(read_xr_matrix(xr_view, false))
        let target = if controller.is_valid() {
          target_model(cube_selected)
        } else {
          @math.Mat4::rotation_y(timestamp / 2000.0)
        }
        let target_mvp = projection.mul(view.mul(target))
        renderer.draw_cube(
          layer,
          xr_view,
          target_mvp.to_fixed_array(),
          select_pressed,
          true,
        )
        if controller.is_valid() {
          let controller_mvp = projection.mul(
            view.mul(controller_marker_model(controller)),
          )
          let ray_mvp = projection.mul(
            view.mul(controller_ray_model(controller)),
          )
          renderer.draw_cube(
            layer,
            xr_view,
            controller_mvp.to_fixed_array(),
            select_pressed,
            false,
          )
          renderer.draw_cube(
            layer,
            xr_view,
            ray_mvp.to_fixed_array(),
            select_pressed,
            false,
          )
        }
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
