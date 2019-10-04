#!/bin/sh

CONN_STATE=$(wpa_cli status | grep "wpa_state=COMPLETED")

#if grep return string is null (eg: no match)
if [ -z $CONN_STATE ]; then
        echo "Not connected"
        echo heartbeat > /sys/class/leds/lhs_red/trigger
        echo none > /sys/class/leds/lhs_green/trigger
        echo none > /sys/class/leds/lhs_blue/trigger
else
        echo "Connected"
        echo none > /sys/class/leds/lhs_red/trigger
        echo phy0rx > /sys/class/leds/lhs_green/trigger
        echo phy0tx > /sys/class/leds/lhs_blue/trigger
fi
