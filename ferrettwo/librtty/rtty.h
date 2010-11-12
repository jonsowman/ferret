/*
  rtty.h
  A library for outputting RTTY signals
  
  CU Spaceflight 2010
*/

#ifndef rtty_h
#define rtty_h

#include "WProgram.h"

class RTTY {
  public:
    RTTY(int pin, int baud, float stopbits);
    void transmit(char *str);
  private:
    void _writeByte(char data);
    const int _pin;
    const float _stopbits;
    const int _baud;
};

#endif
