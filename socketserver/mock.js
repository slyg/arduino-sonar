const WebSocket = require('ws')

const wss = new WebSocket.Server({ port: 9999 })

const pseudoObstacle = angle => {
  if (angle > 45 && angle < 90) {
    return 20
  } else if (angle > 110 && angle < 150) {
    return 30
  } else {
    return 45
  }
}

const distanceRandomizer = angle =>
  Math.floor(Math.random() * 2) + pseudoObstacle(angle)

function* gen() {
  let angle = 0
  while (angle <= 180) {
    yield { angle, distance: distanceRandomizer(angle) }
    angle++
  }
  yield* invGen()
}

function* invGen() {
  let angle = 180
  while (angle >= 0) {
    yield { angle, distance: distanceRandomizer(angle) }
    angle--
  }
  yield* gen()
}


wss.on('connection', function connection(ws) {

  const data = gen()

  const id = setInterval(() => {
    ws.send(JSON.stringify(data.next().value))
  }, 10)

  ws.on('close', () => {
    clearInterval(id)
  })

})
