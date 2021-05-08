#!/bin/sh

source /jffs/softcenter/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'

DIR=$(cd $(dirname $0); pwd)
MODEL=$(nvram get productid)
if [ "${MODEL:0:3}" == "GT-" ] || [ "$(nvram get merlinr_rog)" == "1" ];then
	ROG=1
elif [ "${MODEL:0:3}" == "TUF" ] || [ "$(nvram get merlinr_tuf)" == "1" ];then
	TUF=1
fi
# stop syncthing first
enable=`dbus get syncthing_enable`
if [ "$enable" == "1" ];then
	sh /jffs/softcenter/scripts/syncthing_config.sh stop
fi

# cp files
cp -rf /tmp/syncthing/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/syncthing/bin/* /jffs/softcenter/bin/
cp -rf /tmp/syncthing/webs/* /jffs/softcenter/webs/
cp -rf /tmp/syncthing/res/* /jffs/softcenter/res/
chmod +x /jffs/softcenter/scripts/syncthing*
chmod +x /jffs/softcenter/bin/syncthing
dbus set syncthing_version="$(cat $DIR/version)"
dbus set softcenter_module_syncthing_version="$(cat $DIR/version)"
dbus set softcenter_module_syncthing_install="1"
dbus set softcenter_module_syncthing_name="syncthing"
dbus set softcenter_module_syncthing_title="syncthing储存同步"
dbus set softcenter_module_syncthing_description="syncthing"

# re-enable syncthing
if [ "$enable" == "1" ];then
	sh /jffs/softcenter/scripts/syncthing_config.sh start
fi

echo_date "syncthing插件安装完毕！"
rm -rf /tmp/syncthing* >/dev/null 2>&1
exit 0

