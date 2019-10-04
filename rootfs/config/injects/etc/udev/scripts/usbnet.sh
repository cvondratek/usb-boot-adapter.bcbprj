#!/bin/sh
/sbin/ifconfig usb0 169.254.99.130 netmask 255.255.255.252
/usr/sbin/udhcpd -I 169.254.99.130 /home/root/usbnet/udhcpd.conf
