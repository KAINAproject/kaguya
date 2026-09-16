///|
pub fn create_spatial_ui_renderer(
  device : @web.Device,
  format : String,
) -> @web.SpatialUiRenderer {
  device.create_spatial_ui_renderer(format)
}

///|
pub fn update_spatial_ui(
  renderer : @web.SpatialUiRenderer,
  state : String,
  controller : String,
  label : String,
  detail : String,
) -> Unit {
  renderer.set_state(state, controller, label, detail)
}

///|
pub fn draw_spatial_ui(
  renderer : @web.SpatialUiRenderer,
  pass : @web.RenderPassEncoder,
  mvp : @math.Mat4,
) -> Unit {
  renderer.draw(pass, mvp.to_fixed_array())
}
