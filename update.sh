#!/bin/bash

#RHEL
yum -y update && yum -y upgrade;
#DEB
apt-get -y update && apt-get -y upgrade;
#GENTOO
emerge --sync && emerge --update --quiet-fail=y --keep-going=y --ask=n --deep --with-bdeps=y @world;
#OBSD
pkg_add -Iu;
if [ "`uname`" == "OpenBSD" ]; then curl -s https://raw.githubusercontent.com/spaceSub/simple-update/master/redneck_obsd_update.sh | bash; else echo "get a real OS"; fi
#FBSD
ASSUME_ALWAYS_YES=true pkg upgrade
sed 's/\[ ! -t 0 \]/false/' /usr/sbin/freebsd-update > /tmp/freebsd-update;
chmod +x /tmp/freebsd-update;
/tmp/freebsd-update;
sed 's/\[ ! -t 0 \]/false/' /usr/sbin/portsnap > /tmp/portsnap
chmod +x /tmp/portsnap;
/tmp/portsnap -Da;
#ARCH
pacman --noconfirm -Syu;
yaourt --noconfirm -Syu --devel --aur;

reboot
