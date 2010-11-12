/*
  rtty.cpp
  A library for outputting RTTY signals
  
  CU Spaceflight 2010
*/

#include "WProgram.h"
#include "rtty.h"


RTTY::RTTY(int pin, int baud, int shift, float stopbits) {
    // Constructor function sets the radio TXD to output
    // and sets the PWM timer to 64 kHz for pins 5 and 6
    _pin = pin;
    _highval = 120;
    _lowval = getLowVal(_highval, shift);
    _shift = shift;
    _stopbits = stopbits;
    _baud = baud;
    pinMode(pin, OUTPUT);

}

void RTTY::transmit(char *str) {
    // Set the PWM frequency to 62.5 kHz
    TCCR0B = TCCR0B & 0b11111000 | 0x01;

    // Small delay to let the new frequency settle or something
    delay(1000);

    // Transmit an input string over the radio
    int j=0;

    while(str[j] != 0) {
        writeByte(str[j]);
        j++;
    }

    // Set the PWM frequency to 1 kHz
    TCCR0B = TCCR0B & 0b11111000 | 0x03;
}

void RTTY::writeByte(char data) {
    // Write a single byte to the radio ensuring it is padded
    // by the correct number of start/stop bits
    byte mask;
    int timestep;

    timestep = (int)(62500/_baud);

    // Write the start bit
    analogWrite(_pin, _lowval);
    delay(timestep);

    // Write the data byte
    for (mask = 0x01; mask <=(1<<6); mask <<= 1) {
        if ( data & mask ) {
            analogWrite(_pin, _highval);
        } else {
            analogWrite(_pin, _lowval);
        }
        delay(timestep);
    }

    // Write the stop bit(s)
    analogWrite(_pin, _highval);
    delay((int)(timestep * _stopbits));
}

int RTTY::getLowVal(int highval, int shift) {
    // Get the lower 8-bit PWM value for a given higher
    // value and a required shift
    float mult = 11.0/350.0;
    return (int)(highval - (mult*shift));
}

