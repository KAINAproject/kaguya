export const websocketOpen = (url, onMessage) =>
  new Promise((resolve, reject) => {
    const socket = new WebSocket(url)
    socket.binaryType = "arraybuffer"
    socket.onopen = () => resolve(socket)
    socket.onerror = () => reject(new Error(`WebSocket connection failed: ${url}`))
    socket.onmessage = async (event) => {
      if (event.data instanceof ArrayBuffer) {
        onMessage(new Uint8Array(event.data))
      } else if (event.data instanceof Blob) {
        onMessage(new Uint8Array(await event.data.arrayBuffer()))
      }
    }
  })

export const websocketSend = (socket, payload) => socket.send(payload)

export const websocketIsOpen = (socket) => socket.readyState === WebSocket.OPEN

export const websocketBufferedAmount = (socket) => socket.bufferedAmount

export const websocketClose = (socket) => socket.close()
