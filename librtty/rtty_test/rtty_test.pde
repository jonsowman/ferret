#include <rtty.h>

// Initialise RTTY output
// Pin, baud, stopbits, checktype type
RTTY rtty(6, 50, 1.5, CHECKSUM_NONE);

// Make sure the transmit string buffer is long enough
char radiostring[200];
char call[6] = "APEX";

void setup() {
  rtty.setBaud(50);
  rtty.setChecksum(CHECKSUM_CRC16);
}

void loop() {
  sprintf(radiostring, "$$%s,24,06:11:14,5212.8929,00005.8207,18,000,000,07,15.75,15.13,D1A,984,0000,0000,F8A85B6F2,25", call);
  rtty.transmit(radiostring);
  delay(2500);
}
