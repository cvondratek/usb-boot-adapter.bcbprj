#!/bin/sh

OVERLAY_CHK=$(mount | grep overlay)
if [ -n "$OVERLAY_CHK" ]; then
	echo "Cannot initialize card that's currently mounted with overlay"
	echo "Reboot with BAD_CARD flag set and try again"
	exit 1
fi


if [ -b /dev/mmcblk0 ]; then
	echo "This will destroy everything on /dev/mmcblk0 and format the card for BC-overlay."
	read -n1 -r -p "Press Y to continue or anything else to abort." key
	if [ "$key" = 'Y' ]; then
		umount /dev/mmcblk0p1
		umount /dev/mmcblk0p2
		umount /dev/mmcblk0p3
		umount /dev/mmcblk0p4
		dd if=/dev/zero of=/dev/mmcblk0 bs=1024 count=1024
		sfdisk -D -H 255 -S 63 /dev/mmcblk0 << EOF
,,,-
EOF
		mkfs.ext3 /dev/mmcblk0p1

		mount /dev/mmcblk0p1 /mnt/mmc
		mkdir /mnt/mmc/overlay
		mkdir /mnt/mmc/overlay/var/
		mkdir /mnt/mmc/overlay/var/lib
		mkdir /mnt/mmc/overlay/var/lib/opkg
		mkdir /mnt/mmc/work
		sync
		umount /dev/mmcblk0p1
		echo "Done!"
	else
		echo "Aborted."
	fi
fi

