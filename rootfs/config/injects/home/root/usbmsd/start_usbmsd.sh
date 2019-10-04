#!/bin/sh
#./create_disk_tiny.sh #keep this method for space-constrained systems
#for dev from SD card, just unzip
echo "Uncompressing filesystem image into /tmp..."
umount /tmp/usbmsd.disk &>/dev/null
gunzip -c usbmsd.disk.gz > /tmp/usbmsd.disk
modprobe g_mass_storage file=/tmp/usbmsd.disk ro=n iManufacturer=bcbuildr iProduct=usbtta iSerialNumber=0001

