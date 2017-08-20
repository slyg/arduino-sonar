#include <Servo.h>
#define PWM_TRIG 9
#define PWM_ECHO 10
#define PWM_SERVO 11
#define DELIMITER "\n" // used to separate each message
#define MEASURE_DELAY 2 // Delay (ms) given to the servo to accomplish a distance measure

long duration;
int distance;
int angle;

Servo servo;

int measureDistance(){
  digitalWrite(PWM_TRIG, LOW);
  delayMicroseconds(10);

  // trigger for 10μs,
  // signaling to the sensor to do a 10μs sonic bursts
  digitalWrite(PWM_TRIG, HIGH);
  delayMicroseconds(10); // the sensor generates sonic bursts during this time
  digitalWrite(PWM_TRIG, LOW);

  // Compute duration
  // Read the time when the echo comes back
  duration = pulseIn(PWM_ECHO, HIGH); // in μs
  return duration*0.034/2; // in cm;
}

void sendMeasure(int angle){
  servo.write(angle);
  delay(MEASURE_DELAY);
  distance = measureDistance();
  sendData(angle, distance);
}

void sendData(int a, int d){
  Serial.print(a);
  Serial.print(",");
  Serial.print(d);
  Serial.print(DELIMITER);
}

void setup() {

  pinMode(PWM_TRIG, OUTPUT);
  pinMode(PWM_ECHO, INPUT);

  servo.attach(PWM_SERVO);
  servo.write(0);

  // let the servo time to reach the initial angle
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
