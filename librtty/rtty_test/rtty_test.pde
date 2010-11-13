#include <rtty.h>

// Pin, baud, stopbits
RTTY rtty(6, 50, 1.5, CHECKSUM_CRC16);

void setup() {
  // do nothing
}

void loop() {
  rtty.transmit("Hello");
  delay(2000);
}
