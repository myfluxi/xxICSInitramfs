#!/sbin/busybox sh

/sbin/busybox mount -t rootfs -o remount,rw rootfs

/sbin/busybox rm /emmc
/sbin/busybox mkdir /emmc
/sbin/busybox chmod 777 /emmc

/sbin/busybox rm /sdcard
/sbin/busybox mkdir /sdcard
/sbin/busybox chmod 777 /sdcard

/sbin/busybox echo "-2" > /sys/devices/virtual/misc/backlightnotification/led_timeout
/sbin/busybox echo "-2" > /sys/devices/virtual/misc/notification/led_timeout

recovery

