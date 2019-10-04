#!/bin/sh

#creates a 64MB ramdisk, mounts it ro locally & exposes rw via g_mass_storage
dd if=/home/root/usbmsd/disk.64MB.vfat.mbr.img of=/tmp/usbmsd.disk count=512
dd if=/home/root/usbmsd/disk.xxMB.FAT.img of=/tmp/usbmsd.disk bs=1 seek=2048 count=16
dd if=/home/root/usbmsd/disk.xxMB.FAT.img of=/tmp/usbmsd.disk bs=1 seek=67584 count=16
dd if=/dev/zero of=/tmp/usbmsd.disk bs=1M count=63 seek=1

