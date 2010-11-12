/*
  rtty.cpp
  A library for outputting RTTY signals
  
  CU Spaceflight 2010
*/

#include "WProgram.h"
#include "rtty.h"

RTTY::RTTY(int pin, int baud, float stopbits)
    : _pin(pin), _baud(baud), _stopbits(stopbits)
{
    // Set the radio TXD pin to output
    pinMode(pin, OUTPUT);
}

void RTTY::transmit(char *str) {
    // Transmit an input string over the radio
    int j=0;

    // Iterate through the string transmitting byte-by-byte
    while(str[j] != 0) {
        _writeByte(str[j]);
        j++;
    }
}

void RTTY::_writeByte(char data) {
    // Write a single byte to the radio ensuring it is padded
    // by the correct number of start/stop bits
    
    // Calculate the timestep in microseconds
    // We use two smaller delays instead of one larger as delayMicroseconds
    // is not accurate above ~16000uS, and the required delay is 20000uS
    // for 50 baud operation
    int timestep = (int)(500000/_baud);

    // Write the start bit
    digitalWrite(_pin, LOW);

    // We use delayMicroseconds as it is unaffected by Timer0, unlike delay()
    delayMicroseconds(timestep);
    delayMicroseconds(timestep);

    // Write the data byte
    int bit;
    for ( bit=0; bit<7; bit++ ) {
        if ( data & (1<<bit) ) {
            digitalWrite(_pin, HIGH);
        } else {
            digitalWrite(_pin, LOW);
        }
        delayMicroseconds(timestep);
        delayMicroseconds(timestep);
    }

    // Write the stop bit(s)
    digitalWrite(_pin, HIGH);
    delayMicroseconds((int)(timestep * _stopbits));
    delayMicroseconds((int)(timestep * _stopbits));
}
