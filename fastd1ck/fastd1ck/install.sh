#!/bin/sh

source /jffs/softcenter/scripts/base.sh
fastd1ck_enable=`dbus get fastd1ck_enable`

find /jffs/softcenter/init.d/ -name "*fastd1ck*" | xargs rm -rf
find /jffs/softcenter/init.d/ -name "*FastD1ck*" | xargs rm -rf

if [ "$fastd1ck_enable" == "1" ];then
	[ -f "/jffs/softcenter/scripts/fastd1ck_config.sh" ] && sh /jffs/softcenter/scripts/fastd1ck_config.sh stop
fi

cp -rf /tmp/fastd1ck/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/fastd1ck/webs/* /jffs/softcenter/webs/
cp -rf /tmp/fastd1ck/res/* /jffs/softcenter/res/
cp -rf /tmp/fastd1ck/uninstall.sh /jffs/softcenter/scripts/uninstall_fastd1ck.sh
rm -fr /tmp/fastd1ck* >/dev/null 2>&1
chmod +x /jffs/softcenter/scripts/fastd1ck*.sh
chmod +x /jffs/softcenter/scripts/uninstall_fastd1ck.sh
if [ "$(nvram get productid)" = "BLUECAVE" ];then
	cp -r /jffs/softcenter/scripts/fastd1ck_config.sh /jffs/softcenter/init.d/M99fastd1ck.sh
else
	[ ! -L "/jffs/softcenter/init.d/S99fastd1ck.sh" ] && ln -sf /jffs/softcenter/scripts/fastd1ck_config.sh /jffs/softcenter/init.d/S99fastd1ck.sh
fi

dbus set fastd1ck_version="1.6"
dbus set softcenter_module_fastd1ck_version="1.6"
dbus set softcenter_module_fastd1ck_description=迅雷快鸟，上网必备神器
dbus set softcenter_module_fastd1ck_install=1
dbus set softcenter_module_fastd1ck_name=fastd1ck
dbus set softcenter_module_fastd1ck_title=迅雷快鸟
sleep 1

if [ "$fastd1ck_enable" == "1" ];then
	[ -f "/jffs/softcenter/scripts/fastd1ck_config.sh" ] && sh /jffs/softcenter/scripts/fastd1ck_config.sh start
fi

