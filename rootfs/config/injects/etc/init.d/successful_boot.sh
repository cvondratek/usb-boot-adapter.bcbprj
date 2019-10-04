#!/bin/sh

#This script updates LEDs & resets the boot-loop counter.  It should be the last script to run in rcS

#update LEDs to indicate we've booted successfully
echo none > /sys/class/leds/lhs_red/trigger
echo default-on > /sys/class/leds/lhs_green/trigger
echo none > /sys/class/leds/lhs_blue/trigger
echo none > /sys/class/leds/mid_red/trigger
echo none > /sys/class/leds/mid_green/trigger
echo usb-gadget > /sys/class/leds/mid_blue/trigger
echo none > /sys/class/leds/rhs_red/trigger
echo none > /sys/class/leds/rhs_green/trigger
echo none > /sys/class/leds/rhs_blue/trigger

#pull nvram script from i2c eeprom & run it
/home/root/nvram/run.sh&

#DON'T BLOCK!
