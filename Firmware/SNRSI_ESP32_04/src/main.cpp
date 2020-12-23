// #include <Arduino.h>

#include "methods.h"
#include "FastLED.h"
// #include "storePWM.h"

#define NUM_LEDS 20

CRGB leds[NUM_LEDS];

// debugging through serial monitor
bool debug = true;
// float charge;
// float standby;

uint32_t prgb_init, prgb_curr;
// uint32_t brgb_init, brgb_curr;

float avg_value = 0;
uint8_t avg_value2 = 0;

void setup()
{

  Serial.begin(9600);
  EEPROM.begin(512);

  /*
   * Initialisation for various peripherals:
   *      - bluetooth connection
   *      - PWM channels for HV and buzzer
   *      - RGB LED pins
   *      - ADC input pins (batt_voltage, tube_voltage)
   */

  // initialise ADC pins for batt and tube voltage monitoring
  adcAttachPin(BATTERY_PIN);
  adcAttachPin(GMTUBE_PIN);

  // initialise PWMs for boost converter and buzzer
  setPWM();

  // initialise interrupt service routines
  setISR();

  // initialise RGB LED
  FastLED.addLeds<WS2812B, RGB_PIN, GRB>(leds, NUM_LEDS);

  // initiate bluetooth connection
  initBLE(); //UUID);

  prgb_init = millis();
  // brgb_init = millis();

  if (EEPROM.read(0) == 0)
  {
    pwm.dutyCycle = EEPROMReadInt(1);
    Serial.println(pwm.dutyCycle);
  }
}

int pwm_count = 0;

void loop()
{
  /* RGB blinks in GREEN for once every one second */
  prgb_curr = millis();
  if (prgb_curr - prgb_init > 900)
  {
    if (deviceConnected)
    {
      leds[0] = CRGB(0, 50, 0);
    }
    else
    {
      leds[0] = CRGB(0, 0, 50);
    }
    FastLED.show();

    if (prgb_curr - prgb_init > 1000)
    {
      prgb_init = prgb_curr;
    }
  }

  ledcWrite(pwm.channel, pwm.dutyCycle);

  // interrupt program when one second has passed
  if (int_timer.isr_count > 0)
  {
    portENTER_CRITICAL(&timerMux);
    int_timer.isr_count--;
    portEXIT_CRITICAL(&timerMux);

    pwm_count++;

    // charge = ReadVoltage(CHRG_PIN);
    // standby = ReadVoltage(STBY_PIN);
    BLEdata.tube_voltage = ReadVoltage(GMTUBE_PIN) / 0.00473;
    pwmVary();
  }

  // executing every one sec
  if (pwm_count > 2)
  {
    timerReady = true;
    collectData(pulse.cpm);
    pulse.cpm = 0;

    // setting beta for battery first & second order filters
    static float beta = 0.3;
    static uint8_t count = 0;
    if (count < 5)
    {
      count++;
    }
    else
    {
      beta = 0.9;
    }
    // Serial.print("BLEdata");
    // Serial.println(BLEdata.batt_voltage);
    // Serial.print("beta: ");
    // Serial.println(beta);
    // Serial.print("avg_value : ");
    // Serial.println(avg_value);
    avg_value = beta * avg_value + (1 - beta) * BLEdata.batt_voltage;
    avg_value2 = beta * avg_value2 + (1 - beta) * avg_value;
    avg_value2 = (int)round(avg_value2);
    pwm_count = 0;
  }

  // interrupt program when a pulse is detected
  if (pulse.count > 0)
  {
    portENTER_CRITICAL(&mux);
    pulse.count--;
    portEXIT_CRITICAL(&mux);

    // not an efficient method at high cpm rate
    ledcWrite(buzzer.channel, buzzer.dutyCycle); // on the buzzer
    delay(5);
    ledcWrite(buzzer.channel, 0); // off the buzzer

    pulse.cpm++;
  }

  /****************************************************
   * BLE section
   *****************************************************
   */

  // check if timer is ready and device is connected

  if (/* deviceConnected && */ timerReady)
  {
    String str = "";
    str += BLEdata.cpm;
    str += ",";
    str += avg_value2;
    str += ",";
    str += BLEdata.tube_voltage;

    if (debug)
    {
      Serial.print("Device connected");
      Serial.print("\t");
      Serial.println("Sending data: " + str);
      // Serial.println("Charge value: " + String(charge));
      // Serial.println("Standby value: " + String(standby));
    }

    // package the value and send through one channel
    pCharacteristic->setValue((char *)str.c_str());
    pCharacteristic->notify();

    timerReady = false;
  }

  // disconnecting
  if (!deviceConnected && oldDeviceConnected)
  {
    delay(500);                  // give the bluetooth stack the chance to get things ready
    pServer->startAdvertising(); // restart advertising
    if (debug)
    {
      Serial.print("Device disconnected");
      Serial.print("\t");
      Serial.println("start advertising");
    }

    oldDeviceConnected = deviceConnected;
  }

  // connecting
  if (deviceConnected && !oldDeviceConnected)
  {
    // do stuff here on connecting
    oldDeviceConnected = deviceConnected;
  }

  /****************************************************
   * BLE section end
   *****************************************************
   */
}