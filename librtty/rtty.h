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
    void setBaud(int baud);
    int getBaud();
    void setChecksum(checksum_type ctype);
    checksum_type getChecksum();
  private:
    void _writeByte(char data);
    unsigned int _crc16(char *string);
    const int _pin;
    const float _stopbits;
    int _timestep;
    checksum_type _ctype;
};

#endif
