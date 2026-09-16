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
  #|   const uiVertexShader = compileShader(gl.VERTEX_SHADER, `
  #|     attribute vec3 a_position;
  #|     attribute vec2 a_uv;
  #|     uniform mat4 u_mvp;
  #|     varying vec2 v_uv;
  #|     void main() {
  #|       gl_Position = u_mvp * vec4(a_position, 1.0);
  #|       v_uv = a_uv;
  #|     }
  #|   `)
  #|   const uiFragmentShader = compileShader(gl.FRAGMENT_SHADER, `
  #|     precision mediump float;
  #|     uniform sampler2D u_texture;
  #|     varying vec2 v_uv;
  #|     void main() {
  #|       gl_FragColor = texture2D(u_texture, v_uv);
  #|     }
  #|   `)
  #|   const uiProgram = gl.createProgram()
  #|   gl.attachShader(uiProgram, uiVertexShader)
  #|   gl.attachShader(uiProgram, uiFragmentShader)
  #|   gl.linkProgram(uiProgram)
  #|   if (!gl.getProgramParameter(uiProgram, gl.LINK_STATUS)) {
  #|     throw new Error(`WebGL spatial UI program linking failed: ${gl.getProgramInfoLog(uiProgram)}`)
  #|   }
  #|   const uiCanvas = document.createElement("canvas")
  #|   uiCanvas.width = 512
  #|   uiCanvas.height = 256
  #|   const uiContext = uiCanvas.getContext("2d")
  #|   if (!uiContext) throw new Error("Spatial UI の 2D canvas を取得できませんでした")
  #|   const drawPanel = (state, controller, label, detail) => {
  #|     const colors = {
  #|       initializing: "#64748b",
  #|       starting: "#8b9cff",
  #|       ready: "#6ee7b7",
  #|       hover: "#8b9cff",
  #|       selected: "#fbbf24",
  #|       grabbed: "#34d399",
  #|       released: "#fbbf24",
  #|       "no-controller": "#fb923c",
  #|       error: "#fb7185",
  #|     }
  #|     const stateCodes = {
  #|       initializing: "INITIALIZING",
  #|       starting: "STARTING",
  #|       ready: "READY",
  #|       hover: "HOVER",
  #|       selected: "SELECTED",
  #|       grabbed: "GRABBED",
  #|       released: "RELEASED",
  #|       "no-controller": "NO CONTROLLER",
  #|       error: "ERROR",
  #|     }
  #|     const controllerLabel = controller === "left"
  #|       ? "LEFT"
  #|       : controller === "right" ? "RIGHT" : "—"
  #|     uiContext.clearRect(0, 0, uiCanvas.width, uiCanvas.height)
  #|     uiContext.fillStyle = "#101827"
  #|     uiContext.fillRect(0, 0, uiCanvas.width, uiCanvas.height)
  #|     uiContext.fillStyle = colors[state] || "#64748b"
  #|     uiContext.fillRect(0, 0, 18, uiCanvas.height)
  #|     uiContext.fillStyle = "#94a3b8"
  #|     uiContext.font = "700 22px sans-serif"
  #|     uiContext.fillText("XR STATUS", 42, 38)
  #|     uiContext.fillStyle = "#f8fafc"
  #|     uiContext.font = "700 42px sans-serif"
  #|     uiContext.fillText(stateCodes[state] || "UNKNOWN", 42, 100)
  #|     uiContext.fillStyle = "#cbd5e1"
  #|     uiContext.font = "22px sans-serif"
  #|     uiContext.fillText(label, 42, 142, 438)
  #|     uiContext.fillStyle = "#94a3b8"
  #|     uiContext.font = "20px sans-serif"
  #|     uiContext.fillText(`CONTROLLER: ${controllerLabel}`, 42, 196)
  #|     uiContext.fillStyle = "#64748b"
  #|     uiContext.font = "16px sans-serif"
  #|     uiContext.fillText(detail, 42, 230, 438)
  #|   }
  #|   const stateKey = (state, controller, label, detail) =>
  #|     `${state}|${controller}|${label}|${detail}`
  #|   const initialState = globalThis.__kaguyaSpatialUiState || {
  #|     state: "initializing",
  #|     controller: "none",
  #|     label: "準備中",
  #|     detail: "XR セッションを確認しています…",
  #|   }
  #|   drawPanel(
  #|     initialState.state,
  #|     initialState.controller,
  #|     initialState.label,
  #|     initialState.detail,
  #|   )
  #|   const uiBuffer = gl.createBuffer()
  #|   gl.bindBuffer(gl.ARRAY_BUFFER, uiBuffer)
  #|   gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([
  #|     -1, 1, 0, 0, 0,
  #|     1, 1, 0, 1, 0,
  #|     -1, -1, 0, 0, 1,
  #|     -1, -1, 0, 0, 1,
  #|     1, 1, 0, 1, 0,
  #|     1, -1, 0, 1, 1,
  #|   ]), gl.STATIC_DRAW)
  #|   const uiTexture = gl.createTexture()
  #|   gl.bindTexture(gl.TEXTURE_2D, uiTexture)
  #|   gl.pixelStorei(gl.UNPACK_FLIP_Y_WEBGL, false)
  #|   gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR)
  #|   gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR)
  #|   gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE)
  #|   gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE)
  #|   gl.texImage2D(
  #|     gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, uiCanvas,
  #|   )
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
  #|     uiProgram,
  #|     uiCanvas,
  #|     uiContext,
  #|     uiBuffer,
  #|     uiTexture,
  #|     uiPosition: gl.getAttribLocation(uiProgram, "a_position"),
  #|     uiUv: gl.getAttribLocation(uiProgram, "a_uv"),
  #|     uiMvp: gl.getUniformLocation(uiProgram, "u_mvp"),
  #|     uiSampler: gl.getUniformLocation(uiProgram, "u_texture"),
  #|     drawPanel,
  #|     stateKey,
  #|     uiStateKey: stateKey(
  #|       initialState.state,
  #|       initialState.controller,
  #|       initialState.label,
  #|       initialState.detail,
  #|     ),
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
  pressed : Bool,
  clear : Bool,
) -> Unit =
  #| (renderer, layer, view, mvp, pressed, clear) => {
  #|   const { gl, program, buffer, position, color, mvp: mvpLocation } = renderer
  #|   const viewport = layer.getViewport(view)
  #|   gl.bindFramebuffer(gl.FRAMEBUFFER, layer.framebuffer)
  #|   gl.enable(gl.SCISSOR_TEST)
  #|   gl.scissor(viewport.x, viewport.y, viewport.width, viewport.height)
  #|   gl.viewport(viewport.x, viewport.y, viewport.width, viewport.height)
  #|   if (clear) {
  #|     if (pressed) {
  #|       gl.clearColor(0.65, 0.12, 0.08, 1.0)
  #|     } else {
  #|       gl.clearColor(0.05, 0.08, 0.16, 1.0)
  #|     }
  #|     gl.clear(gl.COLOR_BUFFER_BIT)
  #|   }
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

