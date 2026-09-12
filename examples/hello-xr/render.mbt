///|
#export_name("kaguya_render_clear")
pub fn render_clear(device : @web.Device, context : @web.CanvasContext) -> Unit {
  @webgpu.clear(device, context)
}
