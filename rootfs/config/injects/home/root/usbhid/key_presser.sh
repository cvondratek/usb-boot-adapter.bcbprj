#!/bin/bash
# Bash file to test the gadget by writing "Hello World!"

function write_report {
    echo -ne $1 > /dev/hidg0
}

function spacebar_tap {

	#SPACE
	write_report "\0\0\x2c\0\0\0\0\0"
	# release keys
	write_report "\0\0\0\0\0\0\0\0"
}

if [ ! -d /sys/kernel/config/usb_gadget/mykeyboard/ ]; then
	/home/root/usbhid/start_kybd.sh
fi;

while :
do
	spacebar_tap
	SLEEPTIME=$(($RANDOM % 100 + 10))
	sleep $SLEEPTIME
done
