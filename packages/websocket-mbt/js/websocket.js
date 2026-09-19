const INITIAL_RECONNECT_DELAY_MS = 250
const MAX_RECONNECT_DELAY_MS = 5000

class WebSocketConnection {
  constructor(url, onMessage) {
    this.url = url
    this.onMessage = onMessage
    this.socket = null
    this.closed = false
    this.reconnectTimer = null
    this.reconnectDelay = INITIAL_RECONNECT_DELAY_MS
    this.openWaiters = []
    this.connect()
  }

  waitUntilOpen() {
    if (this.isOpen()) return Promise.resolve()
    return new Promise((resolve) => {
      this.openWaiters.push(resolve)
    })
  }

  connect() {
    if (this.closed) return

    const socket = new WebSocket(this.url)
    socket.binaryType = "arraybuffer"
    this.socket = socket

    socket.onopen = () => {
      if (this.closed || socket !== this.socket) {
        socket.close()
        return
      }

      this.reconnectDelay = INITIAL_RECONNECT_DELAY_MS
      const waiters = this.openWaiters
      this.openWaiters = []
      for (const resolve of waiters) resolve()
    }

    socket.onerror = () => {
      if (socket === this.socket) socket.close()
    }

    socket.onclose = () => {
      if (socket !== this.socket) return
      this.socket = null
      if (!this.closed) this.scheduleReconnect()
    }

    socket.onmessage = async (event) => {
      if (event.data instanceof ArrayBuffer) {
        if (!this.closed && socket === this.socket) {
          this.onMessage(new Uint8Array(event.data))
        }
      } else if (event.data instanceof Blob) {
        const payload = new Uint8Array(await event.data.arrayBuffer())
        if (!this.closed && socket === this.socket) this.onMessage(payload)
      }
    }
  }

  scheduleReconnect() {
    if (this.reconnectTimer !== null) return

    const delay = this.reconnectDelay
    this.reconnectDelay = Math.min(
      this.reconnectDelay * 2,
      MAX_RECONNECT_DELAY_MS,
    )
    this.reconnectTimer = setTimeout(() => {
      this.reconnectTimer = null
      this.connect()
    }, delay)
  }

  send(payload) {
    if (this.isOpen()) this.socket.send(payload)
  }

  isOpen() {
    return this.socket?.readyState === WebSocket.OPEN
  }

  bufferedAmount() {
    return this.socket?.bufferedAmount ?? 0
  }

  close() {
    this.closed = true
    if (this.reconnectTimer !== null) {
      clearTimeout(this.reconnectTimer)
      this.reconnectTimer = null
    }
    const socket = this.socket
    this.socket = null
    if (socket !== null) socket.close()
  }
}

export const websocketCreate = (url, onMessage) =>
  new WebSocketConnection(url, onMessage)

export const websocketWaitUntilOpen = (connection) =>
  connection.waitUntilOpen()

export const websocketSend = (connection, payload) => connection.send(payload)

export const websocketIsOpen = (connection) => connection.isOpen()

export const websocketBufferedAmount = (connection) =>
  connection.bufferedAmount()

export const websocketClose = (connection) => connection.close()
