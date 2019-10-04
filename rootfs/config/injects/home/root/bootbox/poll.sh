#!/bin/sh
source ./config.src

while :
do
	echo default-on > /sys/class/leds/lhs_blue/trigger
	echo none > /sys/class/leds/lhs_green/trigger

	echo "Polling for $WATCH..."
	mount -o ro,loop $DISK $MOUNT
	if [ -f $WATCH ]; then
		modprobe -r g_mass_storage

		echo "Triggered by appearance of $MOUNT/$WATCH"
		if [ -f $MOUNT/run.sh ]; then
			echo "Executing custom runner..."
			cp $MOUNT/run.sh /tmp
			sh /tmp/run.sh&
		else
			echo "Executing default runner..."
			sh ./runner.sh&
		fi
		umount $DISK
		exit;
	fi

	umount $DISK
	sleep 1
	#change flash to indicate cycle
	echo none > /sys/class/leds/lhs_blue/trigger
	echo default-on > /sys/class/leds/lhs_green/trigger
	sleep 3
done

