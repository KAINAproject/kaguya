///|
fn required_element(selector : String) -> @dom.Element {
  match @dom.document().querySelector(selector) {
    Some(element) => element
    None => {
      @core.throw_error("{selector} が見つかりません")
      @core.identity(@core.undefined())
    }
  }
}

///|
fn enter_button() -> @dom.HTMLButtonElement {
  @dom.HTMLButtonElement::cast_from_element(required_element("#enter-xr"))
}

///|
fn status_element() -> @dom.Element {
  required_element("#status")
}

///|
fn interaction_element() -> @dom.Element {
  required_element("#interaction")
}

///|
fn canvas_size() -> Int {
  let canvas = @dom.HTMLCanvasElement::cast_from_element(
    required_element("#canvas"),
  )
  let client_width = canvas.clientWidth()
  if client_width > 0 {
    client_width
  } else if canvas.width > 0 {
    canvas.width
  } else {
    1
  }
}

///|
fn button_on_click(
  button : @dom.HTMLButtonElement,
  callback : () -> Unit,
) -> Unit {
  button.addEventListener("click", fn(_event) { callback() })
}

///|
fn button_set_enabled(button : @dom.HTMLButtonElement, enabled : Bool) -> Unit {
  button.disabled = !enabled
}

///|
fn button_set_label(button : @dom.HTMLButtonElement, label : String) -> Unit {
  button.setTextContent(label)
}

///|
fn set_data(element : @dom.Element, key : String, value : String) -> Unit {
  let dataset = element.as_any()._get("dataset")
  dataset._set(key, @core.any(value))
}

///|
fn status_set_message(
  status : @dom.Element,
  message : String,
  kind : String,
) -> Unit {
  status.setTextContent(message)
  set_data(status, "kind", kind)
}

///|
fn interaction_set_state(
  interaction : @dom.Element,
  state : String,
  controller : String,
  label : String,
  detail : String,
) -> Unit {
  set_data(interaction, "state", state)
  set_data(interaction, "controller", controller)
  match interaction.querySelector("#interaction-state") {
    Some(element) => element.setTextContent(label)
    None => ()
  }
  match interaction.querySelector("#interaction-detail") {
    Some(element) => element.setTextContent(detail)
    None => ()
  }
  match interaction.querySelector("#interaction-controller") {
    Some(element) => {
      let controller_label = if controller == "left" {
        "左コントローラー"
      } else if controller == "right" {
        "右コントローラー"
      } else {
        "コントローラー —"
      }
      element.setTextContent(controller_label)
    }
    None => ()
  }
}
