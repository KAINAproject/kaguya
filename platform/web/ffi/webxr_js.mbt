///|
#external
pub type Button

///|
#external
pub type XRSystem

///|
#external
pub type XRSession

///|
#external
pub type XRReferenceSpace

///|
#external
pub type XRViewerPose

///|
#external
pub type XRView

///|
extern "js" fn document_xr_button() -> Button =
  #| () => {
  #|   const button = document.querySelector("#enter-xr")
  #|   if (!button) throw new Error("enter-xr button が見つかりません")
  #|   return button
  #| }

///|
pub extern "js" fn has_xr_button() -> Bool =
  #| () => document.querySelector("#enter-xr") != null

///|
pub fn xr_button() -> Button {
  document_xr_button()
}

///|
pub extern "js" fn Button::on_click(
  self : Button,
  callback : () -> Unit,
) -> Unit =
  #| (button, callback) => button.addEventListener("click", callback)

///|
pub extern "js" fn Button::set_enabled(self : Button, enabled : Bool) -> Unit =
  #| (button, enabled) => { button.disabled = !enabled }

///|
pub extern "js" fn Button::set_label(self : Button, label : String) -> Unit =
  #| (button, label) => { button.textContent = label }

///|
pub extern "js" fn has_xr() -> Bool =
  #| () => typeof navigator !== "undefined" && "xr" in navigator && navigator.xr != null

///|
extern "js" fn navigator_xr() -> XRSystem =
  #| () => {
  #|   if (!navigator.xr) throw new Error("このブラウザでは WebXR が利用できません")
  #|   return navigator.xr
  #| }

///|
pub fn xr() -> XRSystem {
  navigator_xr()
}

///|
pub extern "js" fn XRSystem::is_session_supported(
  self : XRSystem,
  mode : String,
) -> @js_async.Promise[Bool] =
  #| (xr, mode) => xr.isSessionSupported(mode)

///|
pub extern "js" fn XRSystem::request_immersive_vr_session(
  self : XRSystem,
) -> @js_async.Promise[XRSession] =
  #| (xr) => xr.requestSession("immersive-vr", {
  #|   optionalFeatures: ["local-floor"],
  #| })

///|
pub extern "js" fn XRSession::request_reference_space(
  self : XRSession,
) -> @js_async.Promise[XRReferenceSpace] =
  #| (session) => session.requestReferenceSpace("local-floor").catch(() => {
  #|   return session.requestReferenceSpace("local")
  #| })

///|
pub extern "js" fn XRSession::on_end(
  self : XRSession,
  callback : () -> Unit,
) -> Unit =
  #| (session, callback) => session.addEventListener("end", callback, { once: true })

///|
pub extern "js" fn XRSession::request_animation_frame(
  self : XRSession,
  reference_space : XRReferenceSpace,
  callback : (Double, XRViewerPose) -> Unit,
) -> Unit =
  #| (session, referenceSpace, callback) => {
  #|   let active = true
  #|   session.addEventListener("end", () => { active = false }, { once: true })
  #|   const frame = (time, xrFrame) => {
  #|     if (!active) return
  #|     const pose = xrFrame.getViewerPose(referenceSpace)
  #|     if (pose) callback(time, pose)
  #|     if (active) session.requestAnimationFrame(frame)
  #|   }
  #|   session.requestAnimationFrame(frame)
  #| }

///|
pub extern "js" fn XRViewerPose::view_count(self : XRViewerPose) -> Int =
  #| (pose) => pose.views.length

///|
pub extern "js" fn XRViewerPose::view(
  self : XRViewerPose,
  index : Int,
) -> XRView =
  #| (pose, index) => pose.views[index]

///|
pub extern "js" fn XRView::eye(self : XRView) -> String =
  #| (view) => view.eye

///|
pub extern "js" fn XRView::projection_value(
  self : XRView,
  index : Int,
) -> Double =
  #| (view, index) => view.projectionMatrix[index]

///|
pub extern "js" fn XRView::view_value(self : XRView, index : Int) -> Double =
  #| (view, index) => view.transform.inverse.matrix[index]
