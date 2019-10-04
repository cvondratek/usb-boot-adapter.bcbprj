#!/bin/sh
gzip -c /tmp/nvram > /sys/bus/i2c/devices/2-0050/eeprom
