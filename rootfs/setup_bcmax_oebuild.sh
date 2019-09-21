#!/bin/bash

INJECT_DIR="$PWD/bc2019-injects"
INJECT_CFG='coresdk-2018.05-mytoolchain-config.txt'

echo "========================================================================="
echo "Note: This is NOT for a quick rebuild but for a setting-up a build directory."
echo "  TOOLCHAIN_PATH= <whatever>/linux-devkit/sysroots/x86_64-arago-linux/usr/bin/arm-linux-gnueabihf- MACHINE=am335x-bcmax bitbake core-image-minimal"
echo " ^^^^^ is probably what you're looking for."
echo "========================================================================="
echo "     >>Also, did you specify a directory name on the command line????<<  "
echo "         Ctrl-c if not & try again... sleeping for 3 secs."
echo "========================================================================="
sleep 3
mkdir $1
cd $1
echo "Cloning arago. IF this hangs, go setup gitproxy!"
git clone git://arago-project.org/git/projects/oe-layersetup.git tisdk
cd tisdk
cp $INJECT_DIR/$INJECT_CFG configs/coresdk/
./oe-layertool-setup.sh -f configs/coresdk/$INJECT_CFG
cp $INJECT_DIR/local.conf build/conf/
cp $INJECT_DIR/bblayers.conf build/conf/
cp $INJECT_DIR/ti33x.inc sources/meta-ti/conf/machine/include/
cp $INJECT_DIR/am335x-bcmax.conf sources/meta-ti/conf/machine/
sed -i "s#UPDATEME#${PWD}#g" build/conf/bblayers.conf
cd build
#nano conf/local.conf
#nano conf/bblayers.conf
echo "SETUP DONE"
echo "To build: "
echo "   source conf/setenv"
echo "   TOOLCHAIN_PATH=<whatever>/linux-devkit/sysroots/x86_64-arago-linux/usr/bin/arm-linux-gnueabihf- MACHINE=am335x-bcmax bitbake core-image-minimal"

