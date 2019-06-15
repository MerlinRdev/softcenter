#!/bin/sh

MODULE=baidupcs
VERSION="1.0"
cd /tmp
killall ${MODULE}
rm -f /jffs/softcenter/init.d/S98baidupcs.sh
cp -f /tmp/${MODULE}/bin/BaiduPCS /jffs/softcenter/bin/BaiduPCS
cp -f /tmp/${MODULE}/scripts/* /jffs/softcenter/scripts/
cp -f /tmp/${MODULE}/res/* /jffs/softcenter/res/
cp -f /tmp/${MODULE}/webs/* /jffs/softcenter/webs/

chmod +x /jffs/softcenter/bin/BaiduPCS
chmod +x /jffs/softcenter/scripts/baidupcs_config.sh

dbus set softcenter_module_baidupcs_install=1
dbus set ${MODULE}_version="${VERSION}"
rm -fr /tmp/baidupcs* >/dev/null 2>&1
en=`dbus get baidupcs_enable`
if [ "${en}"x = "1"x ]; then
    sh /jffs/softcenter/scripts/baidupcs_config.sh
fi
