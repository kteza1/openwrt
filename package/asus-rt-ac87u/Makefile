#
# Copyright (C) 2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=asus-rt-ac87u
PKG_SOURCE_VERSION:=3.0.0.4.378.5134
PKG_VERSION:=2015-05-07-$(PKG_SOURCE_VERSION)
PKG_RELEASE:=1

PKG_MAINTAINER:=Álvaro Fernández Rojas <noltari@gmail.com>

PKG_LICENSE:=GPL-2.0
PKG_LICENSE_FILES:=License

include $(INCLUDE_DIR)/package.mk

define Package/asus-rt-ac87u
  SECTION:=utils
  CATEGORY:=Utilities
  DEPENDS:=
  TITLE:=TFTP files for the Quantenna SoC (ASUS RT-AC87U)
endef

define Build/Compile
endef

define Package/asus-rt-ac87u/install
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./base-files/etc/uci-defaults/asus-rt-ac87u $(1)/etc/uci-defaults/
	$(INSTALL_CONF) ./base-files/etc/qcsapi_target_ip.conf $(1)/etc/
	$(INSTALL_DIR) $(1)/tftp
	$(INSTALL_DATA) ./files/{u-boot.bin,topaz-linux.lzma.img} $(1)/tftp
	$(INSTALL_DATA) ./files/{qtn_dbg.sh,router_command.sh,start-stateless-slave,tweak_qcomm} $(1)/tftp
endef

$(eval $(call BuildPackage,asus-rt-ac87u))
