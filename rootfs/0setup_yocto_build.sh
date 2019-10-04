#!/bin/bash

#clean build directory
rm -rf $BUILD_BASE/rootfs
mkdir -p $BUILD_BASE/rootfs
cd $BUILD_BASE/rootfs
ln -s $CONFIG_BASE/rootfs/config config

INJECT_DIR="$PWD/config"
INJECT_CFG="coresdk-2018.05-mytoolchain-config.txt"

echo "=========================================================================="
echo "Note: This is intended to be run from within the bcbuildr container for   "
echo "  the setup of a yocto/openembedded rootfs build environment."
echo "========================================================================="
sleep 3
echo "Cloning arago/oe-layersetup.git... if this hangs, make sure gitproxy (.gitconfig) is working."
git clone git://arago-project.org/git/projects/oe-layersetup.git arago
echo "Injecting our config..."
cd arago
cp $INJECT_DIR/$INJECT_CFG configs/coresdk/
./oe-layertool-setup.sh -f configs/coresdk/$INJECT_CFG
cp $INJECT_DIR/ti33x.inc sources/meta-ti/conf/machine/include/
cp $INJECT_DIR/am335x-bcmax.conf sources/meta-ti/conf/machine/
echo "sed'ing this build directory into bblayers.conf..."
sed -i "s#UPDATEME#${PWD}#g" build/conf/bblayers.conf
cd build
echo "SETUP DONE!"
echo "To build: "
echo "   source conf/setenv"
echo "   TOOLCHAIN_PATH=/opt/toolchains/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf/bin/arm-linux-gnueabihf- MACHINE=am335x-bcmax bitbake core-image-minimal"

