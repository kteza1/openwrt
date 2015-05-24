#
# Copyright (C) 2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/ASUS_RTAC56U
  NAME:=ASUS RT-AC56U
  PACKAGES:=kmod-b43
endef
define Profile/ASUS_RTAC56U/Description
  Package set optimized for ASUS RT-AC56U.
endef
$(eval $(call Profile,ASUS_RTAC56U))

define Profile/ASUS_RTAC68U
  NAME:=ASUS RT-AC68U
  PACKAGES:=kmod-b43
endef
define Profile/ASUS_RTAC68U/Description
  Package set optimized for ASUS RT-AC68U.
endef
$(eval $(call Profile,ASUS_RTAC68U))

define Profile/ASUS_RTAC87U
  NAME:=ASUS RT-AC87U
  PACKAGES:=
endef
define Profile/ASUS_RTAC87U/Description
  Package set optimized for ASUS RT-AC87U.
endef
$(eval $(call Profile,ASUS_RTAC87U))

define Profile/ASUS_RTN18U
  NAME:=ASUS RT-N18U
  PACKAGES:=kmod-b43
endef
define Profile/ASUS_RTN18U/Description
  Package set optimized for ASUS RT-N18U.
endef
$(eval $(call Profile,ASUS_RTN18U))
