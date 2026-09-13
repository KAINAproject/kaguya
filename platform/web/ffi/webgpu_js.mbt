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
#external
pub type ShaderModule

///|
#external
pub type RenderPipeline

///|
#external
pub type GpuBuffer

///|
#external
pub type BindGroup

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
pub extern "js" fn Canvas::pixel_width(self : Canvas) -> Int =
  #| (canvas) => canvas.width

///|
pub extern "js" fn Canvas::pixel_height(self : Canvas) -> Int =
  #| (canvas) => canvas.height

///|
pub extern "js" fn Canvas::on_resize(
  self : Canvas,
  callback : () -> Unit,
) -> Unit =
  #| (_canvas, callback) => window.addEventListener("resize", callback)

///|
pub extern "js" fn start_animation_frame(callback : (Double) -> Unit) -> Unit =
  #| (callback) => {
  #|   const frame = (time) => {
  #|     callback(time)
  #|     requestAnimationFrame(frame)
  #|   }
  #|   requestAnimationFrame(frame)
  #| }

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
  xr_compatible : Bool,
) -> @js_async.Promise[Adapter] =
  #| (gpu, xrCompatible) => gpu.requestAdapter({ xrCompatible }).then((adapter) => {
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
pub extern "js" fn Device::create_shader_module(
  self : Device,
  code : String,
) -> ShaderModule =
  #| (device, code) => device.createShaderModule({ code })

///|
pub extern "js" fn Device::create_render_pipeline(
  self : Device,
  shader_module : ShaderModule,
  format : String,
) -> RenderPipeline =
  #| (device, shaderModule, format) => device.createRenderPipeline({
  #|   layout: "auto",
  #|   vertex: {
  #|     module: shaderModule,
  #|     entryPoint: "vs_main",
  #|   },
  #|   fragment: {
  #|     module: shaderModule,
  #|     entryPoint: "fs_main",
  #|     targets: [{ format }],
  #|   },
  #|   primitive: {
  #|     topology: "triangle-list",
  #|   },
  #| })

///|
pub extern "js" fn Device::create_mesh_render_pipeline(
  self : Device,
  shader_module : ShaderModule,
  format : String,
) -> RenderPipeline =
  #| (device, shaderModule, format) => device.createRenderPipeline({
  #|   layout: "auto",
  #|   vertex: {
  #|     module: shaderModule,
  #|     entryPoint: "vs_main",
  #|     buffers: [{
  #|       arrayStride: 24,
  #|       attributes: [
  #|         { shaderLocation: 0, offset: 0, format: "float32x3" },
  #|         { shaderLocation: 1, offset: 12, format: "float32x3" },
  #|       ],
  #|     }],
  #|   },
  #|   fragment: {
  #|     module: shaderModule,
  #|     entryPoint: "fs_main",
  #|     targets: [{ format }],
  #|   },
  #|   primitive: {
  #|     topology: "triangle-list",
  #|     cullMode: "back",
  #|   },
  #|   depthStencil: {
  #|     format: "depth24plus",
  #|     depthWriteEnabled: true,
  #|     depthCompare: "less",
  #|   },
  #| })

///|
pub extern "js" fn Device::create_vertex_buffer(
  self : Device,
  data : FixedArray[Double],
) -> GpuBuffer =
  #| (device, data) => {
  #|   const values = new Float32Array(data)
  #|   const buffer = device.createBuffer({
  #|     size: values.byteLength,
  #|     usage: GPUBufferUsage.VERTEX | GPUBufferUsage.COPY_DST,
  #|   })
  #|   device.queue.writeBuffer(buffer, 0, values)
  #|   return buffer
  #| }

///|
pub extern "js" fn Device::create_uniform_buffer(
  self : Device,
  size : Int,
) -> GpuBuffer =
  #| (device, size) => device.createBuffer({
  #|   size,
  #|   usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST,
  #| })

///|
pub extern "js" fn Device::write_buffer(
  self : Device,
  buffer : GpuBuffer,
  data : FixedArray[Double],
) -> Unit =
  #| (device, buffer, data) => device.queue.writeBuffer(buffer, 0, new Float32Array(data))

///|
pub extern "js" fn Device::create_bind_group(
  self : Device,
  pipeline : RenderPipeline,
  buffer : GpuBuffer,
) -> BindGroup =
  #| (device, pipeline, buffer) => device.createBindGroup({
  #|   layout: pipeline.getBindGroupLayout(0),
  #|   entries: [{ binding: 0, resource: { buffer } }],
  #| })

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
pub extern "js" fn Texture::destroy(self : Texture) -> Unit =
  #| (texture) => texture.destroy()

///|
pub extern "js" fn Device::create_depth_texture(
  self : Device,
  width : Int,
  height : Int,
) -> Texture =
  #| (device, width, height) => device.createTexture({
  #|   size: { width, height, depthOrArrayLayers: 1 },
  #|   format: "depth24plus",
  #|   usage: GPUTextureUsage.RENDER_ATTACHMENT,
  #| })

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
pub extern "js" fn CommandEncoder::begin_depth_pass(
  self : CommandEncoder,
  view : TextureView,
  depth_view : TextureView,
  red : Double,
  green : Double,
  blue : Double,
  alpha : Double,
) -> RenderPassEncoder =
  #| (encoder, view, depthView, red, green, blue, alpha) => encoder.beginRenderPass({
  #|   colorAttachments: [{
  #|     view,
  #|     clearValue: { r: red, g: green, b: blue, a: alpha },
  #|     loadOp: "clear",
  #|     storeOp: "store",
  #|   }],
  #|   depthStencilAttachment: {
  #|     view: depthView,
  #|     depthClearValue: 1,
  #|     depthLoadOp: "clear",
  #|     depthStoreOp: "store",
  #|   },
  #| })

///|
pub extern "js" fn RenderPassEncoder::end(self : RenderPassEncoder) -> Unit =
  #| (pass) => pass.end()

///|
pub extern "js" fn RenderPassEncoder::set_pipeline(
  self : RenderPassEncoder,
  pipeline : RenderPipeline,
) -> Unit =
  #| (pass, pipeline) => pass.setPipeline(pipeline)

///|
pub extern "js" fn RenderPassEncoder::set_bind_group(
  self : RenderPassEncoder,
  index : Int,
  bind_group : BindGroup,
) -> Unit =
  #| (pass, index, bindGroup) => pass.setBindGroup(index, bindGroup)

///|
pub extern "js" fn RenderPassEncoder::set_vertex_buffer(
  self : RenderPassEncoder,
  slot : Int,
  buffer : GpuBuffer,
) -> Unit =
  #| (pass, slot, buffer) => pass.setVertexBuffer(slot, buffer)

///|
pub extern "js" fn RenderPassEncoder::draw(
  self : RenderPassEncoder,
  vertex_count : Int,
) -> Unit =
  #| (pass, vertexCount) => pass.draw(vertexCount)

///|
pub extern "js" fn RenderPassEncoder::set_viewport(
  self : RenderPassEncoder,
  x : Double,
  y : Double,
  width : Double,
  height : Double,
) -> Unit =
  #| (pass, x, y, width, height) => pass.setViewport(x, y, width, height, 0, 1)

///|
pub extern "js" fn CommandEncoder::finish(
  self : CommandEncoder,
) -> CommandBuffer =
  #| (encoder) => encoder.finish()
