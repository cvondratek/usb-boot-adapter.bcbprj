#!/bin/sh
echo "Stopping g_mass_storage..."
modprobe -r g_mass_storage
mount -o loop /tmp/usbmsd.disk /mnt/loop
echo "Done. Image mounted at /mnt/loop."
echo "Don't forget to umount it when you're done. :]"

