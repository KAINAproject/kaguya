///|
#external
pub type BatteryStatus

///|
extern "js" fn ffi_current_battery_status() -> @core.Any =
  #| () => {
  #|   const state = globalThis.__kaguyaBatteryState ??= {
  #|     initialized: false,
  #|     available: false,
  #|     level: 0,
  #|     charging: false,
  #|   }
  #|   if (!state.initialized) {
  #|     state.initialized = true
  #|     const navigatorValue = globalThis.navigator
  #|     const getBattery = navigatorValue?.getBattery
  #|     if (typeof getBattery === "function") {
  #|       Promise.resolve()
  #|         .then(() => getBattery.call(navigatorValue))
  #|         .then(battery => {
  #|           state.available = true
  #|           const update = () => {
  #|             state.level = battery.level
  #|             state.charging = battery.charging
  #|           }
  #|           update()
  #|           battery.addEventListener?.("levelchange", update)
  #|           battery.addEventListener?.("chargingchange", update)
  #|         })
  #|         .catch(() => {})
  #|     }
  #|   }
  #|   return state.available ? state : null
  #| }

///|
fn current_battery_status() -> BatteryStatus? {
  let value : @core.Any = ffi_current_battery_status()
  if @core.is_nullish(value) {
    None
  } else {
    Some(value.cast())
  }
}

///|
pub extern "js" fn BatteryStatus::level(self : BatteryStatus) -> Float =
  #| status => status.level

///|
pub extern "js" fn BatteryStatus::is_charging(self : BatteryStatus) -> Bool =
  #| status => status.charging
