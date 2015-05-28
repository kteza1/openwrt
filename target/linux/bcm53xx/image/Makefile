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
	cat $(KDIR)/$(DT).dtb >> $@
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

define Build/asus-trx
	$(STAGING_DIR_HOST)/bin/asustrx \
		-p $(ASUS_ID) -i $@ -o $@.new
	mv $@.new $@
endef

define Build/netgear-chk
	$(STAGING_DIR_HOST)/bin/mkchkimg \
		-o $@.new -k $@ -b $(NETGEAR_ID) -r $(NETGEAR_REGION)
	mv $@.new $@
endef

define Device/Default
  # .dtb files are prefixed by SoC type, e.g. bcm4708- which is not included in device/image names
  # extract the full dtb name based on the device info
  DT := $(patsubst %.dtb,%,$(notdir $(wildcard $(if $(IB),$(KDIR),$(DTS_DIR))/*-$(1).dtb)))
  PROFILES = Generic $$(DEVICE_PROFILE)
  KERNEL := kernel-bin | append-dtb | lzma-d16
  FILESYSTEMS := squashfs
  KERNEL_NAME := zImage
  IMAGE_NAME = $$(IMAGE_PREFIX)-$$(1).$$(2)
  DEVICE_PROFILE :=
endef
DEVICE_VARS += DT DEVICE_PROFILE

define Device/trx_nand
  IMAGES := trx
  IMAGE/trx := trx-nand
endef

define Device/trx_serial
  IMAGES := trx
  IMAGE/trx := trx-serial
endef

define Device/asus
  IMAGES := trx
  IMAGE/trx := $$(IMAGE/trx) | asus-trx
  ASUS_ID :=
endef
DEVICE_VARS += ASUS_ID

define Device/netgear
  IMAGES := chk
  IMAGE/chk := $$(IMAGE/trx) | netgear-chk
  NETGEAR_ID :=
  NETGEAR_REGION :=
endef
DEVICE_VARS += NETGEAR_ID NETGEAR_REGION

# $(1) = trx image
# $(2) = device name
define GenericDevice
  define Device/$(2)
    $$(Device/$(1))
    DEVICE_PROFILE := $(2)
  endef
  TARGET_DEVICES += $(2)
endef

# $(1) = trx image
# $(2) = device name
# $(3) = asus id
define AsusDevice
  define Device/asus-$(2)
    $$(Device/$(1))
	$$(Device/asus)
    DEVICE_PROFILE := asus-$(2)
    ASUS_ID := $(3)
  endef
  TARGET_DEVICES += asus-$(2)
endef

# $(1) = trx image
# $(2) = device name
# $(3) = netgear id
# $(4) = netgear region
define NetgearDevice
  define Device/netgear-$(2)
    $$(Device/$(1))
	$$(Device/netgear)
    DEVICE_PROFILE := netgear-$(2)
    NETGEAR_ID := $(3)
    NETGEAR_REGION := $(4)
  endef
  TARGET_DEVICES += netgear-$(2)
endef

$(eval $(call AsusDevice,trx_nand,rt-ac56u,RT-AC56U))
$(eval $(call AsusDevice,trx_nand,rt-ac68u,RT-AC68U))
$(eval $(call AsusDevice,trx_nand,rt-ac87u,RT-AC87U))
$(eval $(call AsusDevice,trx_nand,rt-n18u,RT-N18U))
$(eval $(call GenericDevice,trx_nand,buffalo-wxr-1900dhp))
$(eval $(call GenericDevice,trx_nand,buffalo-wzr-1750dhp))
$(eval $(call GenericDevice,trx_nand,buffalo-wzr-600dhp2))
$(eval $(call GenericDevice,trx_nand,buffalo-wzr-900dhp))
$(eval $(call GenericDevice,trx_serial,smartrg-sr400ac))
$(eval $(call NetgearDevice,trx_nand,r6250,U12H245T00_NETGEAR,1))
$(eval $(call NetgearDevice,trx_nand,r6300-v2,U12H240T00_NETGEAR,1))
$(eval $(call NetgearDevice,trx_nand,r8000,U12H315T00_NETGEAR,1))

$(eval $(call BuildImage))
