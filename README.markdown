# CU Spaceflight Ferret tracker  

A simple Arduino based high altitude balloon tracker using a GPS and a Radiometrix NTX2 narrowband FM transmitter module.  

## Version One

A radio tracker built in a few hours from an Arduino Duemilanove, an EM-406a GPS and a Radiometrix NTX2 narrowband FM transmitter on 434.650 MHz.  

Flew on Project Orion and CUSF launch Nova 18.  

## Version Two

A less hacky version using the TinyGPS Arduino library for talking to the GPS device, and using an FSA-03 GPS (uBlox 5 chipset).  

Also includes librtty, an Arduino library for transmitting RTTY. Uses a potential divider on the Arduino output pin, providing the correct voltages to the FM radio module to set the frequency shift.  

Credit to [James Coxon](http://github.com/jamescoxon) for his modified version of the TinyGPS library, to enable reporting satellite count.  

By [Adam Greig](http://github.com/randomskk) and [Jon Sowman](http://github.com/jonsowman) for [CU Spaceflight](http://www.cuspaceflight.co.uk) - 2010.  
