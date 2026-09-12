///|
fn triangle_shader() -> String {
  "@vertex\n" +
  "fn vs_main(@builtin(vertex_index) index : u32) -> @builtin(position) vec4f {\n" +
  "  var positions = array<vec2f, 3>(\n" +
  "    vec2f(0.0, 0.72),\n" +
  "    vec2f(-0.72, -0.62),\n" +
  "    vec2f(0.72, -0.62),\n" +
  "  );\n" +
  "  return vec4f(positions[index], 0.0, 1.0);\n" +
  "}\n" +
  "\n" +
  "@fragment\n" +
  "fn fs_main() -> @location(0) vec4f {\n" +
  "  return vec4f(0.95, 0.55, 0.18, 1.0);\n" +
  "}\n"
}

///|
pub fn create_triangle_pipeline(
  device : @web.Device,
  format : String,
) -> @web.RenderPipeline {
  let shader_module = device.create_shader_module(triangle_shader())
  device.create_render_pipeline(shader_module, format)
}

///|
pub fn draw_triangle(
  device : @web.Device,
  context : @web.CanvasContext,
  pipeline : @web.RenderPipeline,
) -> Unit {
  let encoder = device.create_command_encoder()
  let texture = context.get_current_texture()
  let view = texture.create_view()
  let pass = encoder.begin_clear_pass(view, 0.05, 0.08, 0.16, 1.0)
  pass.set_pipeline(pipeline)
  pass.draw(3)
  pass.end()
  let command_buffer = encoder.finish()
  device.submit(command_buffer)
}
