#
# Copyright (C) 2013 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/HLKRM04
	NAME:=HILINK HLK-RM04
	PACKAGES:=\
		kmod-usb-core kmod-usb-ohci kmod-usb2 kmod-ledtrig-netdev kmod-ledtrig-timer \
		kmod-usb-acm kmod-usb-net kmod-usb-net-asix kmod-usb-net-rndis kmod-usb-serial kmod-usb-serial-option \
		usb-modeswitch usb-modeswitch-data comgt
endef

define Profile/HLKRM04/Description
	Package set for HiLink RM04 Module
endef

$(eval $(call Profile,HLKRM04))

