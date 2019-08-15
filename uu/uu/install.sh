#!/bin/sh

MODULE=uu
VERSION="1.2.12"

cp -rf /tmp/${MODULE}/uu /jffs/
cp -f /tmp/${MODULE}/scripts/* /jffs/softcenter/scripts/
cp -f /tmp/${MODULE}/res/* /jffs/softcenter/res/
cp -f /tmp/${MODULE}/webs/* /jffs/softcenter/webs/
cp -f /tmp/${MODULE}/uninstall.sh /jffs/softcenter/scripts/uninstall_uu.sh

chmod +x /jffs/uu/*
chmod +x /jffs/softcenter/scripts/*

dbus set softcenter_module_uu_install=1
dbus set softcenter_module_uu_version="${VERSION}"
dbus set softcenter_module_uu_title="网易uu"
dbus set softcenter_module_uu_description="网易uu"
dbus set softcenter_module_uu_home_url=Module_uu.asp
dbus set ${MODULE}_version="${VERSION}"
