#!/bin/bash

#save old
cd staging

OLD_SZ=$(du -s ./)

#rm [big] files that we don't need
rm usr/lib/libgtk* 
rm -rf usr/lib/girepository*
rm usr/lib/libX11* 
rm usr/lib/libgdk* 
rm -rf usr/lib/gdk-pixbuf-2.0
rm usr/lib/libharfbuzz* 
rm usr/lib/libfreetype* 
rm usr/lib/libpixman* 
rm usr/lib/libsamplerate* 
#rm usr/lib/libunistring*  # needed for wpa-supplicant
rm usr/lib/libgio* 
rm usr/lib/libgmp* 
rm usr/lib/libfontconfig* 

rm -rf usr/share/fonts 
rm -rf usr/share/mime 
rm -rf usr/share/icons
rm -rf usr/share/sounds
rm -rf usr/share/themes
rm -rf usr/share/fontconfig
rm -rf usr/share/X11

rm etc/udev/hwdb.d/20-pci-vendor-model.hwdb
rm etc/udev/hwdb.d/20-acpi-vendor.hwdb

#whack udev hwdb.bin
rm etc/udev/hwdb.bin

#remove ipk post-install stuff that blocks boot
rm -rf etc/ipk-postinsts
rm etc/rcS.d/S99run-postinsts

#inject
tar xf ../injectfs.tgz

NEW_SZ=$(du -s ./)

echo "=========================================================================="
echo "Org size: ${OLD_SZ}."
echo "New size: ${NEW_SZ}."
echo "(in 1kB blocks)"
echo "=========================================================================="