///|
pub extern "js" fn WebGLXRRenderer::draw_spatial_ui(
  self : WebGLXRRenderer,
  layer : XRWebGLLayer,
  view : XRView,
  mvp : FixedArray[Double],
) -> Unit =
  #| (renderer, layer, view, mvp) => {
  #|   const { gl, uiProgram, uiBuffer, uiPosition, uiUv, uiMvp, uiSampler, uiTexture } = renderer
  #|   const state = globalThis.__kaguyaSpatialUiState
  #|   if (state) {
  #|     const key = renderer.stateKey(
  #|       state.state,
  #|       state.controller,
  #|       state.label,
  #|       state.detail,
  #|     )
  #|     if (renderer.uiStateKey !== key) {
  #|       renderer.drawPanel(state.state, state.controller, state.label, state.detail)
  #|       gl.bindTexture(gl.TEXTURE_2D, uiTexture)
  #|       gl.texImage2D(
  #|         gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, renderer.uiCanvas,
  #|       )
  #|       renderer.uiStateKey = key
  #|     }
  #|   }
  #|   const viewport = layer.getViewport(view)
  #|   gl.bindFramebuffer(gl.FRAMEBUFFER, layer.framebuffer)
  #|   gl.enable(gl.SCISSOR_TEST)
  #|   gl.scissor(viewport.x, viewport.y, viewport.width, viewport.height)
  #|   gl.viewport(viewport.x, viewport.y, viewport.width, viewport.height)
  #|   gl.disable(gl.DEPTH_TEST)
  #|   gl.disable(gl.CULL_FACE)
  #|   gl.useProgram(uiProgram)
  #|   gl.bindBuffer(gl.ARRAY_BUFFER, uiBuffer)
  #|   gl.enableVertexAttribArray(uiPosition)
  #|   gl.vertexAttribPointer(uiPosition, 3, gl.FLOAT, false, 20, 0)
  #|   gl.enableVertexAttribArray(uiUv)
  #|   gl.vertexAttribPointer(uiUv, 2, gl.FLOAT, false, 20, 12)
  #|   gl.uniformMatrix4fv(uiMvp, false, new Float32Array(mvp))
  #|   gl.activeTexture(gl.TEXTURE0)
  #|   gl.bindTexture(gl.TEXTURE_2D, uiTexture)
  #|   gl.uniform1i(uiSampler, 0)
  #|   gl.drawArrays(gl.TRIANGLES, 0, 6)
  #| }
