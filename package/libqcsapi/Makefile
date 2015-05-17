#
# Copyright (C) 2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=libqcsapi
PKG_SOURCE_VERSION:=3.0.0.4.378.5134
PKG_VERSION:=2015-05-07-$(PKG_SOURCE_VERSION)
PKG_RELEASE:=1

PKG_MAINTAINER:=Álvaro Fernández Rojas <noltari@gmail.com>

PKG_LICENSE:=GPL-2.0
PKG_LICENSE_FILES:=License

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/libqcsapi
  SECTION:=libs
  CATEGORY:=Libraries
  DEPENDS:=+librpc
  TITLE:=Library for the Quantenna SoC
endef

define Package/qcsapi-pcie
  SECTION:=utils
  CATEGORY:=Utilities
  DEPENDS:=+libqcsapi
  TITLE:=qcsapi-pcie
endef

define Package/qcsapi-sample
  SECTION:=utils
  CATEGORY:=Utilities
  DEPENDS:=+libqcsapi
  TITLE:=qcsapi-sample
endef

define Package/qcsapi-sockraw
  SECTION:=utils
  CATEGORY:=Utilities
  DEPENDS:=+libqcsapi
  TITLE:=qcsapi-sockraw
endef

define Package/qcsapi-sockrpc
  SECTION:=utils
  CATEGORY:=Utilities
  DEPENDS:=+libqcsapi
  TITLE:=qcsapi-sockrpc
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Package/libqcsapi/install
	$(INSTALL_DIR) $(1)/lib
	$(CP) $(PKG_BUILD_DIR)/libqcsapi.so* $(1)/lib/
endef

define Package/qcsapi-pcie/install
	$(INSTALL_DIR) $(1)/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/qcsapi-pcie $(1)/sbin/
endef

define Package/qcsapi-sample/install
	$(INSTALL_DIR) $(1)/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/qcsapi-sample $(1)/sbin/
endef

define Package/qcsapi-sockraw/install
	$(INSTALL_DIR) $(1)/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/qcsapi-sockraw $(1)/sbin/
endef

define Package/qcsapi-sockrpc/install
	$(INSTALL_DIR) $(1)/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/qcsapi-sockrpc $(1)/sbin/
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_BUILD_DIR)/qcsapi.h $(1)/usr/include
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/libqcsapi.so* $(1)/usr/lib
endef

$(eval $(call BuildPackage,libqcsapi))
$(eval $(call BuildPackage,qcsapi-pcie))
$(eval $(call BuildPackage,qcsapi-sample))
$(eval $(call BuildPackage,qcsapi-sockraw))
$(eval $(call BuildPackage,qcsapi-sockrpc))
