#!/bin/sh

source /jffs/softcenter/scripts/base.sh
aria2_enable=`dbus get aria2_enable`
aria2_version=`dbus get aria2_version`

#重建 /dev/null
#rm /dev/null 
#mknod /dev/null c 1 3 
#chmod 666 /dev/null

if [ "$aria2_enable" == "1" ];then
	[ -f "/jffs/softcenter/scripts/aria2_config.sh" ] && sh /jffs/softcenter/scripts/aria2_config.sh stop
fi

cp -rf /tmp/aria2/bin/* /jffs/softcenter/bin/
cp -rf /tmp/aria2/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/aria2/webs/* /jffs/softcenter/webs/
cp -rf /tmp/aria2/res/* /jffs/softcenter/res/
cp -rf /tmp/aria2/uninstall.sh /jffs/softcenter/scripts/uninstall_aria2.sh

rm -fr /tmp/aria2* >/dev/null 2>&1
chmod +x /jffs/softcenter/bin/*
chmod +x /jffs/softcenter/scripts/aria2*.sh
chmod +x /jffs/softcenter/scripts/uninstall_aria2.sh
if [ "$(nvram get productid)" = "BLUECAVE" ];then
	[ ! -f "/jffs/softcenter/init.d/M99Aria2.sh" ] && cp -r /jffs/softcenter/scripts/aria2_config.sh /jffs/softcenter/init.d/M99Aria2.sh
	[ ! -f "/jffs/softcenter/init.d/N99Aria2.sh" ] && cp -r /jffs/softcenter/scripts/aria2_config.sh /jffs/softcenter/init.d/N99Aria2.sh
else
	[ ! -L "/jffs/softcenter/init.d/M99Aria2.sh" ] && ln -sf /jffs/softcenter/scripts/aria2_config.sh /jffs/softcenter/init.d/M99Aria2.sh
	[ ! -L "/jffs/softcenter/init.d/N99Aria2.sh" ] && ln -sf /jffs/softcenter/scripts/aria2_config.sh /jffs/softcenter/init.d/N99Aria2.sh
fi

#some modify
if [ "$aria2_version" == "1.5" ] || [ "$aria2_version" == "1.4" ] || [ "$aria2_version" == "1.3" ];then
	dbus set aria2_custom=Y2EtY2VydGlmaWNhdGU9L2V0Yy9zc2wvY2VydHMvY2EtY2VydGlmaWNhdGVzLmNydA==
fi

dbus set aria2_version="2.5"
dbus set softcenter_module_aria2_version="2.5"
dbus set softcenter_module_aria2_install="1"
dbus set softcenter_module_aria2_name="aria2"
dbus set softcenter_module_aria2_title="aria2"
dbus set softcenter_module_aria2_description="linux下载利器"
sleep 1

if [ "$aria2_enable" == "1" ];then
	[ -f "/jffs/softcenter/scripts/aria2_config.sh" ] && sh /jffs/softcenter/scripts/aria2_config.sh start
fi

