///|
pub fn clear(device : @web.Device, context : @web.CanvasContext) -> Unit {
  let encoder = device.create_command_encoder()
  let texture = context.get_current_texture()
  let view = texture.create_view()
  let pass = encoder.begin_clear_pass(view, 0.05, 0.08, 0.16, 1.0)
  pass.end()
  let command_buffer = encoder.finish()
  device.submit(command_buffer)
}
