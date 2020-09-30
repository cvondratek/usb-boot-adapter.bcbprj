#!/bin/sh

source /bxb-board.conf
BXB_NVRAM_SHADOW
cat "$BXB_NVRAM_TMP"
