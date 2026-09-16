///|
#external
pub type XRSystem

///|
#external
pub type XRSession

///|
#external
pub type WebXRManager

///|
extern "js" fn navigator_xr() -> XRSystem =
  #| () => {
  #|   if (!navigator.xr) throw new Error("このブラウザでは WebXR が利用できません")
  #|   return navigator.xr
  #| }

///|
pub extern "js" fn is_available() -> Bool =
  #| () => typeof navigator !== "undefined" && navigator.xr != null

///|
pub fn is_session_supported() -> @js_async.Promise[Bool] {
  navigator_xr().is_session_supported("immersive-vr")
}

///|
pub extern "js" fn XRSystem::is_session_supported(
  self : XRSystem,
  mode : String,
) -> @js_async.Promise[Bool] =
  #| (xr, mode) => xr.isSessionSupported(mode)

///|
pub fn request_immersive_vr_session() -> @js_async.Promise[XRSession] {
  navigator_xr().request_immersive_vr_session()
}

///|
pub extern "js" fn XRSystem::request_immersive_vr_session(
  self : XRSystem,
) -> @js_async.Promise[XRSession] =
  #| (xr) => xr.requestSession("immersive-vr", {
  #|   optionalFeatures: ["local-floor"],
  #| })

///|
pub extern "js" fn manager(renderer : @three_js.WebGLRenderer) -> WebXRManager =
  #| renderer => renderer.xr

///|
pub extern "js" fn WebXRManager::set_enabled(
  self : WebXRManager,
  enabled : Bool,
) -> Unit =
  #| (manager, enabled) => { manager.enabled = enabled }

///|
pub extern "js" fn WebXRManager::set_reference_space_type(
  self : WebXRManager,
  reference_space_type : String,
) -> Unit =
  #| (manager, referenceSpaceType) => manager.setReferenceSpaceType(referenceSpaceType)

///|
pub extern "js" fn WebXRManager::set_session(
  self : WebXRManager,
  session : XRSession,
) -> @js_async.Promise[Unit] =
  #| (manager, session) => manager.setSession(session)

///|
pub extern "js" fn WebXRManager::is_presenting(self : WebXRManager) -> Bool =
  #| manager => manager.isPresenting

///|
pub extern "js" fn WebXRManager::get_controller(
  self : WebXRManager,
  index : Int,
) -> @three_js.Group =
  #| (manager, index) => manager.getController(index)

///|
pub extern "js" fn WebXRManager::get_controller_grip(
  self : WebXRManager,
  index : Int,
) -> @three_js.Group =
  #| (manager, index) => manager.getControllerGrip(index)

///|
pub extern "js" fn WebXRManager::get_hand(
  self : WebXRManager,
  index : Int,
) -> @three_js.Group =
  #| (manager, index) => manager.getHand(index)

///|
pub extern "js" fn WebXRManager::on_session_end(
  self : WebXRManager,
  callback : () -> Unit,
) -> @three_js.EventSubscription =
  #| (manager, callback) => {
  #|   const listener = () => callback()
  #|   manager.addEventListener("sessionend", listener)
  #|   return () => manager.removeEventListener("sessionend", listener)
  #| }

///|
pub extern "js" fn on_controller_connected(
  controller : @three_js.Group,
  callback : (String) -> Unit,
) -> @three_js.EventSubscription =
  #| (controller, callback) => {
  #|   const listener = event => callback(event.data?.handedness || "none")
  #|   controller.addEventListener("connected", listener)
  #|   return () => controller.removeEventListener("connected", listener)
  #| }

///|
pub extern "js" fn on_controller_disconnected(
  controller : @three_js.Group,
  callback : () -> Unit,
) -> @three_js.EventSubscription =
  #| (controller, callback) => {
  #|   const listener = () => callback()
  #|   controller.addEventListener("disconnected", listener)
  #|   return () => controller.removeEventListener("disconnected", listener)
  #| }

///|
pub extern "js" fn on_select_start(
  controller : @three_js.Group,
  callback : (String) -> Unit,
) -> @three_js.EventSubscription =
  #| (controller, callback) => {
  #|   const listener = event => callback(event.data?.handedness || "none")
  #|   controller.addEventListener("selectstart", listener)
  #|   return () => controller.removeEventListener("selectstart", listener)
  #| }

///|
pub extern "js" fn on_select_end(
  controller : @three_js.Group,
  callback : (String) -> Unit,
) -> @three_js.EventSubscription =
  #| (controller, callback) => {
  #|   const listener = event => callback(event.data?.handedness || "none")
  #|   controller.addEventListener("selectend", listener)
  #|   return () => controller.removeEventListener("selectend", listener)
  #| }
