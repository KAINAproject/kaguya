///|
#external
pub type Device

///|
#external
pub type CanvasContext

///|
#external
pub type CommandEncoder

///|
#external
pub type RenderPassEncoder

///|
#external
pub type CommandBuffer

///|
#external
pub type Texture

///|
#external
pub type TextureView

///|
pub fn Device::create_command_encoder(self : Device) -> CommandEncoder = "webgpu" "device_create_command_encoder"

///|
pub fn Device::submit(self : Device, command_buffer : CommandBuffer) -> Unit = "webgpu" "device_queue_submit"

///|
pub fn CanvasContext::get_current_texture(self : CanvasContext) -> Texture = "webgpu" "context_get_current_texture"

///|
pub fn Texture::create_view(self : Texture) -> TextureView = "webgpu" "texture_create_view"

///|
pub fn CommandEncoder::begin_clear_pass(
  self : CommandEncoder,
  view : TextureView,
  red : Double,
  green : Double,
  blue : Double,
  alpha : Double,
) -> RenderPassEncoder = "webgpu" "command_encoder_begin_clear_pass"

///|
pub fn RenderPassEncoder::end(self : RenderPassEncoder) -> Unit = "webgpu" "render_pass_end"

///|
pub fn CommandEncoder::finish(self : CommandEncoder) -> CommandBuffer = "webgpu" "command_encoder_finish"
