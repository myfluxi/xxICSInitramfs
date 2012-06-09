#!/sbin/busybox sh

mount /system -o remount,rw


#### Install scripts ####
/sbin/xx/xx-install.sh &


#### CWM fake scripts ####
/sbin/xx/cwm.sh &


#### Tweak scripts ####
/sbin/xx/xx-tweaks.sh &

