#!/bin/bash

export DISPLAY=:0
rm -rf /tmp/.xrand
xrandr.orig > /tmp/.xrand

OP1=`grep " connected" /tmp/.xrand | awk '{print $1}' | head -n1`
OP2=`grep " connected" /tmp/.xrand | awk '{print $1}' | tail -n1`

if [ "${OP1}" != "${OP2}" ]; then
	PRIM=`grep -i Primary /tmp/.xrand | awk '{print $1}'`
	if [ "${PRIM}" == "${OP1}" ]; then
		PRIM=$OP1
		SEC=$OP2
		RES1=`sed -n "/$PRIM/,/$SEC/p" /tmp/.xrand | grep ^" " | head -n1 | awk '{print $1}'`
		RES2=`sed -n "/$SEC/,//p" /tmp/.xrand | grep ^" " | head -n1 | awk '{print $1}'`
	else 
		PRIM=$OP2
		SEC=$OP1
		RES1=`sed -n "/$SEC/,/$PRIM/p" /tmp/.xrand | grep ^" " | head -n1 | awk '{print $1}'`
		RES2=`sed -n "/$PRIM/,//p" /tmp/.xrand | grep ^" " | head -n1 | awk '{print $1}'`
	fi 
	sqlite3 /data/sysconf.db "update DisplaySettings set FirstDisplayResolution='$RES1'"
	sync
	sqlite3 /data/sysconf.db "update DisplaySettings set SecondDisplayResolution='$RES2'"
	xrandr.orig --output $PRIM --mode $RES1 --output $SEC --mode $RES2
	sync
else
	RES1=`grep ^" " /tmp/.xrand | head -n1 | awk '{print $1}'`
	sqlite3 /data/sysconf.db "update DisplaySettings set FirstDisplayResolution='$RES1'"
	sync
	xrandr.orig --output $OP1 --mode $RES1
	sync
	
fi

sync
