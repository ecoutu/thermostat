#include "Arduino.h"
#include "LiquidCrystal.h"

enum Response {unknown, relay_on, relay_off};

LiquidCrystal lcd(12, 11, 5, 4, 3, 2);

const unsigned int READ_BUFFER_SIZE = 256;
const unsigned int NUM_READS = 8;
const unsigned int TEMP_SENSOR_PIN = A0;
const unsigned int VOLTAGE_SENSOR_PIN = A1;
const unsigned int RELAY_PIN = 8;
const float baseline_temp = 20.0;

void setup() {
  analogReference(EXTERNAL);
  Serial.begin(9600);

  // relay
  pinMode(RELAY_PIN, OUTPUT);
  digitalWrite(RELAY_PIN, LOW);

  // lcd
  lcd.begin(16, 2);
}

float read_temperature(unsigned int pin) {
  unsigned int temp_sensor = 0;
  float voltage, temp;

  analogRead(pin);

  for (unsigned int i = 0; i < NUM_READS; i++) {
    temp_sensor += analogRead(pin);
  }

  temp_sensor /= NUM_READS;

  voltage = (temp_sensor / 1024.0) * 3.3;
  return (voltage - 0.5) * 100;
}

void send_temperature(float temp) {
  Serial.print("TEMP ");
  Serial.print(temp);
  Serial.print("\n");
}

Response read_response() {
  char buffer[READ_BUFFER_SIZE];
  unsigned int bytes_read = 0;

  bytes_read = Serial.readBytesUntil('\n', buffer, READ_BUFFER_SIZE);
  if (bytes_read > 0) {
    buffer[bytes_read] = '\0';
    if (strncmp(buffer, "RELAY ON", READ_BUFFER_SIZE) == 0) {
      return relay_on;
    } else if (strncmp(buffer, "RELAY OFF", READ_BUFFER_SIZE) == 0) {
      return relay_off;
    }
  }
  return unknown;
}

void update_lcd(float temp, Response response) {
  lcd.clear();
  lcd.print(temp);
  lcd.print((char) 223);
  lcd.print("C");
  lcd.setCursor(0, 1);

  switch(response) {
    case relay_on:
      lcd.print("RELAY ON");
      break;
    case relay_off:
      lcd.print("RELAY OFF");
      break;
    default:
      lcd.print("UNKNOWN");
      break;
  }
}

void handle_response(Response response) {
  switch(response) {
    case relay_on:
      digitalWrite(RELAY_PIN, LOW);
      break;
    case relay_off:
      digitalWrite(RELAY_PIN, HIGH);
      break;
    default:
      break;
  }
}

void loop() {
  float temp = read_temperature(TEMP_SENSOR_PIN);
  Response response;

  send_temperature(temp);
  response = read_response();
  update_lcd(temp, response);
  handle_response(response);

  delay(1000);
}

int main(void) {
  init();

  setup();

  for (;;) {
    loop();
  }
}
