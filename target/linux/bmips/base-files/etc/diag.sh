#!/bin/sh
#
# Copyright (C) 2015 OpenWrt.org
#

. /lib/functions/leds.sh
. /lib/bmips.sh

get_status_led() {
	case $(bmips_board_name) in
	"ar-5381u")
		status_led="AR-5381u:green:power"
		;;
	"hg520v")
		status_led="HG520v:green:net"
		;;
	"hg556a-a")
		status_led="HG556a:red:power"
		;;
	"hg556a-b")
		status_led="HG556a:red:power"
		;;
	"hg556a-c")
		status_led="HG556a:red:power"
		;;
	"vg-8050")
		status_led="VG-8050:green:power"
		;;
	"vr-3025u")
		status_led="VR-3025u:green:power"
		;;
	"vr-3025un")
		status_led="VR-3025un:green:power"
		;;
	"vr-3032u")
		status_led="VR-3032u:green:power"
		;;
	"wap-5813n")
		status_led="WAP-5813n:green:power"
		;;
	esac
}

set_state() {
	get_status_led

	case "$1" in
	preinit)
		status_led_blink_preinit
		;;
	failsafe)
		status_led_blink_failsafe
		;;
	preinit_regular)
		status_led_blink_preinit_regular
		;;
	done)
		status_led_on
		;;
	esac
}
