#!/bin/sh

MODULE=fcn
VERSION="3.8.0"

cp -f /tmp/${MODULE}/bin/fcn_$(uname -m) /jffs/softcenter/bin/fcn
cp -f /tmp/${MODULE}/scripts/* /jffs/softcenter/scripts/
cp -f /tmp/${MODULE}/res/* /jffs/softcenter/res/
cp -f /tmp/${MODULE}/webs/* /jffs/softcenter/webs/
#cp -f /tmp/${MODULE}/uninstall.sh /jffs/softcenter/scripts/uninstall_fcn.sh
#cp -f /tmp/${MODULE}/init.d/* /jffs/softcenter/init.d/

chmod +x /jffs/softcenter/bin/fcn
chmod +x /jffs/softcenter/scripts/fcn_config.sh
chmod +x /jffs/softcenter/scripts/fcn_status.sh
chmod +x /jffs/softcenter/scripts/uninstall_fcn.sh

#init random fcn_uid
if [ -z $(dbus get fcn_uid) ]; then
    while true
    do
        fcn_uid=$(cat /proc/sys/kernel/random/uuid | md5sum | grep -o "[0-9]\{4\}" | head -n1)
        if [ ! -z $fcn_uid ]; then break; fi
    done
    dbus set fcn_uid="FCN_"$fcn_uid
fi

dbus set softcenter_module_fcn_install=1
dbus set softcenter_module_fcn_version="${VERSION}"
dbus set softcenter_module_fcn_title="Fcn一键接入"
dbus set softcenter_module_fcn_description="Fcn一键接入"
dbus set softcenter_module_fcn_home_url=Module_fcn.asp
dbus set ${MODULE}_version="${VERSION}"
