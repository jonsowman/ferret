/*
  rtty.h
  A library for outputting RTTY signals
  
  CU Spaceflight 2010
*/

// Include the required libraries for Ferret
#include <TinyGPS.h>
#include <NewSoftSerial.h>
#include <rtty.h>

#define GPS_RX 2
#define GPS_TX 3

char callsign[7] = "FERRET";

// Set up a software serial connection to the GPS device
NewSoftSerial ss(GPS_RX, GPS_TX);

// Set up a TinyGPS instance for the GPS device
TinyGPS gps;

// Initialise variables for the operating loop
float lat, lon, alt;
long unsigned int ticks, fix_age;
int year, month, day, hour, minute, second, hundredths, sats;
char buffer[200];

void setup() {
  // Set the baud rate for the GPS device
  ss.begin(4800);
  
  // Open a serial terminal connection for debug output
  Serial.begin(115200);
  Serial.println("Setup complete...");
}

void loop() {
  if( ss.available() ) {
    
      // Get information from the GPS
      gps.f_get_position(&lat, &lon, &fix_age);
      gps.crack_datetime(&year, &month, &day, &hour, 
        &minute, &second, &hundredths, &fix_age);
      alt = gps.f_altitude();
      sats = gps.sats();
      
      // Check we have a valid fix
      if( fix_age == TinyGPS::GPS_INVALID_AGE ) {
        Serial.println("No fix");
      } else if ( fix_age > 5000 ) {
        Serial.println("Old fix");
      } else {
        Serial.println("Got fix!");
      }
      
      // Construct a string to send
      int n = sprintf(buffer, "$$%s,%u,%u:%u:%u,%.4f,%.4f,%.0f,%u", 
      callsign, ticks, hour, minute, second, lat, lon, alt, sats);
      
      // Send the string to the serial terminal
      Serial.println(buffer);
      
  } else {
    Serial.println("The GPS device could not be accessed.");
  }
  ticks++;
  delay(1000);
}
