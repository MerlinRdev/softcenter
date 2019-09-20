#!/bin/sh

source /jffs/softcenter/scripts/base.sh

sh /jffs/softcenter/koolproxyR/kp_config.sh stop
rm -rf /jffs/softcenter/koolproxyR/ >/dev/null 2>&1
rm -rf /jffs/softcenter/bin/koolproxy >/dev/null 2>&1
rm -rf /jffs/softcenter/res/koolproxyR_check.htm
rm -rf /jffs/softcenter/res/koolproxyR_run.htm
rm -rf /jffs/softcenter/res/koolproxyR_user.htm
rm -rf /jffs/softcenter/scripts/koolproxyR* >/dev/null 2>&1
rm -rf /jffs/softcenter/webs/Module_koolproxyR.asp >/dev/null 2>&1
rm -rf /jffs/softcenter/res/icon-koolproxyR.png >/dev/null 2>&1
rm -rf /jffs/softcenter/scripts/kp_update.sh >/dev/null 2>&1
rm -rf /jffs/softcenter/scripts/kp.sh >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxyR/data/rules/*.txt >/dev/null 2>&1
find /jffs/softcenter/init.d/ -name "*koolproxyR*" | xargs rm -rf

# 取消dbus注册 TG sadog
cd /tmp 
dbus list koolproxyR|cut -d "=" -f1|sed 's/^/dbus remove /g' > clean.sh
dbus list softcenter_module_|grep koolproxyR|cut -d "=" -f1|sed 's/^/dbus remove /g' >> clean.sh
chmod 777 clean.sh 
sh ./clean.sh > /dev/null 2>&1 
rm clean.sh

exit 0


