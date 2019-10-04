#!/bin/sh

cat /sys/bus/i2c/devices/2-0050/eeprom | gunzip -d > /tmp/nvram
vi /tmp/nvram
echo "Run commit.sh to burn any changes or they will be lost!"
