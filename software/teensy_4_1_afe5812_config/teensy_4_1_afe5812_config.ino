#include <SPI.h>

const uint8_t AFE_RESET = 3;
const uint8_t AFE_PDN_VCA = 4;
const uint8_t AFE_PDN_ADC = 5;
const uint8_t AFE_PDN_GLOBAL = 6;

const uint8_t AFE_MISO_PIN = 39;
const uint8_t AFE_MOSI_PIN = 26;
const uint8_t AFE_SCK_PIN = 27;
const uint8_t AFE_CE_PIN = 38;

//Joe's SPI bit-bang code
/* Shift a byte out serially with the given frequency in Hz (<= 500kHz) */
void spi_write(uint8_t data_pin, uint8_t clock_pin, uint32_t freq, uint8_t bit_order, uint8_t mode, uint8_t bits, uint32_t val) {
  uint32_t period = (freq >= 500000) ? 1 : (500000 / freq);  // Half clock period in uS
  uint8_t cpol = (mode == SPI_MODE2 || mode == SPI_MODE3);
  uint8_t cpha = (mode == SPI_MODE1 || mode == SPI_MODE3);
  uint8_t sck = cpol ? HIGH : LOW;

  uint8_t i;
  uint32_t start_time;

  // Set clock idle for 2 periods
  digitalWrite(clock_pin, sck);
  delayMicroseconds(period * 4);

  for (i = 0; i < bits; i++) {
    start_time = micros();

    // Shift bit out
    if (bit_order == LSBFIRST)
      digitalWrite(data_pin, !!(val & (1 << i)));
    else
      digitalWrite(data_pin, !!(val & (1 << ((bits - 1) - i))));

    // Toggle clock leading edge
    sck = !sck;
    if (cpha) {
      digitalWrite(clock_pin, sck);
      while (micros() - start_time < period)
        ;
    } else {
      while (micros() - start_time < period)
        ;
      digitalWrite(clock_pin, sck);
    }

    // Toggle clock trailing edge
    start_time = micros();
    sck = !sck;
    if (cpha) {
      digitalWrite(clock_pin, sck);
      while (micros() - start_time < period)
        ;
    } else {
      while (micros() - start_time < period)
        ;
      digitalWrite(clock_pin, sck);
    }
  }
}



void setup() {
  pinMode(LED_BUILTIN, OUTPUT);

  pinMode(AFE_MISO_PIN, INPUT);
  pinMode(AFE_MOSI_PIN, OUTPUT);
  pinMode(AFE_SCK_PIN, OUTPUT);
  pinMode(AFE_CE_PIN, OUTPUT);

  pinMode(AFE_RESET, OUTPUT);
  pinMode(AFE_PDN_VCA, OUTPUT);
  pinMode(AFE_PDN_ADC, OUTPUT);
  pinMode(AFE_PDN_GLOBAL, OUTPUT);


  digitalWrite(AFE_PDN_VCA, 0);
  digitalWrite(AFE_PDN_ADC, 0);
  digitalWrite(AFE_PDN_GLOBAL, 0);
  digitalWrite(AFE_SCK_PIN, 1);
  digitalWrite(AFE_RESET, 0);
  digitalWrite(AFE_CE_PIN, 1);
  delay(1);
  digitalWrite(AFE_RESET, 1);
  delay(1);
  digitalWrite(AFE_RESET, 0);
  
  delay(10);

  loopbackAFE();
}

void loop() {
  // digitalWrite(LED_BUILTIN, HIGH);  // turn the LED on (HIGH is the voltage level)
  // delay(500);                       // wait for a second
  // digitalWrite(LED_BUILTIN, LOW);   // turn the LED off by making the voltage LOW
  // delay(500);                       // wait for a second

  // loopbackAFE();
}

