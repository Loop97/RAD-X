
#include "Arduino.h"

#define PULSE_PIN 27      // for CPM
#define BUZZER_PIN 14     // for buzzer
#define PWM_PIN 25        // for HV
#define BATTERY_PIN 36    // for batt monitoring
#define GMTUBE_PIN 39     // for tube monitoring
// #define CHRG_PIN 17
// #define STBY_PIN 16
#define RGB_PIN 13        // for battery and BLE indication

/**************************************************** 
 * BLE section start
 *****************************************************
 */
 
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

#define SERVICE_UUID         "e514ae34-a8c5-11ea-bb37-0242ac130002" //to be changed to a unique one after development 2/Apr/2020
#define CHARACTERISTIC_UUID  "e514b19a-a8c5-11ea-bb37-0242ac130002" //to be changed to a unique one after development 2/Apr/2020

BLEServer* pServer = NULL;
BLECharacteristic* pCharacteristic = NULL;
bool deviceConnected = false;
bool oldDeviceConnected = false;
bool timerReady = false;

struct DataPacket {
  uint32_t cpm;
  float tube_voltage;
  float batt_voltage; // changed from float to int for testing
};

DataPacket BLEdata; //modified to do some test

/****************************************************
 * BLE section end
 *****************************************************
 */

struct Timer {
  volatile uint32_t isr_count;
  const uint32_t one_sec, half_sec;
};

struct IntPulse {
  const uint8_t pin;
  volatile uint8_t count;
  uint32_t cpm;
};

struct Pwm {
  const uint8_t pin;
  uint8_t channel;
  uint32_t freq;
  uint8_t resolution;
  uint16_t dutyCycle;
};

struct IntBuzzer {
  const uint8_t pin;
  uint8_t channel;
  uint32_t freq;
  uint8_t resolution;
  uint16_t dutyCycle;
};


/**
 * Adjustable Parameters
 */
Timer int_timer = {0, 1000000, 500000};
IntPulse pulse = {PULSE_PIN, 0, 0};
Pwm pwm = {PWM_PIN, 0, 25000, 13, 5000}; //67.14% DUTYCYCLE
IntBuzzer buzzer = {BUZZER_PIN, 3, 1000, 13, 7500}; //50% DUTYCYCLE


portMUX_TYPE mux = portMUX_INITIALIZER_UNLOCKED;
portMUX_TYPE timerMux = portMUX_INITIALIZER_UNLOCKED;

hw_timer_t * timer = NULL;