#!/bin/sh

#this is called at boot by /etc/init.d/successful_boot
source /bxb-lib.sh
BXB_NVRAM_SHADOW
sh "$BXB_NVRAM_TMP"

