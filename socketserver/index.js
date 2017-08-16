const WebSocket = require('ws')
const SerialPort = require('serialport')
const parsers = SerialPort.parsers

const port = new SerialPort('/dev/tty.usbmodem1411', { baudRate: 9600 })
const parser = new parsers.Readline({ delimiter: '\n' })

port
  .pipe(parser)
  .on('open', () => console.log('Port open'))

const wss = new WebSocket.Server({ port: 9999 })

wss.on('connection', function connection(ws) {

  const cb = (data) => {
    const [ angleString, distanceString ] = data.split(',')
    const [ angle, distance ] = [ +angleString, +distanceString ]
    console.log(angle, distance)
    ws.send(JSON.stringify({ angle, distance }))
  }

  parser.on('data', cb)

  ws.on('close', () => {
    parser.removeListener('data', cb)
  })

})
