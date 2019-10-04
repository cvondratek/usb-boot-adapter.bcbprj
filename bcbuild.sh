#!/bin/bash
ME="usb-boot-adapter.bcbprj/bcbuild.sh"
#
# master build executor for usb-boot-adapter.bcbprj
#   todo: parameterize, please

export CONFIG_BASE=$PWD #/workdir the container
export BUILD_BASE=/dev/shm
export KERNEL_PATH=$PWD/ti-linux-kernel/ti-linux-kernel-v4.19.69-bc2020
export CROSS=/opt/toolchains/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf/bin/arm-linux-gnueabihf-

#create staging directory if it does not exist
if [ ! -d ./staging ]; then
	mkdir -p ./staging
fi

#u-boot, built in-place, not on BUILD_BASE
if [ ! -f "$CONFIG_BASE/staging/u-boot.img" ]; then
	echo "$ME: Running u-boot build"
	cd u-boot
	make CROSS_COMPILE=$CROSS distclean
	make CROSS_COMPILE=$CROSS am335x_evm_bcb_defconfig
	make CROSS_COMPILE=$CROSS -j10
	cp u-boot.img $CONFIG_BASE/staging
	cp MLO $CONFIG_BASE/staging
	cp MLO.byteswap $CONFIG_BASE/staging
	cp spl/u-boot-spl.bin $CONFIG_BASE/staging
	cd ..
else
	echo "$ME: Found $CONFIG_BASE/staging/u-boot.img, SKIPPING u-boot build!"
fi

#yocto, always run
#if [ ! -d "$BUILD_BASE/rootfs/" ]; then
	echo "$ME: Running rootfs build"
	cd rootfs
	if [ ! -d "$BUILD_BASE/rootfs" ]; then
		echo "No previous yocto build at $BUILD_BASE... making a new one."
		./0setup_yocto_build.sh
	else
		echo "Found previous yocto build at $BUILD_BASE... skipping setup."
	fi
	./1build_rootfs.sh && ./2trim-deploy_rootfs.sh
	cd ..
#else
#	echo "$ME: Found $BUILD_BASE/rootfs... SKIPPING rootfs build!"
#fi

#kernel
if [ ! -f "$CONFIG_BASE/staging/zImage" ]; then
	echo "$ME: Running kernel build"
	cd $KERNEL_PATH
	cp .config .config.LAST
	make ARCH=arm CROSS_COMPILE=$CROSS omap2plus_defconfig
	make ARCH=arm CROSS_COMPILE=$CROSS menuconfig
	echo "$ME: (Eff-up? No worries, we saved a backup of .config to .config.LAST)"
	make ARCH=arm CROSS_COMPILE=$CROSS -j10 zImage
	make ARCH=arm CROSS_COMPILE=$CROSS -j10 modules
	make ARCH=arm CROSS_COMPILE=$CROSS am335x-boneblack.dtb
	cp arch/arm/boot/zImage $CONFIG_BASE/staging
	cp arch/arm/boot/dts/am335x-boneblack.dtb $CONFIG_BASE/staging
	echo "$ME: Kernel build done"
	cd -
else
	echo "$ME: Found $CONFIG_BASE/staging/zImage... SKIPPING kernel build!"
fi

echo "Installing kernel modules..."
rm -rf $CONFIG_BASE/staging/rootfs/lib/modules
make ARCH=arm CROSS_COMPILE=$CROSS \
	INSTALL_MOD_PATH=$CONFIG_BASE/staging/rootfs/ \
	-C $KERNEL_PATH modules_install

echo "lazy /etc/dropbear fix"
cd $CONFIG_BASE/staging/rootfs/etc
rm -rf dropbear
ln -s /tmp dropbear
cd -

#always squash
echo "Squashing rootfs..."
cd $CONFIG_BASE/staging/rootfs
OLD_SZ=$(du -sh0 . | cut -f1)
rm -rf ../bcbuildr_rootfs.squash && mksquashfs * ../bcbuildr_rootfs.squash -all-root -noappend
echo "=========================================================================="
echo "Raw rootfs: ${OLD_SZ}"
echo "Squashed:	  $(du -sh0 ../bcbuildr_rootfs.squash | cut -f1)"
echo "=========================================================================="

echo "$ME: Done."

