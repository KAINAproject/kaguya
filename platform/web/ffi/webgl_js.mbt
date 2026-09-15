// WebGL bindings used by the WebXR fallback path.

///|
#external
pub type WebGLContext

///|
#external
pub type WebGLXRRenderer

///|
pub extern "js" fn create_webgl_xr_renderer(
  vertices : FixedArray[Double],
) -> WebGLXRRenderer =
  #| (vertices) => {
  #|   const canvas = document.querySelector("#xr-canvas")
  #|   if (!canvas) throw new Error("xr-canvas が見つかりません")
  #|   const contextAttributes = {
  #|     alpha: false,
  #|     antialias: false,
  #|     depth: false,
  #|     stencil: false,
  #|     xrCompatible: true,
  #|   }
  #|   // Quest Browser has a more reliable XRWebGLLayer path with WebGL 1.
  #|   const gl = canvas.getContext("webgl", contextAttributes) ||
  #|     canvas.getContext("webgl2", contextAttributes)
  #|   if (!gl) throw new Error("WebGL context を取得できませんでした")
  #|
  #|   const compileShader = (type, source) => {
  #|     const shader = gl.createShader(type)
  #|     gl.shaderSource(shader, source)
  #|     gl.compileShader(shader)
  #|     if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
  #|       throw new Error(`WebGL shader compilation failed: ${gl.getShaderInfoLog(shader)}`)
  #|     }
  #|     return shader
  #|   }
  #|
  #|   const vertexShader = compileShader(gl.VERTEX_SHADER, `
  #|     attribute vec3 a_position;
  #|     attribute vec3 a_color;
  #|     uniform mat4 u_mvp;
  #|     varying vec3 v_color;
  #|     void main() {
  #|       gl_Position = u_mvp * vec4(a_position, 1.0);
  #|       v_color = a_color;
  #|     }
  #|   `)
  #|   const fragmentShader = compileShader(gl.FRAGMENT_SHADER, `
  #|     precision mediump float;
  #|     varying vec3 v_color;
  #|     void main() {
  #|       gl_FragColor = vec4(v_color, 1.0);
  #|     }
  #|   `)
  #|   const program = gl.createProgram()
  #|   gl.attachShader(program, vertexShader)
  #|   gl.attachShader(program, fragmentShader)
  #|   gl.linkProgram(program)
  #|   if (!gl.getProgramParameter(program, gl.LINK_STATUS)) {
  #|     throw new Error(`WebGL program linking failed: ${gl.getProgramInfoLog(program)}`)
  #|   }
  #|
  #|   const buffer = gl.createBuffer()
  #|   gl.bindBuffer(gl.ARRAY_BUFFER, buffer)
  #|   gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW)
  #|   return {
  #|     gl,
  #|     program,
  #|     buffer,
  #|     position: gl.getAttribLocation(program, "a_position"),
  #|     color: gl.getAttribLocation(program, "a_color"),
  #|     mvp: gl.getUniformLocation(program, "u_mvp"),
  #|   }
  #| }

///|
pub extern "js" fn WebGLXRRenderer::context(
  self : WebGLXRRenderer,
) -> WebGLContext =
  #| (renderer) => renderer.gl

///|
pub extern "js" fn WebGLXRRenderer::draw_cube(
  self : WebGLXRRenderer,
  layer : XRWebGLLayer,
  view : XRView,
  mvp : FixedArray[Double],
) -> Unit =
  #| (renderer, layer, view, mvp) => {
  #|   const { gl, program, buffer, position, color, mvp: mvpLocation } = renderer
  #|   const viewport = layer.getViewport(view)
  #|   gl.bindFramebuffer(gl.FRAMEBUFFER, layer.framebuffer)
  #|   gl.enable(gl.SCISSOR_TEST)
  #|   gl.scissor(viewport.x, viewport.y, viewport.width, viewport.height)
  #|   gl.viewport(viewport.x, viewport.y, viewport.width, viewport.height)
  #|   gl.clearColor(0.05, 0.08, 0.16, 1.0)
  #|   gl.clear(gl.COLOR_BUFFER_BIT)
  #|   gl.disable(gl.DEPTH_TEST)
  #|   gl.enable(gl.CULL_FACE)
  #|   gl.cullFace(gl.BACK)
  #|   gl.useProgram(program)
  #|   gl.bindBuffer(gl.ARRAY_BUFFER, buffer)
  #|   gl.enableVertexAttribArray(position)
  #|   gl.vertexAttribPointer(position, 3, gl.FLOAT, false, 24, 0)
  #|   gl.enableVertexAttribArray(color)
  #|   gl.vertexAttribPointer(color, 3, gl.FLOAT, false, 24, 12)
  #|   gl.uniformMatrix4fv(mvpLocation, false, new Float32Array(mvp))
  #|   gl.drawArrays(gl.TRIANGLES, 0, 36)
  #| }
