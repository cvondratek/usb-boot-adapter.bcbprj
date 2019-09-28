#!/bin/bash

#call from within build directory!

cd /dev/shm/rootfs/arago/build && \
source conf/setenv && \
TOOLCHAIN_PATH=/opt/toolchains/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf/bin/arm-linux-gnueabihf- MACHINE=am335x-bcmax bitbake core-image-minimal


cd /workdir/rootfs/
rm -rf /workdir/rootfs/staging
mkdir -p /workdir/rootfs/staging
cd /workdir/rootfs/staging

tar xf $OLDPWD/../arago/build/arago-tmp-glibc/deploy/images/am335x-bcmax/core-image-minimal-am335x-bcmax.tar.xz
tar xf $OLDPWD/../arago/build/arago-tmp-glibc/deploy/images/am335x-bcmax/modules-am335x-bcmax.tgz
cp     $OLDPWD/../arago/build/arago-tmp-glibc/deploy/images/am335x-bcmax/zImage ..
cp     $OLDPWD/../arago/build/arago-tmp-glibc/deploy/images/am335x-bcmax/am335x-bcmax.dtb ..


