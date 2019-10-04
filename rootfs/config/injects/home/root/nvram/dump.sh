#!/bin/sh
cat /sys/bus/i2c/devices/2-0050/eeprom | gunzip -d
