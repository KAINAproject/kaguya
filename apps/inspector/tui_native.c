#include <stddef.h>

// The async external-loop contract may call this callback from its waiter
// thread. The TUI loop polls frequently, so it does not need an extra wakeup.
void kaguya_tui_noop_wakeup(void) {}
