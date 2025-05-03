I have no idea what I'm doing here - but I'm having fun. These are recorded from a very basic 2008 LandCruiser **MS-BUS**. The MS-BUS does not contain a lot of ECUs on our vehicle, but it's likely these CAN bus Ids map across to other networks.

**0x2C4** - RPM, Throttle body position. Unsure about - some sort of temperature field?
**0x3A1** - Maybe coolant temp? not sure
**0x3B0** - Outside air temp
**0x3B1** - I think this is various dash lights like airbag, check engine, a/t temp, alternator - but hard to know which ones are which 
**0x3B4** - gear selector, brake, cruise control on/off, 2nd start, ect pwr, sports gear
**0x610** - speed
**0x611** - odometer
**0x638** - door locked status
**0x620** - ignition setting, foot brake, hand brake, door open sensors

### Some things I found on the net that probably align
- https://www.hackster.io/rajeevvelikkal/biometric-car-entry-true-keyless-car-298928
 - 621 - 638 - probably all door/key/lock related
- https://canhacker.com/examples/lexus-lx570-2016/
- headlight - different bus - https://canhacker.com/lexus-lx570-headlight-on-via-can-bus/
- maybe useful for other buses - https://github.com/timurrrr/ft86/blob/main/can_bus/gen1.md

### Things I'm probably doing wrong
- Running a dissector for each arbitration id
- Not making a tree for the different bytes / bit fields so that the bit fields display grouped together
- Making a raw field
- Pretty much everything else