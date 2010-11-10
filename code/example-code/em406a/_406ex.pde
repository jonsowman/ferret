//Created August 15 2006
//Heather Dewey-Hagborg
//http://www.arduino.cc
//reworked to GPS reader
//Dirk, december 2006

#include <ctype.h>
#include <string.h>

#define bit4800Delay 192
#define halfBit4800Delay 96

byte rx = 2;
byte tx = 4;
byte SWval;
char dataformat[7] = "$GPRMC";
char messageline[80] = "";
int i= 0;

void setup() {
  pinMode(rx,INPUT);
  pinMode(tx,OUTPUT);
  digitalWrite(tx,HIGH);
  digitalWrite(13,HIGH); //turn on debugging LED
  SWprint('h');  //debugging hello
  SWprint('i');
  SWprint(10); //carriage return
  Serial.begin(115200);
}

void SWprint(int data)
{
  byte mask;
  //startbit
  digitalWrite(tx,LOW);
  delayMicroseconds(bit4800Delay);
  for (mask = 0x01; mask>0; mask <<= 1) {
    if (data & mask){ // choose bit
	digitalWrite(tx,HIGH); // send 1
    }
    else{
	digitalWrite(tx,LOW); // send 0
    }
    delayMicroseconds(bit4800Delay);
  }
  //stop bit
  digitalWrite(tx, HIGH);
  delayMicroseconds(bit4800Delay);
}

char SWread()
{
  byte val = 0;
  while (digitalRead(rx));
  //wait for start bit
  if (digitalRead(rx) == LOW) {
    delayMicroseconds(halfBit4800Delay);
    for (int offset = 0; offset < 8; offset++) {
	delayMicroseconds(bit4800Delay);
	val |= digitalRead(rx) << offset;
    }
    //wait for stop bit + extra
    delayMicroseconds(bit4800Delay);
    delayMicroseconds(bit4800Delay);
    //return val & 0x7f;
    return val;
  }
}
void char2string()
{
  i = 0;
  messageline[0] = SWread();
  if (messageline[0] == 36) //string starts with $
  {
    i++;
    messageline[i] = SWread();
    while(messageline[i] != 13 & i<80) //carriage return or max size
    {
	i++;
	messageline[i] = SWread();
    }
    messageline[i+1] = 0; //make end to string
  }
}
void loop()
{
  char nnew = SWread();
  Serial.print(nnew); //use this to get all GPS output, comment out from char2string till here

}
 


