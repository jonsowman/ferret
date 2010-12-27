/*
   rtty.h
   Copyright Jon Sowman 2010

   This file is part of the Ferret/librtty project, an Arduino based
   high altitude balloon tracker, and an Arduino library for generating
   an RTTY bitstream.

   CU Spaceflight 2010
   http://www.cuspaceflight.co.uk
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
