#!/bin/bash

# BxB board-specific methods
#  >source this file ahead of any calls to the bxb apps

# board name acronyms
# =====================
# BBB - BeagleBoneBlack
# BCM - BeagleCloneMax
# BCP - BeagleClonePico
# BXB - generic class of boards based on BBB / TI AM335 SoC

BXB_BOARD="BBB"

# specify where nvram is implemented in HW, examples:
# BCB - /sys/bus/i2c/devices/2-0050/eeprom	# bcmax eeprom on i2c2, rw by default
# BBB - /dev/mmcblk1p1/nvram_file		# use file nvram on filesystem @ /dev/mmcblk1p1
# BBB - /sys/bus/i2c/devices/0-0050/eeprom	# ro, requires eeprom WP pull-down rework 
BXB_NVRAM_DIRDEV="/dev/mmcblk1p1"
BXB_NVRAM_NAME="nvram"
export BXB_NVRAM_TMP="/tmp/nvram.shadow"

# helper methods for unpacking device/file strings
BXB_GET_FILENAME() {
	echo $1 | sed "s#$(dirname $1)/##g"
}

BXB_GET_DIRECTORY() {
	dirname $1
}

# Method to shadow nvram image from HW
BXB_NVRAM_SHADOW() {
	if [ $BXB_NVRAM_NAME  == "eeprom" ]; then
		cat "$BXB_NVRAM_LOCATION" | gunzip -d > "$BXB_NVRAM_TMP"
	else
		mount -o ro "$BXB_NVRAM_DIRDEV" /mnt/emmc
		if [ -f /mnt/emmc/$BXB_NVRAM_NAME ]; then
			cp /mnt/emmc/$BXB_NVRAM_NAME "$BXB_NVRAM_TMP"
		else
			echo "$BXB_NVRAM_NAME not found on $BXB_NVRAM_DIRDEV. Try BXB_NVRAM_INITIALIZE & BXB_NVRAM_COMMIT"
		fi
		umount /mnt/emmc
	fi
}

BXB_NVRAM_INITIALIZE() {
	rm -f "$BXB_NVRAM_TMP" && touch "$BXB_NVRAM_TMP"
}

BXB_NVRAM_COMMIT() {
	if [ $BXB_NVRAM_NAME  == "eeprom" ]; then
		gzip -c "$BXB_NVRAM_TMP" > "$BXB_NVRAM_LOCATION" 
	else
		mount -o rw "$BXB_NVRAM_DIRDEV" /mnt/emmc
		cp "$BXB_NVRAM_TMP" /mnt/emmc/"$BXB_NVRAM_NAME"
		umount /mnt/emmc
	fi
}
