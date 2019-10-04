#!/bin/sh
#############################################################
echo "cvondratek wifi client script"
#############################################################

#config file location
CFG_FILE="/tmp/wpa_supplicant.conf"

# Wifi interface definition
IF_WIFI='wlan0'

#udhcpc cmd
UDHCPC_CMD="/sbin/udhcpc -i ${IF_WIFI}&"
echo $UDHCPC_CMD

# WIFI STATUS LED
LED='/sys/class/leds/rhs_blue'

# Clean-up after any previous runs of this script
ifconfig ${IF_WIFI} down
killall -q wpa_supplicant
killall -q wpa_cli
killall -q udhcpc

#dust->settle
sleep 1

#default wifi LED to off
echo none > ${LED}/trigger

# Step 1: See if we have a valid wifi.conf & if not create it
if [ ! -f "$CFG_FILE" ]; then
	echo "Enter SSID of the wifi network you want to connect to:"
	read ssid
	echo "Enter the passphrase:"
	read pass
	echo "Creating wifi.conf..."
	echo "ctrl_interface=/var/run/wpa_supplicant"
	echo "update_config=1" > $CFG_FILE
	echo "fast_reauth=1" >> $CFG_FILE
	echo "ap_scan=1" >> $CFG_FILE
	echo "network={" >> $CFG_FILE
	echo "	ssid=\"${ssid}\"" >> $CFG_FILE
	echo "	psk=\"${pass}\"" >> $CFG_FILE
	echo "}" >> $CFG_FILE
fi

# Step 2: Start wpa_supplicant & wpa_cli monitor
wpa_supplicant -i ${IF_WIFI} -B -c ${CFG_FILE}

# Step 3: Make a callback file to run udhcpc when we're connected...
CLIENT_CB='/tmp/wifi_client-cb.sh'
echo "#!/bin/sh" > $CLIENT_CB
echo "${UDHCPC_CMD}" >> $CLIENT_CB
chmod +x $CLIENT_CB
wpa_cli -Ba $CLIENT_CB
