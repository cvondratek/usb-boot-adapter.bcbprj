#!/bin/sh

#start dhcp servers for camera interfaces
udhcpd /home/root/polecam/udhcpd-eth0.conf
udhcpd /home/root/polecam/udhcpd-eth1.conf

