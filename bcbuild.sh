#!/bin/bash
ME="usb-boot-adapter.bcbprj/bcbuild.sh"
echo "$ME: Running rootfs build in 5 seconds (ctrl-c to bail)"
sleep 5
cd rootfs
./1build_rootfs.sh && ./2trim-deploy_rootfs.sh
echo "I'm done. Here's a shell."
/bin/bash
