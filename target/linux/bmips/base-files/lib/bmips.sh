#!/bin/sh
#
# Copyright (C) 2015 OpenWrt.org
#

BMIPS_BOARD_NAME=
BMIPS_MODEL=

bmips_board_detect() {
	local machine
	local name

	machine=$(awk 'BEGIN{FS="[ \t]+:[ \t]"} /machine/ {print $2}' /proc/cpuinfo)

	case "$machine" in
	*"Comtrend AR-5381u")
		name="ar-5381u"
		;;
	*"Comtrend VG-8050")
		name="vg-8050"
		;;
	*"Comtrend VR-3025u")
		name="vr-3025u"
		;;
	*"Comtrend VR-3025un")
		name="vr-3025un"
		;;
	*"Comtrend VR-3032u")
		name="vr-3032u"
		;;
	*"Comtrend WAP-5813n")
		name="wap-5813n"
		;;
	*"Huawei EchoLife HG520v")
		name="hg520v"
		;;
	*"Huawei EchoLife HG556a (version A)")
		name="hg556a-a"
		;;
	*"Huawei EchoLife HG556a (version B)")
		name="hg556a-b"
		;;
	*"Huawei EchoLife HG556a (version C)")
		name="hg556a-c"
		;;
	*)
		name="generic"
		;;
	esac

	[ -z "$BMIPS_BOARD_NAME" ] && BMIPS_BOARD_NAME="$name"
	[ -z "$BMIPS_MODEL" ] && BMIPS_MODEL="$machine"

	[ -e "/tmp/sysinfo/" ] || mkdir -p "/tmp/sysinfo/"

	echo "$BMIPS_BOARD_NAME" > /tmp/sysinfo/board_name
	echo "$BMIPS_MODEL" > /tmp/sysinfo/model
}

bmips_board_name() {
	local name

	[ -f /tmp/sysinfo/board_name ] && name=$(cat /tmp/sysinfo/board_name)
	[ -z "$name" ] && name="unknown"

	echo "$name"
}
