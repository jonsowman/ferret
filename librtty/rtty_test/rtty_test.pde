#include <rtty.h>

// Pin, baud, stopbits
RTTY rtty(6, 50, 1.5, CHECKSUM_CRC16);

void setup() {
  rtty.setBaud(50);
  rtty.setChecksum(CHECKSUM_NONE);
}

void loop() {
  rtty.transmit("Hello");
  delay(2000);
}
