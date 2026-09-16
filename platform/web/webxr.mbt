///|
fn update_interaction(
  interaction : InteractionElement,
  state : String,
  controller : String,
  label : String,
  detail : String,
) -> Unit {
  interaction.set_state(state, controller, label, detail)
}

///|
async fn enter_xr(
  button : Button,
  manager : @xr_three.WebXRManager,
  status : StatusElement,
) -> Unit {
  button.set_enabled(false)
  button.set_label("VR セッションを開始しています…")
  try {
    let session = @xr_three.request_immersive_vr_session().wait()
    manager.set_session(session).wait()
    status.set_message(
      "WebXR session active (three.js WebGLRenderer)", "success",
    )
  } catch {
    error => {
      button.set_label("VR を開始")
      button.set_enabled(true)
      status.set_message(error.to_string(), "error")
    }
  } noraise {
    _ => ()
  }
}

///|
async fn initialize() -> Unit {
  let button = enter_button()
  let status = status_element()
  let interaction = interaction_element()
  let canvas = match @three.Canvas::from_id("canvas") {
    Some(canvas) => canvas
    None => {
      button.set_label("Canvas が見つかりません")
      status.set_message("Canvas が見つかりません", "error")
      return
    }
  }
  let width = canvas_size(canvas)
  let renderer = @three.WebGLRenderer::with_canvas(
    canvas,
    antialias=false,
    alpha=false,
  )
  renderer.set_size(width, width * 9 / 16, update_style=false)
  renderer.set_clear_color(@three.Color::from_hex(0x0D1428), 1.0)

  let scene = @three.Scene::Scene()
  let camera = @three.PerspectiveCamera::PerspectiveCamera(
    60.0,
    16.0 / 9.0,
    0.1,
    100.0,
  )
  camera.set_position_xyz(0.0, 0.0, 4.0)
  let cube = @three.Mesh::Mesh(
    @three.BoxGeometry::BoxGeometry(1.0, 1.0, 1.0).as_buffer_geometry(),
    @three.MeshBasicMaterial::MeshBasicMaterial(0x8B9CFF).as_material(),
  )
  cube.set_position_xyz(0.0, 0.0, -2.0)
  let cube_object = cube.as_object3d()
  scene.add_child(cube_object)

  let manager = @xr_three.manager(renderer)
  manager.set_enabled(true)
  manager.set_reference_space_type("local-floor")
  let controller = manager.get_controller(0)
  let controller_object = controller.as_object3d()
  scene.add_child(controller_object)
  let controller_grip = manager.get_controller_grip(0)
  scene.add_child(controller_grip.as_object3d())
  let controller_marker = @three.Mesh::Mesh(
    @three.BoxGeometry::BoxGeometry(0.12, 0.12, 0.12).as_buffer_geometry(),
    @three.MeshBasicMaterial::MeshBasicMaterial(0x6EE7B7).as_material(),
  )
  controller_marker.as_object3d().add_to(controller_grip.as_object3d())

  let mut active_controller = "none"
  let set_state = fn(state, controller_name, label, detail) {
    active_controller = controller_name
    update_interaction(interaction, state, controller_name, label, detail)
  }
  let mut is_targeting = false
  let mut is_grabbed = false
  let ray_origin = @three.Vector3::Vector3(0.0, 0.0, 0.0)
  let ray_direction = @three.Vector3::Vector3(0.0, 0.0, -1.0)
  let raycaster = @three.Raycaster::Raycaster(ray_origin, ray_direction)
  ignore(
    @xr_three.on_controller_connected(controller, fn(handedness) {
      set_state(
        "hover", handedness, "Cube を狙い中", "select で Cube を掴めます",
      )
      status.set_message("XR controller connected: {handedness}", "success")
    }),
  )
  ignore(
    @xr_three.on_controller_disconnected(controller, fn() {
      set_state(
        "no-controller", "none", "コントローラー待ち", "XR コントローラーを接続してください",
      )
    }),
  )
  ignore(
    @xr_three.on_select_start(controller, fn(handedness) {
      if is_targeting {
        is_grabbed = true
        cube.set_uniform_scale(1.2)
        set_state(
          "grabbed", handedness, "掴んで操作中", "select を離すと Cube を配置します",
        )
        status.set_message("XR selectstart ({handedness})", "success")
      } else {
        status.set_message(
          "XR selectstart ({handedness}) — Cube の方向を確認してください",
          "info",
        )
      }
    }),
  )
  ignore(
    @xr_three.on_select_end(controller, fn(handedness) {
      if is_grabbed {
        is_grabbed = false
        cube.set_uniform_scale(1.0)
        set_state(
          "released", handedness, "配置完了", "Cube を配置しました",
        )
        status.set_message("XR selectend ({handedness})", "success")
      }
    }),
  )
  ignore(
    manager.on_session_end(fn() {
      button.set_label("VR を開始")
      button.set_enabled(true)
      set_state(
        "ready", active_controller, "操作待機", "VR を開始すると Cube を操作できます",
      )
      status.set_message("WebXR session ended", "info")
    }),
  )

  renderer.set_animation_loop(fn(time) {
    cube.set_rotation_xyz(0.0, time / 2000.0, 0.0)
    if manager.is_presenting() {
      controller_object.update_world_matrix(true, true)
      cube_object.update_matrix_world(true)
      ignore(controller_object.get_world_position(ray_origin))
      ignore(controller_object.get_world_direction(ray_direction).negate())
      raycaster.set(ray_origin, ray_direction)
      let targeting = raycaster.intersect_object(cube_object, false).length() >
        0
      if targeting != is_targeting {
        is_targeting = targeting
        if !is_grabbed {
          if targeting {
            set_state(
              "hover", active_controller, "Cube を狙い中", "select で Cube を掴めます",
            )
          } else {
            set_state(
              "ready", active_controller, "操作待機", "コントローラーを Cube に向けてください",
            )
          }
        }
      }
    } else if is_targeting {
      is_targeting = false
    }
    renderer.render(scene, camera.as_camera())
  })
  set_state(
    "ready", "none", "準備完了", "VR を開始すると Cube を操作できます",
  )
  if !@xr_three.is_available() {
    button.set_label("WebXR は利用できません")
    status.set_message("WebXR は利用できません", "error")
    return
  }
  try {
    let supported = @xr_three.is_session_supported().wait()
    if supported {
      button.set_label("VR を開始")
      button.set_enabled(true)
      button.on_click(fn() {
        ignore(
          @js_async.Promise::from_async(() => enter_xr(button, manager, status)),
        )
      })
      status.set_message("three.js WebGLRenderer initialized", "success")
    } else {
      button.set_label("VR は利用できません")
      status.set_message("immersive-vr は利用できません", "error")
    }
  } catch {
    error => {
      button.set_label("WebXR を確認できません")
      status.set_message(error.to_string(), "error")
    }
  } noraise {
    _ => ()
  }
}

///|
pub fn start() -> @js_async.Promise[Unit] {
  @js_async.Promise::from_async(initialize)
}
