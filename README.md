# usb-boot-adapter.bcbprj
This is a bcbuildr project for highly-reliable & automation-friendly usb-boot adapter for beaglebone and other am335x boards with USB device port exposed.
Output is a single flash-image w/ u-boot, kernel + rootfs configured with:
* recent u-boot configured to boot rootfs from a read-only flash image into RAM preloaded with grub.efi & config
* 4.19.x kernel with usb-gadget configured to fake a flash-disk from contents in /dev/shm
* boot process automation scripts that monitors a target "boot.elf" for changes (from Jenkins CI, ansible... or even over NFS)
* when triggered by Jenkins or ansible, automagically 
* powers-on the DUT via Zwave, Web Power Switch, or Weemo (pending)
 

## Status
Work in progress, untested.

## Build Process

1. get & cd bcbuildr
2. ln -s <this directory> workdir
3. ./run.sh
4. Capture kernel .config in defconfig
	cp .config arch/arm/configs/omap2plus_defconfig 
5. Flash (BBB)
	ssh root@bxb mount /dev/mmcblk1p1 /mnt
	scp workdir/staging/* root@<ip of bcb>:/mnt
	ssh root@bxb /sbin/reboot
6. Force rebuild of yocto rootfs w/o re-download
	rm -rf /dev/shm/rootfs/arago/build/arago-tmp-glibc
	rm -rf /dev/shm/rootfs/arago/build/cache
	rm -rf /dev/shm/rootfs/arago/build/sstate-cache
	./run.sh
