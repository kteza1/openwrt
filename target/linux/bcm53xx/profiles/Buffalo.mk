#
# Copyright (C) 2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/BUFFALO_WZR600DHP2
  NAME:=Buffalo WZR-600DHP2
  PACKAGES:=kmod-b43
endef
define Profile/BUFFALO_WZR600DHP2/Description
  Package set optimized for Buffalo WZR-600DHP2.
endef
$(eval $(call Profile,BUFFALO_WZR600DHP2))

define Profile/BUFFALO_WZR900DHP
  NAME:=Buffalo WZR-900DHP
  PACKAGES:=kmod-b43
endef
define Profile/BUFFALO_WZR900DHP/Description
  Package set optimized for Buffalo WZR-900DHP.
endef
$(eval $(call Profile,BUFFALO_WZR900DHP))

define Profile/BUFFALO_WZR1750DHP
  NAME:=Buffalo WZR-1750DHP
  PACKAGES:=kmod-b43
endef
define Profile/BUFFALO_WZR1750DHP/Description
  Package set optimized for Buffalo WZR-1750DHP.
endef
$(eval $(call Profile,BUFFALO_WZR1750DHP))

define Profile/BUFFALO_WZR1900DHP
  NAME:=Buffalo WZR-1900DHP
  PACKAGES:=kmod-b43
endef
define Profile/BUFFALO_WZR1900DHP/Description
  Package set optimized for Buffalo WZR-1900DHP.
endef
$(eval $(call Profile,BUFFALO_WZR1900DHP))
