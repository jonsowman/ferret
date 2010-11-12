# CU Spaceflight Ferret tracker  

A simple Arduino based high altitude balloon tracker using a GPS and a Radiometrix NTX2 narrowband FM transmitter module.  

## Ferret One

A radio tracker built in a few hours from an Arduino Duemilanove, an EM-406a GPS and a Radiometrix NTX2 narrowband FM transmitter on 434.650 MHz.  

Flew on Project Orion and CUSF launch Nova 18.  

## Ferret Two

A less hacky version using the TinyGPS Arduino library for talking to the GPS device, and using an FSA-03 GPS (uBlox 5 chipset).  

Credit to [James Coxon](http://github.com/jamescoxon) for his modified version of the TinyGPS library, to enable reporting satellite count.  

# librtty

This project also includes librtty, an Arduino library for transmitting RTTY. Uses a potential divider on the Arduino output pin, providing the correct voltages to the FM radio module to set the frequency shift.  

Usage as follows:  
`// RTTY rtty(radio_txd_pin, baud_rate, stop_bits)`  

Then call:  
`rtty.transmit("This is my string")`  

Please see the schematic in the `ferrettwo/` directory for details of how the hardware needs to be set up to make use of librtty.  

By [Adam Greig](http://github.com/randomskk) and [Jon Sowman](http://github.com/jonsowman) for [CU Spaceflight](http://www.cuspaceflight.co.uk) - 2010.  
