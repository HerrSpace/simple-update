#!/bin/bash

yum -y update && yum -y upgrade;
apt-get -y update && apt-get -y upgrade;
emerge --sync && emerge --update --deep --with-bdeps=y @world;
pkg_add -u;
portsnap fetch update && portmaster -Da;

reboot