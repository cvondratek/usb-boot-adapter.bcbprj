#!/bin/bash
ME="usb-boot-adapter.bcbprj/bcbuild.sh"
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

#build
./1build_rootfs.sh && ./2trim-deploy_rootfs.sh
cd ..


#add mo' steps...

echo "I'm done. Here's a shell."
/bin/bash
