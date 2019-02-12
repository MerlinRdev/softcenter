#!/bin/sh
export KSROOT=/jffs/softcenter
source $KSROOT/scripts/base.sh
mdial_enable=`dbus get mdial_enable`

find /jffs/softcenter/init.d/ -name "*mdial*" | xargs rm -rf
find /jffs/softcenter/init.d/ -name "*mdial*" | xargs rm -rf

if [ "$mdial_enable" == "1" ];then
	[ -f "/jffs/softcenter/scripts/mdial_config.sh" ] && sh /jffs/softcenter/scripts/mdial_config.sh stop
fi

cp -rf /tmp/mdial/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/mdial/webs/* /jffs/softcenter/webs/
cp -rf /tmp/mdial/res/* /jffs/softcenter/res/
cp -rf /tmp/mdial/uninstall.sh /jffs/softcenter/scripts/uninstall_mdial.sh

rm -fr /tmp/mdial* >/dev/null 2>&1
chmod +x /jffs/softcenter/scripts/mdial*.sh
chmod +x /jffs/softcenter/scripts/uninstall_mdial.sh
[ ! -L "/jffs/softcenter/init.d/S10mdial.sh" ] && cp -rf /jffs/softcenter/scripts/mdial_config.sh /jffs/softcenter/init.d/S10mdial.sh


dbus set mdial_version="1.0"
dbus set softcenter_module_mdial_version="1.0"
dbus set softcenter_module_mdial_description="pppoe单线多拨，带宽提升神器！"
dbus set softcenter_module_mdial_install=1
dbus set softcenter_module_mdial_name=mdial
dbus set softcenter_module_mdial_title="单线多拨"
sleep 1

if [ "$mdial_enable" == "1" ];then
	[ -f "/jffs/softcenter/scripts/mdial_config.sh" ] && sh /jffs/softcenter/scripts/mdial_config.sh start
fi

