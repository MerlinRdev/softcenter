#!/bin/sh
eval `dbus export fastd1ck_`
source /jffs/softcenter/scripts/base.sh

sh /jffs/softcenter/scripts/uu_config.sh stop

find /jffs/softcenter/init.d/ -name "*uu*" | xargs rm -rf
rm -rf /jffs/softcenter/res/icon-uu.png
rm -rf /jffs/softcenter/scripts/uu*.sh
rm -rf /jffs/softcenter/webs/Module_uu.asp
rm -f /jffs/softcenter/scripts/uninstall_uu.sh
