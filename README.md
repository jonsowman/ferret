CU Spaceflight Ferret tracker  
=============================

A simple Arduino based high altitude balloon tracker using a GPS and a Radiometrix NTX2 narrowband FM transmitter module.  

Ferret and librtty are released under the terms of the GNU General Public License. They are distributed in the hope that they will be useful, but without any warranty; without even the implied warranty of merchantability or fitness for a particular purpose.  

Ferret One
---------

A radio tracker built in a few hours from an Arduino Duemilanove, an EM-406a GPS and a Radiometrix NTX2 narrowband FM transmitter on 434.650 MHz.  

Flew on Project Orion and CUSF launch Nova 18.  

Ferret Two
----------

A less hacky version using the TinyGPS Arduino library for talking to the GPS device, and using an FSA-03 GPS (uBlox 5 chipset).  

We use a [modified version of the TinyGPS library](http://ukhas.org.uk/_media/code:tinygps.zip?id=guides%3Afalcom_fsa03&cache=cache) that enables reporting number of satellites.

librtty
-------

This project also includes librtty [/ˈlɪbərti/], an Arduino library for generating an RTTY bitstream to be fed into an FM transmitter. Uses a potential divider on the Arduino output pin, providing the correct voltages to set the frequency shift.  

**Usage as follows**: call this line before setup():  
`RTTY rtty(radio_txd_pin, baud_rate, stop_bits, CHECKSUM_CRC16)`  

Then call the `transmit()` function with the string you wish to send, forex:  
`rtty.transmit("This is my string\r\n")`  

Please see the schematic in the `ferrettwo/` directory for details of how the hardware needs to be set up to make use of librtty.  

By [Adam Greig](http://github.com/randomskk) and [Jon Sowman](http://github.com/jonsowman) for [CU Spaceflight](http://www.cuspaceflight.co.uk) - 2010.  
