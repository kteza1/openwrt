#
# Copyright (C) 2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/SMARTRG_SR400AC
  NAME:=SmartRG R6250
  PACKAGES:=kmod-b43
endef
define Profile/SMARTRG_SR400AC/Description
  Package set optimized for SmartRG SR400ac.
endef
$(eval $(call Profile,SMARTRG_SR400AC))
