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
    RTTY(int pin, int baud, int shift, float stopbits);
    void transmit(char *str);
    void writeByte(char data);
  private:
    int getLowVal(int highval, int shift);
    int _pin;
    int _highval;
    int _lowval;
    int _shift;
    float _stopbits;
    int _baud;
};

#endif
