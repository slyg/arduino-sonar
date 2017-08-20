# Arduino sonar

## Prerequisites

- node version 8+
- elm version 0.18
- arduino IDE

## Setup

1. Upload the sketch (`sketch.ino`) on the arduino board
    - `sonar.ino` using ultrasonic sensor
    - `radar.ino` if you want to test with an [IR sharp sensor](http://www.sharp-world.com/products/device/lineup/data/pdf/datasheet/gp2y0a21yk_e.pdf)
2. Start the node process `node index.js` in `./socketserver` (you may have to change the serial port before though)
3. Start the ui using `elm reactor` in `./ui`

Notice the Serial port can't be used to update the chip at the same time as sending data so you might stop the websocket server on program deployments.

## Illustrations



![Screenshot of the sonar UI](https://thumbs.gfycat.com/GleefulFeminineFrogmouth-small.gif)  | ![Photo of the sonar and board](https://user-images.githubusercontent.com/602143/29384595-93528ca0-82cc-11e7-9212-7ba519a4c2e4.jpg)
:-------------------------:|:-------------------------:
UI             |  Setup photo
