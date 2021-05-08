#!/bin/sh

source /jffs/softcenter/scripts/base.sh
sh /jffs/softcenter/scripts/syncthing_config.sh stop

rm -rf /jffs/softcenter/bin/syncthing
rm -rf /jffs/softcenter/bin/sync
rm -rf /jffs/softcenter/res/icon-syncthing.png
rm -rf /jffs/softcenter/scripts/syncthing_*
rm -rf /jffs/softcenter/webs/Module_syncthing.asp
rm -rf /tmp/syncthing.log

find /jffs/softcenter/init.d/ -name "*syncthing*" | xargs rm -rf
# 取消dbus注册 TG sadog
cd /tmp 
dbus list syncthing|cut -d "=" -f1|sed 's/^/dbus remove /g' > clean.sh
dbus list softcenter_module_|grep syncthing|cut -d "=" -f1|sed 's/^/dbus remove /g' >> clean.sh
chmod 777 clean.sh 
sh ./clean.sh > /dev/null 2>&1 
rm clean.sh

exit 0
