///|
fn cube_shader() -> String {
  "struct Uniforms {\n" +
  "  mvp : mat4x4f,\n" +
  "};\n" +
  "\n" +
  "@group(0) @binding(0) var<uniform> uniforms : Uniforms;\n" +
  "\n" +
  "struct VertexOutput {\n" +
  "  @builtin(position) position : vec4f,\n" +
  "  @location(0) color : vec3f,\n" +
  "};\n" +
  "\n" +
  "@vertex\n" +
  "fn vs_main(\n" +
  "  @location(0) position : vec3f,\n" +
  "  @location(1) color : vec3f,\n" +
  ") -> VertexOutput {\n" +
  "  return VertexOutput(uniforms.mvp * vec4f(position, 1.0), color);\n" +
  "}\n" +
  "\n" +
  "@fragment\n" +
  "fn fs_main(input : VertexOutput) -> @location(0) vec4f {\n" +
  "  return vec4f(input.color, 1.0);\n" +
  "}\n"
}

///|
fn cube_vertices() -> FixedArray[Double] {
  let values : Array[Double] = [
    // Front (+Z), red.
    -1.0, -1.0, 1.0, 0.95, 0.20, 0.25, 1.0, -1.0, 1.0, 0.95, 0.20, 0.25, 1.0, 1.0,
    1.0, 0.95, 0.20, 0.25, -1.0, -1.0, 1.0, 0.95, 0.20, 0.25, 1.0, 1.0, 1.0, 0.95,
    0.20, 0.25, -1.0, 1.0, 1.0, 0.95, 0.20, 0.25,

    // Back (-Z), cyan.
     -1.0, -1.0, -1.0, 0.20, 0.85, 0.95, -1.0, 1.0, -1.0, 0.20, 0.85, 0.95, 1.0,
    1.0, -1.0, 0.20, 0.85, 0.95, -1.0, -1.0, -1.0, 0.20, 0.85, 0.95, 1.0, 1.0, -1.0,
    0.20, 0.85, 0.95, 1.0, -1.0, -1.0, 0.20, 0.85, 0.95,

    // Top (+Y), green.
     -1.0, 1.0, -1.0, 0.25, 0.90, 0.45, -1.0, 1.0, 1.0, 0.25, 0.90, 0.45, 1.0, 1.0,
    1.0, 0.25, 0.90, 0.45, -1.0, 1.0, -1.0, 0.25, 0.90, 0.45, 1.0, 1.0, 1.0, 0.25,
    0.90, 0.45, 1.0, 1.0, -1.0, 0.25, 0.90, 0.45,

    // Bottom (-Y), yellow.
     -1.0, -1.0, -1.0, 0.95, 0.80, 0.20, 1.0, -1.0, -1.0, 0.95, 0.80, 0.20, 1.0,
    -1.0, 1.0, 0.95, 0.80, 0.20, -1.0, -1.0, -1.0, 0.95, 0.80, 0.20, 1.0, -1.0, 1.0,
    0.95, 0.80, 0.20, -1.0, -1.0, 1.0, 0.95, 0.80, 0.20,

    // Right (+X), purple.
     1.0, -1.0, -1.0, 0.65, 0.35, 0.95, 1.0, 1.0, -1.0, 0.65, 0.35, 0.95, 1.0, 1.0,
    1.0, 0.65, 0.35, 0.95, 1.0, -1.0, -1.0, 0.65, 0.35, 0.95, 1.0, 1.0, 1.0, 0.65,
    0.35, 0.95, 1.0, -1.0, 1.0, 0.65, 0.35, 0.95,

    // Left (-X), orange.
     -1.0, -1.0, -1.0, 0.95, 0.45, 0.15, -1.0, -1.0, 1.0, 0.95, 0.45, 0.15, -1.0,
    1.0, 1.0, 0.95, 0.45, 0.15, -1.0, -1.0, -1.0, 0.95, 0.45, 0.15, -1.0, 1.0, 1.0,
    0.95, 0.45, 0.15, -1.0, 1.0, -1.0, 0.95, 0.45, 0.15,
  ]
  FixedArray::makei(values.length(), fn(i) { values[i] })
}

///|
pub fn create_cube_pipeline(
  device : @web.Device,
  format : String,
) -> @web.RenderPipeline {
  let shader_module = device.create_shader_module(cube_shader())
  device.create_mesh_render_pipeline(shader_module, format)
}

///|
pub fn create_cube_vertex_buffer(device : @web.Device) -> @web.GpuBuffer {
  device.create_vertex_buffer(cube_vertices())
}

///|
pub fn create_cube_uniform_buffer(device : @web.Device) -> @web.GpuBuffer {
  device.create_uniform_buffer(64)
}

///|
pub fn update_cube_uniform(
  device : @web.Device,
  uniform_buffer : @web.GpuBuffer,
  mvp : @math.Mat4,
) -> Unit {
  device.write_buffer(uniform_buffer, mvp.to_fixed_array())
}

///|
pub fn create_cube_bind_group(
  device : @web.Device,
  pipeline : @web.RenderPipeline,
  uniform_buffer : @web.GpuBuffer,
) -> @web.BindGroup {
  device.create_bind_group(pipeline, uniform_buffer)
}

///|
pub fn create_cube_webgl_xr_renderer() -> @web.WebGLXRRenderer {
  @web.create_webgl_xr_renderer(cube_vertices())
}

///|
pub fn draw_cube(
  device : @web.Device,
  context : @web.CanvasContext,
  pipeline : @web.RenderPipeline,
  vertex_buffer : @web.GpuBuffer,
  bind_group : @web.BindGroup,
  depth_view : @web.TextureView,
) -> Unit {
  let encoder = device.create_command_encoder()
  let texture = context.get_current_texture()
  let view = texture.create_view()
  let pass = encoder.begin_depth_pass(view, depth_view, 0.05, 0.08, 0.16, 1.0)
  pass.set_pipeline(pipeline)
  pass.set_bind_group(0, bind_group)
  pass.set_vertex_buffer(0, vertex_buffer)
  pass.draw(36)
  pass.end()
  let command_buffer = encoder.finish()
  device.submit(command_buffer)
}
