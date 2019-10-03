#!/bin/bash
ME="usb-boot-adapter.bcbprj/bcbuild.sh"
#
# master build executor for usb-boot-adapter.bcbprj
#   todo: parameterize, please

export CONFIG_BASE=$PWD #/workdir the container
export BUILD_BASE=/dev/shm

#create staging directory if it does not exist
if [ ! -d ./staging ]; then
	mkdir -p ./staging
fi

#u-boot, built in-place, not on BUILD_BASE
echo "$ME: Running u-boot build"
cd u-boot
make CROSS_COMPILE=/opt/toolchains/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf/bin/arm-linux-gnueabihf- distclean
make CROSS_COMPILE=/opt/toolchains/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf/bin/arm-linux-gnueabihf- am335x_evm_bcb_defconfig
make CROSS_COMPILE=/opt/toolchains/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf/bin/arm-linux-gnueabihf- -j10
cp u-boot.img $CONFIG_BASE/staging
cp MLO $CONFIG_BASE/staging
cp MLO.byteswap $CONFIG_BASE/staging
cp spl/u-boot-spl.bin $CONFIG_BASE/staging
cd ..



echo "$ME: Done. Here's a shell:"
/bin/bash

####################
exit

#rootfs
echo "$ME: Running rootfs build"
cd rootfs
if [ ! -d $BUILD_BASE/rootfs ]; then
	echo "No previous yocto build at $BUILD_BASE... making a new one."
	./0setup_yocto_build.sh
else
	echo "Found previous yocto build at $BUILD_BASE... skipping setup."
fi
./1build_rootfs.sh && ./2trim-deploy_rootfs.sh
cd ..

#kernel
echo "$ME: Running kernel build"
cd ti-linux-kernel/ti-linux-kernel-v4.19.69-bc2020
make ARCH=arm CROSS_COMPILE=/opt/toolchains/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf/bin/arm-linux-gnueabihf- omap2plus_defconfig
make ARCH=arm CROSS_COMPILE=/opt/toolchains/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf/bin/arm-linux-gnueabihf- menuconfig
make ARCH=arm CROSS_COMPILE=/opt/toolchains/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf/bin/arm-linux-gnueabihf- -j10 zImage
make ARCH=arm CROSS_COMPILE=/opt/toolchains/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf/bin/arm-linux-gnueabihf- -j10 modules
make ARCH=arm CROSS_COMPILE=/opt/toolchains/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf/bin/arm-linux-gnueabihf- am335x-boneblack.dtb
rm -rf $CONFIG_BASE/staging/rootfs/lib/modules
make ARCH=arm CROSS_COMPILE=/opt/toolchains/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf/bin/arm-linux-gnueabihf- INSTALL_MOD_PATH=$CONFIG_BASE/staging/rootfs/ modules_install
cp arch/arm/boot/zImage $CONFIG_BASE/staging
cp arch/arm/boot/dts/am335x-boneblack.dtb $CONFIG_BASE/staging
echo "$ME: Kernel build done"
cd ../..

#squash
echo "Squashing rootfs..."
cd $CONFIG_BASE/staging/rootfs
OLD_SZ=$(du -sh0 . | cut -f1)
rm -rf ../bcbuildr_rootfs.squash && mksquashfs * ../bcbuildr_rootfs.squash -all-root -noappend
echo "=========================================================================="
echo "Raw rootfs: ${OLD_SZ}"
echo "Squashed:	  $(du -sh0 ../bcbuildr_rootfs.squash | cut -f1)"
echo "=========================================================================="

