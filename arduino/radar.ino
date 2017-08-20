#include <Servo.h>
#include <SharpDistSensor.h>
#define DELIMITER "\n"
#define MEASURE_DELAY 80
#define IR_SENSOR_PIN A0
#define PWM_SERVO 11

long duration;
int angle;

Servo servo;
SharpDistSensor sensor(IR_SENSOR_PIN, 5);

void sendMeasure(int angle){
  servo.write(angle);
  delay(MEASURE_DELAY);
  sendData(angle, sensor.getDist());
}

void sendData(int a, int d){
  Serial.print(a);
  Serial.print(",");
  Serial.print(d);
  Serial.print(DELIMITER);
}

void setup() {

  servo.attach(PWM_SERVO);
  servo.write(0);

  sensor.setModel(SharpDistSensor::GP2Y0A60SZLF_5V);

  // let the servo some time to reach the initial angle
  delay(100);

  Serial.begin(9600);

}

void loop() {
  for (int angle = 0; angle <= 180; angle++){
    sendMeasure(angle);
  }
  for (int angle = 180; angle >= 0; angle--){
    sendMeasure(angle);
  }
}
