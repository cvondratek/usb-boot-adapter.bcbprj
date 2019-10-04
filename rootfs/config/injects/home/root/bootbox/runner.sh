#!/bin/sh
source ./config.src

#called by polling script, which has detected "TEST" in the disk & already removed g_mass_storage for us
#we mount the disk, run the test, and return with results

#echo none > /sys/class/leds/mid_green/trigger
#echo timer > /sys/class/leds/mid_blue/trigger
#echo timer > /sys/class/leds/mid_red/trigger

echo "Running boot..."

umount $DISK &>/dev/null
sleep 3

echo "Building boot disk..."
mount -o loop $DISK $MOUNT
mkdir -p $MOUNT/BOOT/EFI
if [ ! -f /$MOUNT/BOOT/EFI/grub_x86_64.efi ]; then
	mount /dev/mmcblk0 /mnt/mmc
	cp /mnt/mmc/grub_x86_64.efi $MOUNT/BOOT/EFI/grub_x86_64.efi
	cp /mnt/mmc/grub.cfg $MOUNT/BOOT/EFI/grub.cfg
	umount /dev/mmcblk0
fi;
mv $WATCH $MOUNT
sync
#we expect sync actually working here... :)

echo "Enabling g_mass_storage..."
modprobe g_mass_storage file=$DISK ro=y iManufacturer=Vanilla iProduct=FlashKey iSerialNumber=1234

#prep UART snarf
if [ -e /dev/ttyUSB0 ]; then
	stty -F /dev/ttyUSB0 cs8 -parenb -cstopb -clocal -echo 115200
	dd if=/dev/ttyUSB0 of=/tmp/tty.out bs=1 count=1M&
fi;

#enable DUT power here
$DUT_PWR_ON

echo "Waiting for DUT to boot..."
sleep 15
#todo- little c app that sucks tty output, OR returns -1 if nothing is detected

#power-off
$DUT_PWR_OFF

#clean-up UART snarf
killall dd

echo "Cleaning-up... "
modprobe -r g_mass_storage
mv $MOUNT/zephyr.elf $MOUNT/zephyr.elf.DONE

#copy serial output back to usb disk here
if [ -f /tmp/tty.out ]; then
	cp /tmp/tty.out $MOUNT/RESULTS
else
	echo "UART UNAVAILABLE" > $MOUNT/RESULTS
fi
sync

umount $DISK
sleep 1

echo "Starting g_mass_storage in config mode"
modprobe g_mass_storage file=$DISK ro=n iManufacturer=bcbuildr iProduct=usbbootadapter iSerialNumber=0001

echo "Back to poll mode..."
./poll.sh&

#echo default-on > /sys/class/leds/mid_green/trigger
#echo none > /sys/class/leds/mid_blue/trigger
#echo none > /sys/class/leds/mid_red/trigger

exit
