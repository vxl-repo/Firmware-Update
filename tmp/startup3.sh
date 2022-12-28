#!/bin/sh

cd /sys/devices/
for i in `find . -name wakeup | grep -i usb`
do
        echo disabled > $i
done

grep PS2M /proc/acpi/wakeup | grep -q disabled
[ "$?" -eq "0" ] || echo PS2M > /proc/acpi/wakeup

grep PS2K /proc/acpi/wakeup | grep -q disabled
[ "$?" -eq "0" ] || echo PS2K > /proc/acpi/wakeup
cd -

#Copying 20-screen file for AMDGPU before configwizard

LSPCI_OUTPUT=`lspci | grep -iq "carrizo\|98e4\|baffin"`
ret=`echo $?`

if [ -f /data/.configurationwizard ] &&  [ "$ret" -eq "0" ]
then
	 cp -f /usr/bin/20-screen.conf /usr/share/X11/xorg.conf.d/
	 cp /usr/bin/blacklist.conf /etc/modprobe.d/
else
	echo "NO CONFIG FOUND"
fi

LSPCI_OUTPUT2=`lspci | grep -iq "D2xxx"`
status=`echo $?`

if [ -f /data/.configurationwizard ] &&  [ "$status" -eq "0" ]
then
	 cp -f /usr/bin/20-screen.conf-66 /usr/share/X11/xorg.conf.d/20-screen.conf
	 cp /usr/bin/blacklist.conf-66 /etc/modprobe.d/usr/bin/blacklist.conf
else
	echo "NO CONFIG FOUND"
fi

#Update Global Cerificates
if [ -f /data/.configurationwizard ]
then
        /usr/sbin/cert.sh &
fi


/usr/bin/server-cert.sh


#Changes Given by Pratik Najare
modprobe hid_multitouch


#rmmod rtl8821ae
#modprobe rtl8821ae


if [ ! -d /home/osuser/.config/google-chrome/Default/Extentions ]
then
        mkdir -p /home/osuser/.config/google-chrome/Default/Extensions
        chown -R osuser:osuser  /home/osuser/.config/*
fi

#Update google-chrome for SAML Authentication Logic
cp /etc/google-chrome /opt/google/chrome/

#Free Space after removing logs
/usr/bin/file-remove.sh --daemon &

#PulseAudio watchdog
/usr/bin/pulsewatchdog.sh &

#Running Log.sh
/usr/bin/log.sh &
