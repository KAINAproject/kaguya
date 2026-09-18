///|
test "event bus publishes to every subscriber" {
  let count = Ref(0)
  let bus = EventBus::new()
  bus.subscribe(fn(_event) { count.val += 1 })
  bus.subscribe(fn(_event) { count.val += 1 })
  bus.publish(BridgeEvent::Connected("test"))
  assert_eq(count.val, 2)
}
