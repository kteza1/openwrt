#
# Copyright (C) 2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

LOADADDR = 0x80010000		# RAM start + 64K
KERNEL_ENTRY = $(LOADADDR)	# Newer kernels add a jmp to the kernel_entry at the start of the binary
LOADER_ENTRY = 0x80a00000	# RAM start + 10M, for relocate
RAMSIZE = 0x02000000		# 32MB
LZMA_TEXT_START = 0x81800000	# 32MB - 8MB

LOADER_MAKEOPTS= \
		KDIR=$(KDIR) \
		LOADADDR=$(LOADADDR) \
		KERNEL_ENTRY=$(KERNEL_ENTRY) \
		RAMSIZE=$(RAMSIZE) \
		LZMA_TEXT_START=$(LZMA_TEXT_START) \

RELOCATE_MAKEOPTS= \
		CACHELINE_SIZE=16 \
		KERNEL_ADDR=$(KERNEL_ENTRY) \
		CROSS_COMPILE=$(TARGET_CROSS) \
		LZMA_TEXT_START=$(LOADER_ENTRY)

define rootfspad/jffs2-128k
--align-rootfs
endef
define rootfspad/jffs2-64k
--align-rootfs
endef
define rootfspad/squashfs
endef

define Image/LimitName16
$(shell expr substr "$(1)" 1 16)
endef

TARGET_DTBS:=
TARGET_IMAGES:=

TARGET_Default_DTBS:=
TARGET_Default_IMAGES:=

define Image/Build/CFEDTB
	# Generate the tagged image
	$(STAGING_DIR_HOST)/bin/imagetag -i $(KDIR)/vmlinux-$(3).lzma.cfe -f $(KDIR)/root.$(1) \
		--output $(BIN_DIR)/openwrt-$(2)-$(1)-cfe.bin \
		--boardid $(4) --chipid $(5) --entry $(LOADER_ENTRY) \
		--load-addr $(LOADER_ENTRY) --info1 "-$(call Image/LimitName16,$(2))" \
		$(call rootfspad/$(1)) \
		--info2 $(1) $(6)
endef

define Image/Build/Dummy
	# Boards without a flashable image
	true
endef

define Build/Clean
	$(MAKE) -C lzma-loader clean
endef

define Image/PrepareLoader
	# Standard LZMA kernel
	$(STAGING_DIR_HOST)/bin/lzma e -d22 -fb64 -a1 $(KDIR)/vmlinux$(1) $(KDIR)/vmlinux$(1).lzma

	# Build the LZMA loader
	rm -rf $(KDIR)/lzma-loader
	$(MAKE) -C lzma-loader \
		$(LOADER_MAKEOPTS) \
		BUILD_DIR="$(KDIR)" \
		TARGET_DIR="$(2)" \
		LOADER_DATA="$(KDIR)/vmlinux$(1).lzma" \
		LOADER=$(IMG_PREFIX)-loader$(1) \
		compile $(3)

	rm -f $(KDIR)/vmlinux$(1).lzma
endef

define Image/PrepareLoaderDTB
	# append dtb to vmlinux, then build a standard LZMA loader
	cat $(KDIR)/vmlinux$(1) $(DTS_DIR)/$(2).dtb > $(KDIR)/vmlinux$(1)-$(2)
	$(call Image/PrepareLoader,$(1)-$(2),$(3),$(4))
endef

define Image/PrepareCFELzmaKernel
	# CFE only allows ~4 MiB for the uncompressed kernels, but uncompressed
	# kernel might get larger than that, so let CFE unpack and load at a
	# higher address and make the kernel relocate itself to the expected
	# location.
	( \
		dd if=$(KDIR)/relocate/loader.bin bs=32 conv=sync && \
		perl -e '@s = stat("$(KDIR)/vmlinux$(1)"); print pack("N", @s[7])' && \
		cat $(KDIR)/vmlinux$(1) \
	) > $(KDIR)/vmlinux-relocate$(1)

	# CFE is a LZMA nazi! It took me hours to find out the parameters!
	# Also I think lzma has a bug cause it generates different output depending on
	# if you use stdin / stdout or not. Use files instead of stdio here, cause
	# otherwise CFE will complain and not boot the image.
	$(STAGING_DIR_HOST)/bin/lzma e -d22 -fb64 -a1 $(KDIR)/vmlinux-relocate$(1) $(KDIR)/vmlinux$(1).lzma.tmp

	# Strip out the length, CFE doesn't like this
	dd if=$(KDIR)/vmlinux$(1).lzma.tmp of=$(KDIR)/vmlinux$(1).lzma.cfe bs=5 count=1
	dd if=$(KDIR)/vmlinux$(1).lzma.tmp of=$(KDIR)/vmlinux$(1).lzma.cfe ibs=13 obs=5 skip=1 seek=1 conv=notrunc
	rm -f $(KDIR)/vmlinux$(1).lzma.tmp
	rm -f $(KDIR)/vmlinux-relocate$(1)
