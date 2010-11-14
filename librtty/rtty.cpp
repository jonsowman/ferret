/*
  rtty.cpp
  A library for outputting RTTY signals
  
  CU Spaceflight 2010
*/

#include "WProgram.h"
#include "util/crc16.h"
#include "types.h"
#include "rtty.h"

RTTY::RTTY(int pin, int baud, float stopbits, checksum_type ctype)
    : _pin(pin), _baud(baud), _stopbits(stopbits), _ctype(ctype)
{
    // Set the radio TXD pin to output
    pinMode(pin, OUTPUT);
}

void RTTY::transmit(char *str) {
    // Transmit an input string over the radio
    int j=0;
    unsigned int checksum;
    char checksum_string[6];

    // First we calculate a checksum if required and append it to the
    // transmit string if so
    switch(_ctype) {
        case CHECKSUM_CRC16:
            checksum = _crc16(str);
            sprintf(checksum_string, "*%04X", checksum);
            strcat(str, checksum_string);
            break;
        case CHECKSUM_NONE:
            break;
        default:
            break;
    }

    // Then we automatically append a newline
    strcat(str, "\n");
    
    // Calculate the timestep in microseconds
    // We use two smaller delays instead of one larger as delayMicroseconds
    // is not accurate above ~16000uS, and the required delay is 20000uS
    // for 50 baud operation
    //
    // We calculate the timestep here so that changing the baudrate with
    // setBaud() during transmission of a string doesn't break things
    //
    int timestep = (int)(500000/_baud);

    // Iterate through the string transmitting byte-by-byte
    while(str[j] != 0) {
        _writeByte(str[j], timestep);
        j++;
    }
}

void RTTY::_writeByte(char data, int timestep) {
    // Write a single byte to the radio ensuring it is padded
    // by the correct number of start/stop bits
    
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

unsigned int RTTY::_crc16(char *string) {
    // Returns the CRC16_CCITT checksum for the input string

    unsigned int i;
    unsigned int crc;

    // CCITT uses 0xFFFF as the initial CRC value
    crc = 0xFFFF;

    // Iterate through the string updating the checksum byte-by-byte
    for( i=0; i < strlen(string); i++ ) {
        crc = _crc_xmodem_update(crc, (uint8_t)(string[i]));
    }

    return crc;
}

void RTTY::setBaud(int newbaud) {
    // Set the RTTY baud rate to a new one, can be called at any time
    _baud = newbaud;
}

void RTTY::setChecksum(checksum_type ctype) {
    // Change the checksum type appended to the transmit string
    _ctype = ctype;
}


