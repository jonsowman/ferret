// MODIFIED BY JON SOWMAN
// DELAYMICROSECONDS() DOES NOT DISABLE
// INTERRUPTS ANY MORE, SO DO IT
// MANUALLY

#include <WString.h>
#include <ctype.h>
#include <string.h>

#define bit4800Delay 192
#define halfBit4800Delay 96

int count=0;
int i=0;
long ticks=0;
int ledPin = 13;    // LED connected to digital pin 13
char GPSstring[200]; // serial string received from GPS
char Radiostring[200]; // string to output via radio
char SSinByte;   // byte read in via software serial
byte GPSoutput = 2; // GPS TX pin
byte GPSinput = 4;  // GPS RX pin
byte Radio = 6;   // Radio signal pin
char dataformat[6] = "GPGGA";  // start of GPS string to recognise
int alt; // altitude integer
float lat; // latitude
float lon; // longitude
float GPStime;  //GPS time only to seconds
int sats; // number of satellites
float stopbits = 1.0;

int tx = 4;
int rx = 2;




void setup()                    // run once, when the sketch starts
{

 pinMode(ledPin, OUTPUT);      // sets the digital pin as output
 pinMode(GPSoutput, INPUT);            // sets GPS input
 pinMode(GPSinput,OUTPUT);            // sets GPS output
 pinMode(Radio,OUTPUT);

 //digitalWrite(GPSinput,HIGH);

 Serial.begin(115200);           // begin serial ouput to computer at bps rate
 Serial.println("Program has begun!!");

 digitalWrite(GPSinput, HIGH);

 char SSinByte = SWread();
 while (SSinByte != '$'){
   char SSinByte = SWread();

   //Serial.print(SSinByte);
   if (SSinByte== '$'){
     break ; }
   }

 //// CODE TO SET PWM FREQUENCY HIGHER - TO 64kHz
  TCCR0B = TCCR0B & 0b11111000 | 0x01;

Serial.print("here we go...   ");

}

void loop()                     // run over and over again
{
 while (1){
   
   cli();
   //TCCR0B = TCCR0B & 0b11111000 | 0x03;

    count=0;
    ticks = ticks + 1;
    digitalWrite(ledPin, HIGH); // flash to show working

    //first loop to get to $ start
   while (SSinByte != '$'){
     char SSinByte = SWread();
     
     if (SSinByte== '$'){
         break ; }
   }
      SSinByte='p'; // change from previous $ character


      // now record GPS string
     while (SSinByte != '$'){

       char SSinByte = SWread();
      // Serial.print(SSinByte); //!!!!!
      
       if (SSinByte == '$'){
         //Serial.print(GPSstring); //print the old string if a new one is incoming !!!!!!!!!!
         //Serial.print(13,10);
         break;
       }
       
       GPSstring[count] = SSinByte;
       Serial.print(SSinByte);
       count++;
     }
     
     sei();
     
     //TCCR0B = TCCR0B & 0b11111000 | 0x01;


   // Compare GPS string and get values from it
   if (strncmp(GPSstring, dataformat, 5) == 0 && count>4) {
     
     //Serial.println("got a match");

     //output string for comparison
     //for (int k=0; k<count+1;k++)
       //Serial.print(GPSstring[k]);
     //Serial.println();

     char * pch;
     pch = strtok (GPSstring,",");
     i=0;
     while (pch != NULL)
     {
       pch = strtok (NULL, ",");
       if (i==0){
         GPStime = strtod(pch,NULL);
         //Serial.println(GPStime);
       }
       if (i==1) {                         // if clauses to choose part of string
         float rawlat = strtod(pch,NULL);
         lat = (int)(rawlat/100);
         lat += (rawlat - lat*100)/60;
       }
       if (i==2 && *pch=='S') {lat=-lat;}
       if (i==3) {
          float rawlon = strtod(pch,NULL);
          lon = (int)(rawlon/100);
          lon += (rawlon - lon*100)/60;
       }
       if (i==4 && *pch=='W') { lon=-lon;}
       if (i==6) { sats=(int) (strtod(pch,NULL));}
       if (i==8) { alt=(int) (strtod(pch,NULL));}
     i++;
     }

   // compose and send the radio string, converting floats to ints for printf
   int latst= (int) lat;
   int latend= (lat- latst)*10000;
   int lonst= (int) lon;
   int lonend= (lon- lonst)*10000;
   int GPShr = (int) (GPStime/10000)  +  1;   // here for british summertime !!
   int GPSmin = (int) ((GPStime/100-(GPShr-1)*100)) ;  // here for british summertime !!
   int GPSsec = (int) (GPStime-(GPShr-1)*10000-GPSmin*100); // herefor british summertime !!

  sprintf(Radiostring,"$$ORION,%lu,%02u:%02u:%02u,%d.%04u,%d.%04u,%d,%u\n",ticks,GPShr,GPSmin,GPSsec,latst,latend,lonst,lonend,alt,sats);
   
   writestring(Radio,Radiostring,120,109,50,1); //!!!!!!!!!!!!!
  
   
   //Serial.print(Radiostring);
  
   //delay a second before next string
   for(int p=0; p<1000; p++)
      delay(64);

    digitalWrite(ledPin,LOW);  // blink LED pin 13
  }
 }
}


void SSerialwrite(int pin_no, char data, int highval, int lowval, int baud, float stopbit)
{
 byte mask;
 int timestep; // in milliseconds

 // now 64000 not 1000 due to the increased clock rate
 timestep=(int) (64000/baud);

 //startbit
 analogWrite(pin_no,lowval);
 delay(timestep);
 for (mask = 0x01; mask<=(1<<6); mask <<= 1) {
   if (data & mask){ // choose bit
    analogWrite(pin_no,highval); // send high value
   }
   else{
    analogWrite(pin_no,lowval); // send low value
   }
   delay(timestep);
 }
 //stop bit
 analogWrite(pin_no, highval);
 delay((int) (timestep*stopbit));
}


char SSerialread(int pin_no,int baud, float stopbit)
{
 byte val = 0;
 int timestep = 64000000/baud - 20*64; // in microseconds
 //int timestep=(int) (64000/baud);

 while (digitalRead(pin_no));
 //wait for start bit
 if (digitalRead(pin_no) == LOW) {
   delayMicroseconds((int) (timestep/2));

   //start reading
   for (int offset = 0; offset < 8; offset++) {
    delayMicroseconds(timestep);
    val |= digitalRead(pin_no) << offset;
   }
   //wait for stop bit
   delayMicroseconds((int)(timestep*stopbit));
   return val;
   //return val & 0x7f;
 }

}

void writestring(int pin_no,char *str, int highval, int lowval, int baud, float stopbit)
{
 int j=0;

 while (str[j] != 0){
   SSerialwrite(pin_no, str[j], highval, lowval, baud, stopbit);
   j++;
 }

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