endef

define Image/PrepareCFELzmaKernelDTB
	# compile the dts (the dtb will be later reused for the lzma loader)
	$(LINUX_DIR)/scripts/dtc/dtc -O dtb -o $(DTS_DIR)/$(1).dtb ../dts/$(1).dts
	cat $(KDIR)/vmlinux $(DTS_DIR)/$(1).dtb > $(KDIR)/vmlinux-$(1)
	$(call Image/PrepareCFELzmaKernel,-$(1))
endef

define Image/Prepare
	# build relocation code first
	rm -rf $(KDIR)/relocate
	$(CP) ../../generic/image/relocate $(KDIR)
	$(MAKE) -C $(KDIR)/relocate $(RELOCATE_MAKEOPTS)

	$(foreach board,$(sort $(TARGET_$(PROFILE)_DTBS)), $(call Image/PrepareCFELzmaKernelDTB,$(board)))

 ifeq ($(CONFIG_TARGET_ROOTFS_INITRAMFS),y)
	$(foreach board,$(sort $(TARGET_$(PROFILE)_DTBS)), \
		$(call Image/PrepareLoaderDTB,-initramfs,$(board),$(BIN_DIR),loader.elf))
 endif
endef

# $(1) = Image build
# $(2) = Profile
# $(3) = imagename
# $(4) = dtb
# $(5) = boardname
# $(6) = chipid
# $(7) = additional options
define ImageDTB
  define Image/Build/$(3)
        $$(call Image/Build/$(1),$$(1),$(3),$(4),$(5),$(6),$(7),$(8))
  endef

  TARGET_Default_DTBS += $(4)
  TARGET_Default_IMAGES += $(3)
  TARGET_$(2)_DTBS += $(4)
  TARGET_$(2)_IMAGES += $(3)
endef

define Image/Build
	dd if=$(KDIR)/root.$(1) of=$(BIN_DIR)/$(IMG_PREFIX)-root.$(1) bs=128k conv=sync

	# build dtb image list
	$(foreach image,$(TARGET_$(PROFILE)_IMAGES),$(call Image/Build/$(image),$(1)))

  ifeq ($(CONFIG_TARGET_ROOTFS_INITRAMFS),y)
	$(call Image/Build/Initramfs)
  endif
endef

# Comtrend AR-5381u
$(eval $(call ImageDTB,CFEDTB,AR5381u,AR-5381u,ar-5381u,96328A-1241N,6328,--pad 8))
# Comtrend VG-8050
$(eval $(call ImageDTB,Dummy,VG8050,VG-8050,vg-8050,963169P-1861N5,63268))
# Comtrend VR-3025u
$(eval $(call ImageDTB,CFEDTB,VR3025u,VR-3025u,vr-3025u,96368M-1541N,6368,--pad 16 --image-offset 0x20000 --block-size 0x20000))
# Comtrend VR-3025un
$(eval $(call ImageDTB,CFEDTB,VR3025un,VR-3025un,vr-3025un,96368M-1341N,6368,--pad 4))
# Comtrend VR-3032u
$(eval $(call ImageDTB,Dummy,VR3032u,VR-3032u,vr-3032u,963168M-1841N1,63268))
# Comtrend WAP-5813n
$(eval $(call ImageDTB,CFEDTB,WAP5813n,WAP-5813n,wap-5813n,96369R-1231N,6368,--pad 4))
# Huawei HG520v
$(eval $(call ImageDTB,CFEDTB,HG520v,HG520v,hg520v,HW6358GW_B,6358,--rsa-signature "EchoLife_HG520v"))
# Huawei HG556a
$(eval $(call ImageDTB,CFEDTB,HG556a_AB,HG556a_A,hg556a-a,HW556,6358,--rsa-signature "EchoLife_HG556a" --image-offset 0x20000 --block-size 0x10000 --tag-version 8))
$(eval $(call ImageDTB,CFEDTB,HG556a_AB,HG556a_B,hg556a-b,HW556,6358,--rsa-signature "EchoLife_HG556a" --image-offset 0x20000 --block-size 0x20000 --tag-version 8))
$(eval $(call ImageDTB,CFEDTB,HG556a_C,HG556a_C,hg556a-c,HW556,6358,--rsa-signature "EchoLife_HG556a" --image-offset 0x20000 --block-size 0x20000 --tag-version 8))
# Sagem F@ST1704
$(eval $(call ImageDTB,CFEDTB,FAST1704,F@ST1704,fast1704,F@ST1704,6338))

$(eval $(call BuildImage))
