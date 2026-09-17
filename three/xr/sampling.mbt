///|
/// A pose sampled from the current WebXR frame or a Three.js XR space.
#external
pub type Pose

///|
/// The controller input state exposed by the WebXR gamepad module.
#external
pub type InputState

///|
/// The hand joint state maintained by Three.js for the current XR frame.
#external
pub type HandSample

///|
extern "js" fn WebXRManager::ffi_current_head_pose(
  self : WebXRManager,
) -> Pose? =
  #| manager => {
  #|   const frame = manager.getFrame()
  #|   const referenceSpace = manager.getReferenceSpace()
  #|   if (!frame || !referenceSpace) return null
  #|   const viewerPose = frame.getViewerPose(referenceSpace)
  #|   if (!viewerPose) return null
  #|   const transform = viewerPose.transform
  #|   return {
  #|     position: {
  #|       x: transform.position.x,
  #|       y: transform.position.y,
  #|       z: transform.position.z,
  #|     },
  #|     orientation: {
  #|       x: transform.orientation.x,
  #|       y: transform.orientation.y,
  #|       z: transform.orientation.z,
  #|       w: transform.orientation.w,
  #|     },
  #|   }
  #| }

///|
/// Returns the viewer pose from the XR frame currently being processed by Three.js.
pub fn WebXRManager::current_head_pose(self : WebXRManager) -> Pose? {
  self.ffi_current_head_pose()
}

///|
extern "js" fn ffi_pose_from_object(object : @three_js.Object3D) -> Pose? =
  #| object => {
  #|   if (!object.visible) return null
  #|   object.updateWorldMatrix(true, false)
  #|   const position = object.getWorldPosition(object.position.clone())
  #|   const orientation = object.getWorldQuaternion(object.quaternion.clone())
  #|   return {
  #|     position: { x: position.x, y: position.y, z: position.z },
  #|     orientation: {
  #|       x: orientation.x,
  #|       y: orientation.y,
  #|       z: orientation.z,
  #|       w: orientation.w,
  #|     },
  #|   }
  #| }

///|
/// Returns the current world pose of an XR space represented by a Three.js object.
pub fn pose_from_object(object : @three_js.Object3D) -> Pose? {
  ffi_pose_from_object(object)
}

///|
pub extern "js" fn Pose::position_x(self : Pose) -> Float =
  #| pose => pose.position.x

///|
pub extern "js" fn Pose::position_y(self : Pose) -> Float =
  #| pose => pose.position.y

///|
pub extern "js" fn Pose::position_z(self : Pose) -> Float =
  #| pose => pose.position.z

///|
pub extern "js" fn Pose::orientation_x(self : Pose) -> Float =
  #| pose => pose.orientation.x

///|
pub extern "js" fn Pose::orientation_y(self : Pose) -> Float =
  #| pose => pose.orientation.y

///|
pub extern "js" fn Pose::orientation_z(self : Pose) -> Float =
  #| pose => pose.orientation.z

///|
pub extern "js" fn Pose::orientation_w(self : Pose) -> Float =
  #| pose => pose.orientation.w

///|
extern "js" fn XRInputSource::ffi_input_state(
  self : XRInputSource,
) -> InputState? =
  #| inputSource => {
  #|   const gamepad = inputSource?.gamepad
  #|   if (!gamepad) return null
  #|   const button = index => gamepad.buttons?.[index]
  #|   const axis = index => gamepad.axes?.[index] ?? 0
  #|   return {
  #|     primary_click: button(0)?.pressed === true,
  #|     secondary_click: false,
  #|     thumbstick_click: button(3)?.pressed === true,
  #|     menu_click: false,
  #|     thumbstick_x: axis(2),
  #|     thumbstick_y: axis(3),
  #|     squeeze_value: button(1)?.value ?? 0,
  #|     trigger_value: button(0)?.value ?? 0,
  #|   }
  #| }

///|
extern "js" fn XRInputSource::ffi_has_hand(self : XRInputSource) -> Bool =
  #| inputSource => inputSource?.hand != null

///|
pub fn XRInputSource::input_state(self : XRInputSource) -> InputState? {
  self.ffi_input_state()
}

///|
/// Returns whether this source is an articulated hand input source.
pub fn XRInputSource::has_hand(self : XRInputSource) -> Bool {
  self.ffi_has_hand()
}

