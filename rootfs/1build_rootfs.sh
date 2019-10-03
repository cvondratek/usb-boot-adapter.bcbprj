#!/bin/bash

#call from within build directory!

cd $BUILD_BASE/rootfs/arago/build && \
source conf/setenv && \
TOOLCHAIN_PATH=/opt/toolchains/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf/bin/arm-linux-gnueabihf- MACHINE=am335x-bcmax bitbake core-image-minimal
echo ""
cd $CONFIG_BASE/staging
rm -rf $CONFIG_BASE/staging/rootfs
mkdir -p $CONFIG_BASE/staging/rootfs
cd $CONFIG_BASE/staging/rootfs
IMG_PATH=$BUILD_BASE/rootfs/arago/build/arago-tmp-glibc/deploy/images/am335x-bcmax
tar xf $IMG_PATH/core-image-minimal-am335x-bcmax.tar.xz

#if using yocto kernel:
#tar xf $IMG_PATH/modules-am335x-bcmax.tgz
#cp     $IMG_PATH/zImage ..
#cp     $IMG_PATH/am335x-boneblack.dtb ..


