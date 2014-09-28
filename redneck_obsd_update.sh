#!/usr/local/bin/bash

# reboot with safe reboot

mkdir /home/install
cd /home/install
rel="`uname -r`"
tag="`uname -r | tr -d '.'`"

# remove the following condition once 5.6 is released
if [ "$rel" == "5.6" ]; then
	rel="snapshots"
	tag="56"
fi

for s in base comp game man xbase xfont xserv xshare etc xetc; do
	ftp -Cai http://ftp.eu.openbsd.org/pub/OpenBSD/${rel}/"`uname -a`"/${s}${tag}.tgz
done

for s in bsd bsd.rd bsd.mp SHA256.sig; do
	ftp -Cai http://ftp.eu.openbsd.org/pub/OpenBSD/${rel}/"`uname -a`"/${s}
done

echo "#!/bin/ksh" > /etc/rc.local.tmp
if [ "$rel" == "snapshots" ]; then
	echo "sysmerge -b" >> /etc/rc.local.tmp
else
	echo "sysmerge -b -s /home/install/etc55.tgz -x /home/install/xetc55.tgz" >> /etc/rc.local.tmp
fi
cat >> /etc/rc.local.tmp <<EOF
pkg_add -Iu
rm /etc/rc.local.tmp
EOF

echo "sh /etc/rc.local.tmp" >> /etc/rc.local

cp /sbin/reboot /sbin/oreboot
cp /bsd /obsd
if [ -e "/bsd.sp" ]; then
	# install multiprocessor kernel as /bsd
	cp bsd.mp /bsd
	cp bsd /bsd.sp
else
	cp bsd /bsd
	cp bsd.mp /bsd.mp
fi
sync

for s in base* comp* game* man* xbase* xfont* xserv* xshare*; do
	tar -xzp -f ${s} -C /
done
sync
/sbin/oreboot