///|
pub extern "js" fn InputState::primary_click(self : InputState) -> Bool =
  #| state => state.primary_click

///|
pub extern "js" fn InputState::secondary_click(self : InputState) -> Bool =
  #| state => state.secondary_click

///|
pub extern "js" fn InputState::thumbstick_click(self : InputState) -> Bool =
  #| state => state.thumbstick_click

///|
pub extern "js" fn InputState::menu_click(self : InputState) -> Bool =
  #| state => state.menu_click

///|
pub extern "js" fn InputState::thumbstick_x(self : InputState) -> Float =
  #| state => state.thumbstick_x

///|
pub extern "js" fn InputState::thumbstick_y(self : InputState) -> Float =
  #| state => state.thumbstick_y

///|
pub extern "js" fn InputState::squeeze_value(self : InputState) -> Float =
  #| state => state.squeeze_value

///|
pub extern "js" fn InputState::trigger_value(self : InputState) -> Float =
  #| state => state.trigger_value

///|
extern "js" fn ffi_hand_sample(hand : @three_js.Group) -> HandSample? =
  #| hand => {
  #|   if (!hand.visible || !hand.joints) return null
  #|   const names = [
  #|     "palm",
  #|     "wrist",
  #|     "thumb-metacarpal",
  #|     "thumb-phalanx-proximal",
  #|     "thumb-phalanx-distal",
  #|     "thumb-tip",
  #|     "index-finger-metacarpal",
  #|     "index-finger-phalanx-proximal",
  #|     "index-finger-phalanx-intermediate",
  #|     "index-finger-phalanx-distal",
  #|     "index-finger-tip",
  #|     "middle-finger-metacarpal",
  #|     "middle-finger-phalanx-proximal",
  #|     "middle-finger-phalanx-intermediate",
  #|     "middle-finger-phalanx-distal",
  #|     "middle-finger-tip",
  #|     "ring-finger-metacarpal",
  #|     "ring-finger-phalanx-proximal",
  #|     "ring-finger-phalanx-intermediate",
  #|     "ring-finger-phalanx-distal",
  #|     "ring-finger-tip",
  #|     "pinky-finger-metacarpal",
  #|     "pinky-finger-phalanx-proximal",
  #|     "pinky-finger-phalanx-intermediate",
  #|     "pinky-finger-phalanx-distal",
  #|     "pinky-finger-tip",
  #|   ]
  #|   const joints = names.map(name => {
  #|     const joint = hand.joints[name]
  #|     if (!joint || !joint.visible) return null
  #|     joint.updateWorldMatrix(true, false)
  #|     const position = joint.getWorldPosition(joint.position.clone())
  #|     const orientation = joint.getWorldQuaternion(joint.quaternion.clone())
  #|     return {
  #|       pose: {
  #|         position: { x: position.x, y: position.y, z: position.z },
  #|         orientation: {
  #|           x: orientation.x,
  #|           y: orientation.y,
  #|           z: orientation.z,
  #|           w: orientation.w,
  #|         },
  #|       },
  #|       radius: joint.jointRadius ?? 0,
  #|     }
  #|   })
  #|   if (!joints.some(joint => joint !== null)) return null
  #|   return { joints }
  #| }

///|
/// Returns the currently tracked hand joints in the protocol's joint order.
pub fn hand_sample(hand : @three_js.Group) -> HandSample? {
  ffi_hand_sample(hand)
}

///|
extern "js" fn HandSample::ffi_joint_pose(
  self : HandSample,
  index : Int,
) -> Pose? =
  #| (sample, index) => sample.joints?.[index]?.pose ?? null

///|
pub fn HandSample::joint_pose(self : HandSample, index : Int) -> Pose? {
  self.ffi_joint_pose(index)
}

///|
pub extern "js" fn HandSample::joint_radius(
  self : HandSample,
  index : Int,
) -> Float =
  #| (sample, index) => sample.joints?.[index]?.radius ?? 0

///|
pub extern "js" fn frame_time_to_source_time_ns(time : Double) -> UInt64 =
  #| time => BigInt(Math.max(0, Math.round(time * 1000000)))

///|
pub extern "js" fn frame_time_to_sample_time_ns(time : Double) -> Int64 =
  #| time => BigInt(Math.max(0, Math.round(time * 1000000)))