void loopbackAFE() {

  int freq = 10000;  //hz

  // Ping AFE to send data over MISO
  if(false) {
    //write BEEF to a register
    digitalWrite(AFE_CE_PIN, 0);
    spi_write(AFE_MOSI_PIN, AFE_SCK_PIN, freq, MSBFIRST, SPI_MODE3, 24, 0x031100);
    digitalWrite(AFE_CE_PIN, 1);

    delay(5);


    // //write to enable reads
    digitalWrite(AFE_CE_PIN, 0);
    spi_write(AFE_MOSI_PIN, AFE_SCK_PIN, freq, MSBFIRST, SPI_MODE3, 24, 0x000002);
    digitalWrite(AFE_CE_PIN, 1);

    delay(5);


    // //read BEEF from the register
    digitalWrite(AFE_CE_PIN, 0);
    spi_write(AFE_MOSI_PIN, AFE_SCK_PIN, freq, MSBFIRST, SPI_MODE3, 24, 0x031100);
    digitalWrite(AFE_CE_PIN, 1);
    


    delay(5);


    // //write to enable writes
    digitalWrite(AFE_CE_PIN, 0);
    spi_write(AFE_MOSI_PIN, AFE_SCK_PIN, freq, MSBFIRST, SPI_MODE3, 24, 0x000000);
    digitalWrite(AFE_CE_PIN, 1);
  }
  //real config

  digitalWrite(AFE_CE_PIN, 0);
  spi_write(AFE_MOSI_PIN, AFE_SCK_PIN, freq, MSBFIRST, SPI_MODE3, 24, 0x000001);
  digitalWrite(AFE_CE_PIN, 1);

  delay(5);


  digitalWrite(AFE_CE_PIN, 0);
  spi_write(AFE_MOSI_PIN, AFE_SCK_PIN, freq, MSBFIRST, SPI_MODE3, 24, 0x040018);
  digitalWrite(AFE_CE_PIN, 1);

  delay(5);

  int channel_enable = 0b00000101; //1=on, 0=off. Zero on the right

  // LNA Gain
  // 2 bits 
  // 00: 18 dB
  // 01: 24 dB
  // 10: 15 dB
  // 11: Reserved
  int lna_gain = 0b10; 
  
  // PGA Gain
  // 1 bit
  // 0:24 dB
  // 1:30 dB
  int pga_gain = 0b0;

  // Active Termination
  // 1 bit
  // 0: Disable
  // 1: Enable active termination
  int act_term = 0b0;


  // VCA Attenuation
  // 3 bits
  // 000: 0-dB attenuation
  // 001: 6-dB attenuation
  // N: About N * 6 dB attenuation
  int vca_attn = 0b000;

  // Test Pattern
  // 3 Bits
  // 000: Normal operation
  // 001: Sync
  // 010: De-skew
  // 011: Custom
  // 2[15:13] 0x2[15:13] 0 TEST_PATTERN_MODES 100:All 1's
  // 101: Toggle
  // 110: All 0's
  // 111: Ramp. Note: Reg.0x16 should be set as 1, i.e. demodulator is disabled.
  int test_pattern = 0b000;

  digitalWrite(AFE_CE_PIN, 0);
  spi_write(AFE_MOSI_PIN, AFE_SCK_PIN, freq, MSBFIRST, SPI_MODE3, 24, 0x0207F8 ^ (channel_enable << 3) | (test_pattern << 13));
  digitalWrite(AFE_CE_PIN, 1);

  delay(5);

  digitalWrite(AFE_CE_PIN, 0);
  spi_write(AFE_MOSI_PIN, AFE_SCK_PIN, freq, MSBFIRST, SPI_MODE3, 24, 0x0183FC ^ (channel_enable << 2)); //shut down ADCs
  digitalWrite(AFE_CE_PIN, 1);

  delay(5);

  digitalWrite(AFE_CE_PIN, 0);
  spi_write(AFE_MOSI_PIN, AFE_SCK_PIN, freq, MSBFIRST, SPI_MODE3, 24, 0x3500FF ^ (channel_enable << 0)); //shut down LNAs
  digitalWrite(AFE_CE_PIN, 1);

  delay(5);

  digitalWrite(AFE_CE_PIN, 0);
  spi_write(AFE_MOSI_PIN, AFE_SCK_PIN, freq, MSBFIRST, SPI_MODE3, 24, 0x030000);
  digitalWrite(AFE_CE_PIN, 1);

  delay(5);

  // AFE5812 only
  // If this is run on the AFE5808A, it shuts the chip down
  digitalWrite(AFE_CE_PIN, 0);
  spi_write(AFE_MOSI_PIN, AFE_SCK_PIN, freq, MSBFIRST, SPI_MODE3, 24, 0x160001); //turn off demodulator
  digitalWrite(AFE_CE_PIN, 1);

  delay(5);

  digitalWrite(AFE_CE_PIN, 0);
  spi_write(AFE_MOSI_PIN, AFE_SCK_PIN, freq, MSBFIRST, SPI_MODE3, 24, 0x340000 | (act_term << 8) | (lna_gain << 13));
  digitalWrite(AFE_CE_PIN, 1);

  delay(5);

  digitalWrite(AFE_CE_PIN, 0);
  spi_write(AFE_MOSI_PIN, AFE_SCK_PIN, freq, MSBFIRST, SPI_MODE3, 24, 0x330008 | (pga_gain << 13));
  digitalWrite(AFE_CE_PIN, 1);

  delay(5);

  digitalWrite(AFE_CE_PIN, 0);
  spi_write(AFE_MOSI_PIN, AFE_SCK_PIN, freq, MSBFIRST, SPI_MODE3, 24, 0x3B0088 | (vca_attn << 4));
  digitalWrite(AFE_CE_PIN, 1);

  delay(5);


}
