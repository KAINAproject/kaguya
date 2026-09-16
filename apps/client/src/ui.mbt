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
fn button_set_enabled(button : @dom.HTMLButtonElement, enabled : Bool) -> Unit {
  button.disabled = !enabled
}

///|
fn button_set_label(button : @dom.HTMLButtonElement, label : String) -> Unit {
  button.setTextContent(label)
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
fn update_interaction(
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
