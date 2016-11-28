#include "Arduino.h"
#include "LiquidCrystal.h"
// #include "Servo.h"

LiquidCrystal lcd(12, 11, 5, 4, 3, 2);

const unsigned int NUM_READS = 8;
const unsigned int TEMP_SENSOR_PIN = A0;
const unsigned int VOLTAGE_SENSOR_PIN = A1;
const float baseline_temp = 20.0;

// unsigned int angle = 0;
// Servo servo;

void setup() {
  analogReference(EXTERNAL);
  Serial.begin(9600);

  // relay
  pinMode(8, OUTPUT);
  digitalWrite(8, LOW);

  // servo
  // servo.attach(9);
  // servo.write(angle);

  // lcd
  lcd.begin(16, 2);
}

void loop() {
  unsigned int temp_sensor = 0;
  float voltage, temp;

  analogRead(TEMP_SENSOR_PIN);

  for (unsigned int i = 0; i < NUM_READS; i++) {
    temp_sensor += analogRead(TEMP_SENSOR_PIN);
  }

  temp_sensor /= NUM_READS;

  voltage = (temp_sensor / 1024.0) * 3.3;
  temp = (voltage - 0.5) * 100;

  Serial.print("Temperature Sensor Value: ");
  Serial.print(temp_sensor);
  Serial.print(", Voltage: ");
  Serial.print(voltage);
  Serial.print(", Temperature: ");
  Serial.print(temp);
  Serial.println(" degrees C");

  lcd.clear();
  lcd.print(temp);
  lcd.print((char) 223);
  lcd.print("C");

  // unsigned long time = millis();
  // angle = (angle + 60) % 180;

  // lcd.setCursor(0, 1);
  // lcd.print(angle);
  // lcd.print((char) 223);

  // servo.write(angle);

  delay(1000);
}

int main(void) {
  init();

  setup();

  for (;;) {
    loop();
  }
}
