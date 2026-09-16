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
fn set_data(element : @dom.Element, key : String, value : String) -> Unit {
  let dataset = element.as_any()._get("dataset")
  dataset._set(key, @core.any(value))
}
