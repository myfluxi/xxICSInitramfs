#!/sbin/busybox sh

INSTALLDIR="/sbin/xx"
FILESDIR="$INSTALLDIR/files"

#### Install liblights ####
LIGHTS="lights.exynos4.so"
mv -f $FILESDIR/liblights/$LIGHTS /system/lib/hw/$LIGHTS
chmod 644 /system/lib/hw/$LIGHTS


#### Install mfc firmware ####
sleep 5
if [ ! -h /vendor ]; then
	mount / -o remount,rw
	ln -s /system/vendor /vendor
	mount / -o remount,ro
fi

if [ ! -f /system/vendor/firmware/mfc_fw.bin ]; then
	mkdir -p /system/vendor/firmware
	cp -f /sbin/xx/files/mfc/mfc_fw.bin /system/vendor/firmware/
	chmod 644 /system/vendor/firmware/mfc_fw.bin
fi


#### Done with /system ####
mount /system -o remount,ro


# Set xxTweaker permissions
if [ ! -e /data ]; then mount /data -o remount,rw; fi

if [ -e /data/data/net.fluxi.xxTweaker ]; then

	USERID=$(grep "xxTweaker" /data/system/packages.xml | sed -n 's|userId="\(.*\)">|\1|p' | awk '{print $NF}')

	mkdir -p /data/data/net.fluxi.xxTweaker/shared_prefs
	touch /data/data/net.fluxi.xxTweaker/shared_prefs/net.fluxi.xxTweaker_preferences.xml
	chmod 755 /data/data/net.fluxi.xxTweaker
	chmod 771 /data/data/net.fluxi.xxTweaker/shared_prefs
	chmod 660 /data/data/net.fluxi.xxTweaker/shared_prefs/net.fluxi.xxTweaker_preferences.xml
	chown -R $USERID:$USERID /data/data/net.fluxi.xxTweaker
	chown 1000:1000 /data/data/net.fluxi.xxTweaker/lib
fi


#### Create /clockworkmod/.salted_hash to satisfy CWMR ####
while [ ! -e /mnt/emmc/.android_secure ]; do sleep 2; done
if [ ! -e /mnt/emmc/clockworkmod ]; then
	mkdir -p /mnt/emmc/clockworkmod/backup
	touch /mnt/emmc/clockworkmod/.salted_hash
fi

while [ ! -e /mnt/sdcard/.android_secure ]; do sleep 2; done
if [ ! -e /mnt/sdcard/clockworkmod ]; then
	mkdir -p /mnt/sdcard/clockworkmod/backup
	touch /mnt/sdcard/clockworkmod/.salted_hash
fi

