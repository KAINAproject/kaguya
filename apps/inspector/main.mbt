///|
extern "C" fn noop_wakeup() -> Unit = "kaguya_tui_noop_wakeup"

///|
struct TuiLoop {
  state : @inspector_ui.InspectorState
  app : @vnode.VNodeApp
  cleanup : () -> Unit
  width : Int
  height : Int
  mut running : Bool
  mut next_render_at : Int64
}

///|
fn output(s : String) -> Unit {
  @tui_io.print_raw(s)
}

///|
fn TuiLoop::new(state : @inspector_ui.InspectorState) -> TuiLoop {
  let (width, height) = @tui_io.get_terminal_size()
  let (app, cleanup) = @vnode.init_vnode_terminal(width, height, output)
  let ui = {
    state,
    app,
    cleanup,
    width,
    height,
    running: true,
    next_render_at: @async.now() + 1000L,
  }
  ui.render()
  ui
}

///|
fn TuiLoop::render(self : TuiLoop) -> Unit {
  output(
    self.app.render_frame(
      @inspector_ui.render(self.state, self.width, self.height),
    ),
  )
}

///|
fn TuiLoop::handle_key(self : TuiLoop, key : String) -> Unit {
  let event = @tui.parse_input(key)
  if event.is_quit() {
    self.running = false
  }
}

///|
fn TuiLoop::is_running(self : TuiLoop) -> Bool {
  self.running
}

///|
pub impl @external_loop.ExternalEventLoop for TuiLoop with fn get_wakeup_callback_for_foreign_thread(
  _self,
) {
  () => noop_wakeup()
}

///|
pub impl @external_loop.ExternalEventLoop for TuiLoop with fn poll(
  self,
  timeout?,
) {
  // Keep polling input even when async has no timer. The native TUI input
  // implementation returns when no key is available.
  let _ = timeout
  let key = @tui_io.read_key()
  if key.length() > 0 {
    self.handle_key(key)
  }
  let now = @async.now()
  if now >= self.next_render_at {
    self.render()
    self.next_render_at = now + 1000L
  }
}

///|
pub impl @external_loop.ExternalEventLoop for TuiLoop with fn terminate(self) {
  (self.cleanup)()
}

///|
fn server_address() -> String {
  let args = @tui_io.get_args()
  if args.length() > 1 {
    args[1]
  } else {
    "127.0.0.1:9001"
  }
}

///|
async fn main {
  let state = @inspector_ui.InspectorState::new()
  let bus = @bridge.EventBus::new()
  bus.subscribe(fn(event) { state.on_event(event) })
  let ui = TuiLoop::new(state)

  // The TUI owns the main thread. async uses its native waiter thread and
  // resumes MoonBit coroutines from this polling loop.
  @async.set_external_event_loop(ui)
  @async.with_task_group <| group => {
    let address = server_address()
    group.spawn_bg() <| () => { @wsbridge.serve(address, bus) }
    while ui.is_running() {
      @async.sleep(100)
    }
  }
}
