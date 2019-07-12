#!/bin/sh
eval `dbus export serverchan_`
source /jffs/softcenter/scripts/base.sh
logger "[软件中心]: 正在卸载serverChan..."
MODULE=serverchan
cd /
/jffs/softcenter/scripts/serverchan_config stop
rm -f /jffs/softcenter/scripts/serverchan_config.sh
rm -f /jffs/softcenter/scripts/serverchan_check.sh
rm -f /jffs/softcenter/webs/Module_serverchan.asp
rm -f /jffs/softcenter/res/icon-serverchan.png
rm -fr /tmp/serverchan* >/dev/null 2>&1
values=`dbus list serverchan | cut -d "=" -f 1`

for value in $values
do
dbus remove $value 
done
logger "[软件中心]: 完成serverChan卸载"
rm -f /jffs/softcenter/scripts/uninstall_serverchan.sh
