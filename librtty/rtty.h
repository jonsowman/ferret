/*
  rtty.h
  A library for outputting RTTY signals
  
  CU Spaceflight 2010
*/

#ifndef rtty_h
#define rtty_h

#include "WProgram.h"
#include "types.h"

class RTTY {
  public:
    RTTY(int pin, int baud, float stopbits, checksum_type ctype);
    void transmit(char *str);
    unsigned int crc16(char *string);
    void setBaud(int baud);
    void setChecksum(checksum_type ctype);
  private:
    void _writeByte(char data);
    const int _pin;
    const float _stopbits;
    int _baud;
    checksum_type _ctype;
};

#endif
