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

We use a [modified version of the TinyGPS library](https://github.com/downloads/jonsowman/ferret/tinygps.tgz) that enables reporting number of satellites.

Please see the schematic in the `ferrettwo/` directory for details of how the hardware needs to be set up to make use of librtty.  

By [Adam Greig](http://github.com/adamgreig) and [Jon Sowman](http://github.com/jonsowman) for [CU Spaceflight](http://www.cuspaceflight.co.uk) - 2010.  
