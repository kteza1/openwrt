#
# Copyright (C) 2013-2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

define Image/Prepare
	$(CP) $(DTS_DIR)/*.dtb $(KDIR)/

	rm -f $(KDIR)/fs_mark
	echo -ne '\xde\xad\xc0\xde' > $(KDIR)/fs_mark
	$(call prepare_generic_squashfs,$(KDIR)/fs_mark)

	# For UBI we want only one extra block
	rm -f $(KDIR)/ubi_mark
	echo -ne '\xde\xad\xc0\xde' > $(KDIR)/ubi_mark

	$(CP) ./ubinize.cfg $(KDIR)
endef

define Build/append-dtb
	cat $(KDIR)/$(DEVICE_DTS).dtb >> $@
endef

define Build/lzma-d16
	$(STAGING_DIR_HOST)/bin/lzma e $@ -d16 $(1) $@.new
	@mv $@.new $@
endef

define Build/mkfs/squashfs
	( cd $(KDIR); $(STAGING_DIR_HOST)/bin/ubinize -p 128KiB -m 2048 -o $(KDIR)/root-block-0x20000-min-0x800.ubi ubinize.cfg )
endef

define Build/trx-serial
	$(STAGING_DIR_HOST)/bin/trx \
		-o $@ \
		-f $(word 1,$^) -a 1024 \
		-f $(KDIR)/root.squashfs -a 0x10000 -A $(KDIR)/fs_mark
endef

define Build/trx-nand
	# kernel: always use 4 MiB (-28 B or TRX header) to allow upgrades even
	#	  if it grows up between releases
	# root: UBI with one extra block containing UBI mark to trigger erasing
	#	rest of partition
	$(STAGING_DIR_HOST)/bin/trx \
		-o $@ \
		-m 33554432 \
		-f $(word 1,$^) -a 0x20000 -b 0x400000 \
		-f $(KDIR)/root-block-0x20000-min-0x800.ubi \
		-A $(KDIR)/ubi_mark -a 0x20000
endef

define Build/netgear-chk
	$(STAGING_DIR_HOST)/bin/mkchkimg \
		-o $@.new -k $@ -b $(NETGEAR_ID) -r $(NETGEAR_REGION)
	mv $@.new $@
endef

# Default
define Device/Default
  PROFILES = Generic $$(DEVICE_PROFILE)
  KERNEL := kernel-bin | append-dtb | lzma-d16
  FILESYSTEMS := squashfs
  KERNEL_NAME := zImage
  IMAGE_NAME = $$(IMAGE_PREFIX)-$$(1).$$(2)
  DEVICE_PROFILE :=
  DEVICE_DTS :=
endef
DEVICE_VARS += DEVICE_PROFILE DEVICE_DTS

# Generic NAND
define Device/bcm53xx_nand
  IMAGES := trx
  IMAGE/trx := trx-nand
endef

# Generic Serial
define Device/bcm53xx_serial
  IMAGES := trx
  IMAGE/trx := trx-serial
endef

# Netgear
define Device/bcm53xx_netgear
  IMAGES := chk
  IMAGE/chk := $$(IMAGE/trx) | netgear-chk
  NETGEAR_ID :=
  NETGEAR_REGION :=
endef
DEVICE_VARS += NETGEAR_ID NETGEAR_REGION

# Device Macros
# $(1) = device definition
# $(2) = profile
# $(3) = device name
# $(4) = dts
define add_bcm53xx
  define Device/$(3)
    $$(Device/$(1))
    DEVICE_PROFILE := $(2)
    DEVICE_DTS := $(4)
  endef
  TARGET_DEVICES += $(3)
endef

# $(1) = device definition
# $(2) = profile
# $(3) = device name
# $(4) = dts
# $(5) = netgear id
# $(6) = netgear region
define add_bcm53xx_netgear
  define Device/$(3)
    $$(Device/$(1))
    $$(Device/bcm53xx_netgear)
    DEVICE_PROFILE := $(2)
    DEVICE_DTS := $(4)
    NETGEAR_ID := $(5)
    NETGEAR_REGION := $(6)
  endef
  TARGET_DEVICES += $(3)
endef

# ASUS RT-AC56U
$(eval $(call add_bcm53xx,bcm53xx_nand,ASUS_RTAC56U,ASUS_RT-AC56U,bcm4708-asus-rt-ac56u))
# ASUS RT-AC68U
$(eval $(call add_bcm53xx,bcm53xx_nand,ASUS_RTAC68U,ASUS_RT-AC68U,bcm4708-asus-rt-ac68u))
# ASUS RT-AC87U
$(eval $(call add_bcm53xx,bcm53xx_nand,ASUS_RTAC87U,ASUS_RT-AC87U,bcm4709-asus-rt-ac87u))
# ASUS RT-N18U
$(eval $(call add_bcm53xx,bcm53xx_nand,ASUS_RTN18U,ASUS_RT-N18U,bcm47081-asus-rt-n18u))
# Buffalo WZR-600DHP2
$(eval $(call add_bcm53xx,bcm53xx_nand,BUFFALO_WZR600DHP2,Buffalo_WZR-600DHP2,bcm47081-buffalo-wzr-600dhp2))
# Buffalo WZR-900DHP
$(eval $(call add_bcm53xx,bcm53xx_nand,BUFFALO_WZR900DHP,Buffalo_WZR-900DHP,bcm47081-buffalo-wzr-900dhp))
# Buffalo WZR-1750DHP
$(eval $(call add_bcm53xx,bcm53xx_nand,BUFFALO_WZR1750DHP,Buffalo_WZR-1750DHP,bcm4708-buffalo-wzr-1750dhp))
# Buffalo WZR-1900DHP
$(eval $(call add_bcm53xx,bcm53xx_nand,BUFFALO_WZR1900DHP,Buffalo_WZR-1900DHP,bcm4709-buffalo-wxr-1900dhp))
# NETGEAR R6250
$(eval $(call add_bcm53xx_netgear,bcm53xx_nand,NETGEAR_R6250,NETGEAR_R6250,bcm4708-netgear-r6250,U12H245T00_NETGEAR,1))
# NETGEAR R6300 v2
$(eval $(call add_bcm53xx_netgear,bcm53xx_nand,NETGEAR_R6300v2,NETGEAR_R6300-v2,bcm4708-netgear-r6300-v2,U12H240T00_NETGEAR,1))
# NETGEAR R8000
$(eval $(call add_bcm53xx_netgear,bcm53xx_nand,NETGEAR_R8000,NETGEAR_R8000,bcm4709-netgear-r8000,U12H315T00_NETGEAR,1))
# SmartRG SR400ac
$(eval $(call add_bcm53xx,bcm53xx_serial,SMARTRG_SR400AC,SmartRG_SR400ac,bcm4708-smartrg-sr400ac))

$(eval $(call BuildImage))
