#!/bin/sh

source /jffs/softcenter/scripts/base.sh
cd /tmp
VERSION="1.0"
dbus set serverchan_version="${VERSION}"
mkdir -p /jffs/softcenter/serverchan
[ -e "/jffs/softcenter/bin/base64_decode" ] || cp -rf /tmp/serverchan/bin/* /jffs/softcenter/bin/
cp -rf /tmp/serverchan/res/* /jffs/softcenter/res/
cp -rf /tmp/serverchan/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/serverchan/webs/*  /jffs/softcenter/webs/

cd /
rm -rf /tmp/serverchan  >/dev/null 2>&1
chmod 755 /jffs/softcenter/scripts/*
chmod 755 /jffs/softcenter/bin/*

