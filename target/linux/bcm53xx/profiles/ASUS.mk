#
# Copyright (C) 2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/ASUS-RT-AC87U
  NAME:=ASUS RT-AC87U
  PACKAGES:=asus-rt-ac87u qcsapi-sockrpc
endef

define Profile/ASUS-RT-AC87U/Description
	Package set optimized for ASUS RT-AC87U.
endef

$(eval $(call Profile,ASUS-RT-AC87U))
