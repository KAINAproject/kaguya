export const webgpuImports = {
  device_create_command_encoder(device: GPUDevice): GPUCommandEncoder {
    return device.createCommandEncoder()
  },

  device_queue_submit(device: GPUDevice, commandBuffer: GPUCommandBuffer): void {
    device.queue.submit([commandBuffer])
  },

  context_get_current_texture(context: GPUCanvasContext): GPUTexture {
    return context.getCurrentTexture()
  },

  texture_create_view(texture: GPUTexture): GPUTextureView {
    return texture.createView()
  },

  command_encoder_begin_clear_pass(
    encoder: GPUCommandEncoder,
    view: GPUTextureView,
    red: number,
    green: number,
    blue: number,
    alpha: number,
  ): GPURenderPassEncoder {
    return encoder.beginRenderPass({
      colorAttachments: [
        {
          view,
          clearValue: { r: red, g: green, b: blue, a: alpha },
          loadOp: "clear",
          storeOp: "store",
        },
      ],
    })
  },

  render_pass_end(pass: GPURenderPassEncoder): void {
    pass.end()
  },

  command_encoder_finish(encoder: GPUCommandEncoder): GPUCommandBuffer {
    return encoder.finish()
  },
}
