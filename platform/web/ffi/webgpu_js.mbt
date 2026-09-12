///|
#external
pub type Canvas

///|
#external
pub type StatusElement

///|
#external
pub type Gpu

///|
#external
pub type Adapter

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
extern "js" fn document_canvas() -> Canvas =
  #| () => {
  #|   const canvas = document.querySelector("#canvas")
  #|   if (!canvas) throw new Error("Canvas が見つかりません")
  #|   return canvas
  #| }

///|
extern "js" fn document_status() -> StatusElement =
  #| () => {
  #|   const status = document.querySelector("#status")
  #|   if (!status) throw new Error("status element が見つかりません")
  #|   return status
  #| }

///|
pub fn canvas() -> Canvas {
  document_canvas()
}

///|
pub fn status() -> StatusElement {
  document_status()
}

///|
pub extern "js" fn StatusElement::set_message(
  self : StatusElement,
  message : String,
  kind : String,
) -> Unit =
  #| (status, message, kind) => {
  #|   status.textContent = message
  #|   status.dataset.kind = kind
  #| }

///|
pub extern "js" fn Canvas::resize(self : Canvas) -> String =
  #| (canvas) => {
  #|   const pixelRatio = window.devicePixelRatio || 1
  #|   const width = Math.max(1, Math.floor(canvas.clientWidth * pixelRatio))
  #|   const height = Math.max(1, Math.floor(canvas.clientHeight * pixelRatio))
  #|   if (canvas.width !== width) canvas.width = width
  #|   if (canvas.height !== height) canvas.height = height
  #|   return `${canvas.width} × ${canvas.height}`
  #| }

///|
pub extern "js" fn Canvas::on_resize(
  self : Canvas,
  callback : () -> Unit,
) -> Unit =
  #| (_canvas, callback) => window.addEventListener("resize", callback)

///|
extern "js" fn navigator_gpu() -> Gpu =
  #| () => {
  #|   if (!navigator.gpu) throw new Error("このブラウザでは WebGPU が利用できません")
  #|   return navigator.gpu
  #| }

///|
pub fn gpu() -> Gpu {
  navigator_gpu()
}

///|
pub extern "js" fn Gpu::request_adapter(
  self : Gpu,
) -> @js_async.Promise[Adapter] =
  #| (gpu) => gpu.requestAdapter().then((adapter) => {
  #|   if (!adapter) throw new Error("WebGPU adapter を取得できませんでした")
  #|   return adapter
  #| })

///|
pub extern "js" fn Adapter::request_device(
  self : Adapter,
) -> @js_async.Promise[Device] =
  #| (adapter) => adapter.requestDevice()

///|
pub extern "js" fn Gpu::preferred_canvas_format(self : Gpu) -> String =
  #| (gpu) => gpu.getPreferredCanvasFormat()

///|
pub extern "js" fn Canvas::get_context(self : Canvas) -> CanvasContext =
  #| (canvas) => {
  #|   const context = canvas.getContext("webgpu")
  #|   if (!context) throw new Error("Canvas の WebGPU context を取得できませんでした")
  #|   return context
  #| }

///|
pub extern "js" fn CanvasContext::configure(
  self : CanvasContext,
  device : Device,
  format : String,
) -> Unit =
  #| (context, device, format) => context.configure({ device, format, alphaMode: "opaque" })

///|
pub extern "js" fn Device::on_lost(
  self : Device,
  callback : (String) -> Unit,
) -> Unit =
  #| (device, callback) => device.lost.then((info) => {
  #|   if (info.reason !== "destroyed") callback(`WebGPU device lost: ${info.message || info.reason}`)
  #| })

///|
pub extern "js" fn Device::create_command_encoder(
  self : Device,
) -> CommandEncoder =
  #| (device) => device.createCommandEncoder()

///|
pub extern "js" fn Device::submit(
  self : Device,
  command_buffer : CommandBuffer,
) -> Unit =
  #| (device, commandBuffer) => device.queue.submit([commandBuffer])

///|
pub extern "js" fn CanvasContext::get_current_texture(
  self : CanvasContext,
) -> Texture =
  #| (context) => context.getCurrentTexture()

///|
pub extern "js" fn Texture::create_view(self : Texture) -> TextureView =
  #| (texture) => texture.createView()

///|
pub extern "js" fn CommandEncoder::begin_clear_pass(
  self : CommandEncoder,
  view : TextureView,
  red : Double,
  green : Double,
  blue : Double,
  alpha : Double,
) -> RenderPassEncoder =
  #| (encoder, view, red, green, blue, alpha) => encoder.beginRenderPass({
  #|   colorAttachments: [{
  #|     view,
  #|     clearValue: { r: red, g: green, b: blue, a: alpha },
  #|     loadOp: "clear",
  #|     storeOp: "store",
  #|   }],
  #| })

///|
pub extern "js" fn RenderPassEncoder::end(self : RenderPassEncoder) -> Unit =
  #| (pass) => pass.end()

///|
pub extern "js" fn CommandEncoder::finish(
  self : CommandEncoder,
) -> CommandBuffer =
  #| (encoder) => encoder.finish()
