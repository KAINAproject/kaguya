///|
#external
priv type Button

///|
#external
priv type StatusElement

///|
#external
priv type InteractionElement

///|
extern "js" fn enter_button() -> Button =
  #| () => {
  #|   const button = document.querySelector("#enter-xr")
  #|   if (!button) throw new Error("enter-xr button が見つかりません")
  #|   return button
  #| }

///|
extern "js" fn status_element() -> StatusElement =
  #| () => {
  #|   const status = document.querySelector("#status")
  #|   if (!status) throw new Error("status element が見つかりません")
  #|   return status
  #| }

///|
extern "js" fn interaction_element() -> InteractionElement =
  #| () => {
  #|   const interaction = document.querySelector("#interaction")
  #|   if (!interaction) throw new Error("interaction element が見つかりません")
  #|   return interaction
  #| }

///|
extern "js" fn canvas_size(canvas : @three.Canvas) -> Int =
  #| canvas => Math.max(canvas.clientWidth || canvas.width || 1, 1)

///|
extern "js" fn Button::on_click(self : Button, callback : () -> Unit) -> Unit =
  #| (button, callback) => button.addEventListener("click", callback)

///|
extern "js" fn Button::set_enabled(self : Button, enabled : Bool) -> Unit =
  #| (button, enabled) => { button.disabled = !enabled }

///|
extern "js" fn Button::set_label(self : Button, label : String) -> Unit =
  #| (button, label) => { button.textContent = label }

///|
extern "js" fn StatusElement::set_message(
  self : StatusElement,
  message : String,
  kind : String,
) -> Unit =
  #| (status, message, kind) => {
  #|   status.textContent = message
  #|   status.dataset.kind = kind
  #| }

///|
extern "js" fn InteractionElement::set_state(
  self : InteractionElement,
  state : String,
  controller : String,
  label : String,
  detail : String,
) -> Unit =
  #| (interaction, state, controller, label, detail) => {
  #|   interaction.dataset.state = state
  #|   interaction.dataset.controller = controller
  #|   const stateElement = interaction.querySelector("#interaction-state")
  #|   const detailElement = interaction.querySelector("#interaction-detail")
  #|   const controllerElement = interaction.querySelector("#interaction-controller")
  #|   if (stateElement) stateElement.textContent = label
  #|   if (detailElement) detailElement.textContent = detail
  #|   if (controllerElement) {
  #|     const controllerLabel = controller === "left"
  #|       ? "左コントローラー"
  #|       : controller === "right" ? "右コントローラー" : "コントローラー —"
  #|     controllerElement.textContent = controllerLabel
  #|   }
  #| }
