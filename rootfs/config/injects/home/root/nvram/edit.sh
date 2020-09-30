#!/bin/sh

source /bxb-board.conf
BXB_NVRAM_SHADOW
vi "$BXB_NVRAM_TMP"

echo "Run commit.sh to burn any changes or they will be lost!"
