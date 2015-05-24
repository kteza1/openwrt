#
# Copyright (C) 2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/NETGEAR_R6250
  NAME:=NETGEAR R6250
  PACKAGES:=kmod-b43
endef
define Profile/NETGEAR_R6250/Description
  Package set optimized for NETGEAR R6250.
endef
$(eval $(call Profile,NETGEAR_R6250))

define Profile/NETGEAR_R6300v2
  NAME:=NETGEAR R6300 v2
  PACKAGES:=kmod-b43
endef
define Profile/NETGEAR_R6300v2/Description
  Package set optimized for NETGEAR R6300 v2.
endef
$(eval $(call Profile,NETGEAR_R6300v2))

define Profile/NETGEAR_R8000
  NAME:=NETGEAR R8000
  PACKAGES:=kmod-b43
endef
define Profile/NETGEAR_R8000/Description
  Package set optimized for NETGEAR R8000.
endef
$(eval $(call Profile,NETGEAR_R8000))
