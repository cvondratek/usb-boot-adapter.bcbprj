#!/bin/sh
modprobe libcomposite


mkdir /sys/kernel/config/usb_gadget/mykeyboard
cd /sys/kernel/config/usb_gadget/mykeyboard
if [ ! -d /sys/kernel/config/usb_gadget/mykeyboard ]; then
	echo "no usb_gadget in configfs?"
	exit
fi;

echo 0x0100 > bcdDevice # Version 1.0.0
echo 0x0200 > bcdUSB # USB 2.0
echo 0x00 > bDeviceClass
echo 0x00 > bDeviceProtocol
echo 0x00 > bDeviceSubClass
echo 0x08 > bMaxPacketSize0
echo 0x0104 > idProduct # Multifunction Composite Gadget
echo 0x1d6b > idVendor # Linux Foundation
mkdir -p strings/0x409
echo "My manufacturer" > strings/0x409/manufacturer
echo "My virtual keyboard" > strings/0x409/product
echo "0123456789" > strings/0x409/serialnumber
mkdir -p functions/hid.usb0
echo 1 > functions/hid.usb0/protocol
echo 8 > functions/hid.usb0/report_length # 8-byte reports
echo 1 > functions/hid.usb0/subclass
echo -ne \\x05\\x01\\x09\\x06\\xa1\\x01\\x05\\x07\\x19\\xe0\\x29\\xe7\\x15\\x00\\x25\\x01\\x75\\x01\\x95\\x08\\x81\\x02\\x95\\x01\\x75\\x08\\x81\\x03\\x95\\x05\\x75\\x01\\x05\\x08\\x19\\x01\\x29\\x05\\x91\\x02\\x95\\x01\\x75\\x03\\x91\\x03\\x95\\x06\\x75\\x08\\x15\\x00\\x25\\x65\\x05\\x07\\x19\\x00\\x29\\x65\\x81\\x00\\xc0 > functions/hid.usb0/report_desc
mkdir -p configs/c.1
mkdir -p configs/c.1/strings/0x409
echo 0x80 > configs/c.1/bmAttributes # Only bus powered
echo 100 > configs/c.1/MaxPower # 100 mA
echo "Example configuration" > configs/c.1/strings/0x409/configuration
ln -s functions/hid.usb0 configs/c.1

#this activates the gadget...
ls /sys/class/udc > UDC
