#!/bin/sh

#this is called at boot by /etc/init.d/successful_boot... don't f-around here
echo "NVRAM DISABLED!!!"
#cat /sys/bus/i2c/devices/2-0050/eeprom | gunzip -d > /tmp/nvram.run
#sh /tmp/nvram.run

