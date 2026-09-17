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
#external
pub type XRInputSource

///|
/// WebXR session mode identifiers.
pub const IMMERSIVE_VR : String = "immersive-vr"

///|
pub const IMMERSIVE_AR : String = "immersive-ar"

///|
/// Common WebXR feature identifiers.
pub const LOCAL_FLOOR : String = "local-floor"

///|
pub const HAND_TRACKING : String = "hand-tracking"

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
  is_session_supported_for(IMMERSIVE_VR)
}

///|
/// Check whether the runtime supports a specific WebXR session mode.
pub fn is_session_supported_for(mode : String) -> @js_async.Promise[Bool] {
  navigator_xr().is_session_supported(mode)
}

///|
/// Check immersive AR support without exposing the browser's XR system.
pub fn is_immersive_ar_session_supported() -> @js_async.Promise[Bool] {
  is_session_supported_for(IMMERSIVE_AR)
}

///|
pub extern "js" fn XRSystem::is_session_supported(
  self : XRSystem,
  mode : String,
) -> @js_async.Promise[Bool] =
  #| (xr, mode) => xr.isSessionSupported(mode)

///|
/// Request a WebXR session with explicit required and optional features.
pub extern "js" fn XRSystem::request_session(
  self : XRSystem,
  mode : String,
  required_features : FixedArray[String],
  optional_features : FixedArray[String],
) -> @js_async.Promise[XRSession] =
  #| (xr, mode, requiredFeatures, optionalFeatures) => xr.requestSession(mode, {
  #|   requiredFeatures,
  #|   optionalFeatures,
  #| })

///|
/// Request a WebXR session through `navigator.xr`.
pub fn request_session(
  mode : String,
  required_features : FixedArray[String],
  optional_features : FixedArray[String],
) -> @js_async.Promise[XRSession] {
  navigator_xr().request_session(mode, required_features, optional_features)
}

///|
/// Backwards-compatible immersive VR request with optional floor and hand
/// tracking features.
pub extern "js" fn XRSystem::request_immersive_vr_session(
  self : XRSystem,
) -> @js_async.Promise[XRSession] =
  #| xr => xr.requestSession("immersive-vr", {
  #|   optionalFeatures: ["local-floor", "hand-tracking"],
  #| })

///|
/// Request an immersive VR session with floor-relative tracking and hand input
/// enabled when the runtime supports it.
pub fn request_immersive_vr_session() -> @js_async.Promise[XRSession] {
  navigator_xr().request_session(IMMERSIVE_VR, [], [LOCAL_FLOOR, HAND_TRACKING])
}

///|
/// Request an immersive AR session with the same optional tracking features as
/// the VR convenience function.
pub fn request_immersive_ar_session() -> @js_async.Promise[XRSession] {
  navigator_xr().request_session(IMMERSIVE_AR, [], [LOCAL_FLOOR, HAND_TRACKING])
}

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
  callback : (String, XRInputSource) -> Unit,
) -> @three_js.EventSubscription =
  #| (controller, callback) => {
  #|   const listener = event => callback(event.data?.handedness || "none", event.data)
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
/// Subscribe to connection events on a hand space returned by `get_hand`.
pub fn on_hand_connected(
  hand : @three_js.Group,
  callback : (String, XRInputSource) -> Unit,
) -> @three_js.EventSubscription {
  on_controller_connected(hand, callback)
}

///|
/// Subscribe to disconnection events on a hand space returned by `get_hand`.
pub fn on_hand_disconnected(
  hand : @three_js.Group,
  callback : () -> Unit,
) -> @three_js.EventSubscription {
  on_controller_disconnected(hand, callback)
}

///|
pub extern "js" fn on_select(
  controller : @three_js.Group,
  callback : (String) -> Unit,
) -> @three_js.EventSubscription =
  #| (controller, callback) => {
  #|   const listener = event => callback(event.data?.handedness || "none")
  #|   controller.addEventListener("select", listener)
  #|   return () => controller.removeEventListener("select", listener)
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
pub extern "js" fn on_squeeze_start(
  controller : @three_js.Group,
  callback : (String) -> Unit,
) -> @three_js.EventSubscription =
  #| (controller, callback) => {
  #|   const listener = event => callback(event.data?.handedness || "none")
  #|   controller.addEventListener("squeezestart", listener)
  #|   return () => controller.removeEventListener("squeezestart", listener)
  #| }

///|
pub extern "js" fn on_squeeze_end(
  controller : @three_js.Group,
  callback : (String) -> Unit,
) -> @three_js.EventSubscription =
  #| (controller, callback) => {
  #|   const listener = event => callback(event.data?.handedness || "none")
  #|   controller.addEventListener("squeezeend", listener)
  #|   return () => controller.removeEventListener("squeezeend", listener)
  #| }

///|
pub extern "js" fn on_squeeze(
  controller : @three_js.Group,
  callback : (String) -> Unit,
) -> @three_js.EventSubscription =
  #| (controller, callback) => {
  #|   const listener = event => callback(event.data?.handedness || "none")
  #|   controller.addEventListener("squeeze", listener)
  #|   return () => controller.removeEventListener("squeeze", listener)
  #| }

///|
/// Subscribe to Three.js' pinch gesture events on a hand space.
pub extern "js" fn on_pinch_start(
  hand : @three_js.Group,
  callback : (String) -> Unit,
) -> @three_js.EventSubscription =
  #| (hand, callback) => {
  #|   const listener = event => callback(event.handedness || "none")
  #|   hand.addEventListener("pinchstart", listener)
  #|   return () => hand.removeEventListener("pinchstart", listener)
  #| }

///|
pub extern "js" fn on_pinch_end(
  hand : @three_js.Group,
  callback : (String) -> Unit,
) -> @three_js.EventSubscription =
  #| (hand, callback) => {
  #|   const listener = event => callback(event.handedness || "none")
  #|   hand.addEventListener("pinchend", listener)
  #|   return () => hand.removeEventListener("pinchend", listener)
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
