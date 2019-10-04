#!/bin/sh

cd /home/root/bootbox
source ./config.src

echo "Cleaning-up & creating disk..."
umount $DISK
modprobe -r g_mass_storage
/home/root/usbmsd/create_disk.sh
sleep 3

echo "Starting poll loop..."
./poll.sh&

