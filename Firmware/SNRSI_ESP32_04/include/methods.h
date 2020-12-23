
// #include "Arduino.h"
#include "properties.h"
#include "EEPROM.h"
#include "storePWM.h"
// #include "cmd.h"

/****************************************************
 * BLE section start
 *****************************************************
 */

class MyServerCallbacks : public BLEServerCallbacks
{
  void onConnect(BLEServer *pServer)
  {
    deviceConnected = true;
    BLEDevice::startAdvertising();
  };

  void onDisconnect(BLEServer *pServer)
  {
    deviceConnected = false;
  }
};

void initBLE()
{
  // Create the BLE Device
  BLEDevice::init("RX-666");

  // Create the BLE Server
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  // Create the BLE Service
  BLEService *pService = pServer->createService(SERVICE_UUID);

  // Create a BLE Characteristic
  pCharacteristic = pService->createCharacteristic(
      CHARACTERISTIC_UUID,
      BLECharacteristic::PROPERTY_READ |
          BLECharacteristic::PROPERTY_WRITE |
          BLECharacteristic::PROPERTY_NOTIFY |
          BLECharacteristic::PROPERTY_INDICATE);

  // https://www.bluetooth.com/specifications/gatt/viewer?attributeXmlFile=org.bluetooth.descriptor.gatt.client_characteristic_configuration.xml
  // Create a BLE Descriptor
  pCharacteristic->addDescriptor(new BLE2902());

  // Start the service
  pService->start();

  // Start advertising
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(CHARACTERISTIC_UUID);
  pAdvertising->setScanResponse(false);
  pAdvertising->setMinPreferred(0x0); // set value to 0x00 to not advertise this parameter
  BLEDevice::startAdvertising();
  Serial.println("Waiting a client connection to notify...");
}

/****************************************************
 * BLE section end
 *****************************************************
 */

void IRAM_ATTR onTimer()
{
  portENTER_CRITICAL_ISR(&timerMux);
  int_timer.isr_count++;
  portEXIT_CRITICAL_ISR(&timerMux);
}

void IRAM_ATTR onPulse()
{
  // subprocedure for capturing pulses from GM tube
  portENTER_CRITICAL_ISR(&mux);
  pulse.count++;
  portEXIT_CRITICAL_ISR(&mux);
}

void setPWM()
{
  //  initiate pwm channel 0, freq 7khz, resolution 12, pin 25
  ledcSetup(pwm.channel, pwm.freq, pwm.resolution);
  ledcAttachPin(pwm.pin, pwm.channel);

  //  initiate pwm channel 1, freq 1khz, resolution 15, pin 26
  ledcSetup(buzzer.channel, buzzer.freq, buzzer.resolution);
  ledcAttachPin(buzzer.pin, buzzer.channel);
}

void setISR()
{
  // set interrupt for capturing pulses
  pinMode(pulse.pin, INPUT);
  attachInterrupt(digitalPinToInterrupt(pulse.pin), onPulse, FALLING);

  // set timer interrupt
  timer = timerBegin(0, 80, true);
  timerAttachInterrupt(timer, &onTimer, true);
  timerAlarmWrite(timer, int_timer.half_sec, true);
  timerAlarmEnable(timer);
}

// function to make adc reading more linear (more accurate)
float ReadVoltage(byte pin)
{
  double reading = analogRead(pin); // Reference voltage is 3v3 so maximum reading is 3v3 = 4095 in range 0 to 4095

  if (reading < 1 || reading > 4095)
    return 0;

  // converting raw value into voltage
  return -0.000000000000016 * pow(reading, 4) +
         0.000000000118171 * pow(reading, 3) - 0.000000301211691 * pow(reading, 2) + 0.001109019271794 * reading + 0.034143524634089;
}

void collectData(uint32_t cpm)
{
  BLEdata.cpm = cpm;
  // BLEdata.tube_voltage = ReadVoltage(GMTUBE_PIN) / 0.00473;

  BLEdata.batt_voltage = (ReadVoltage(BATTERY_PIN) / 0.67797 - 3.4) / 0.6 * 100;
  // Algo A = algo for not charging, algo B = algo for charging
  // algo A and B are the algo for battery percentage conversion.
  // we have to benchmark again full and idle battery (idle mean not charging)
  //if the avg is going up, the program will know that it is charging and use algoB
  // capping battery percentages
  if (BLEdata.batt_voltage >= 100)
  {
    BLEdata.batt_voltage = 100;
  }
  else if (BLEdata.batt_voltage <= 0)
  {
    BLEdata.batt_voltage = 0;
  }
}

void pwmVary()
{
  // increase duty cycle when volt is less than thresholds
  if (BLEdata.tube_voltage < 375)
    pwm.dutyCycle += 5;
  else if (BLEdata.tube_voltage < 380)
    pwm.dutyCycle += 1;
  // else if (BLEdata.tube_voltage < 380)
  //   pwm.dutyCycle += 1;

  // decrease duty cycle when volt is more than thresholds
  if (BLEdata.tube_voltage > 390)
    pwm.dutyCycle -= 5;
  else if (BLEdata.tube_voltage > 385)
    pwm.dutyCycle -= 1;
  // else if (BLEdata.tube_voltage > 382)
  //   pwm.dutyCycle -= 1;

  // register the operational duty cycle into EEPROM
  if (BLEdata.tube_voltage >= 381 && BLEdata.tube_voltage <= 383)
  {
    EEPROM.write(0, 0);
    EEPROMWriteInt(1, pwm.dutyCycle);
    EEPROM.commit();
  }
}