#!/bin/sh

#############################################################
# cvondratek soft-AP script
#
# ->see $HOSTAPD_CONF (below) for softAP config
#
#############################################################
# script config
IF_WIFI='wlan0'
UDHCPD_PID_FILE='/var/run/udhcpd_softap.pid'
UDHCPD_CONF='/home/root/wifi/udhcpd_softap.conf'
HOSTAPD_LOG='/tmp/hostapd.log'
HOSTAPD_CONF='/home/root/wifi/hostapd.conf'

# STATUS LED
LED='/sys/class/leds/lhs'

#default all wifi LEDs to off
echo none > ${LED}_red/trigger
echo none > ${LED}_green/trigger
echo none > ${LED}_blue/trigger


#CLEAN-SLATE
#==================================================================
#1. kill all udhcpd & hostapd from previous runs of this script
killall -q hostapd
killall -q udhcpd ${UDHCPD_CONF}

#2. nuke dhcp client, but only on this interface
killall -q udhcpc -i ${IF_WIFI}

#3. whack any remaining client stuff
killall -q wpa_supplicant
killall -q wpa_cli
#drop interface & wait for dust to settle
ifconfig $IF_WIFI down
sleep 1

#soft AP setup
#=================================================================
# Step 1: Setup wifi interface with static ip & dhcp service
ifconfig $IF_WIFI 169.254.254.1 up
udhcpd ${UDHCPD_CONF}
sleep 3
# Step 2: Start hostapd
/sbin/hostapd -B ${HOSTAPD_CONF} 1> ${HOSTAPD_LOG}

#misc
echo phy0tx > ${LED}_blue/trigger
echo phy0rx > ${LED}_green/trigger


