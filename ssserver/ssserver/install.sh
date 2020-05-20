#!/bin/sh
source /jffs/softcenter/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
DIR=$(cd $(dirname $0); pwd)
MODEL=$(nvram get productid)
if [ "$MODEL" == "GT-AC5300" ] || [ "$MODEL" == "GT-AX11000" ] || [ "$MODEL" == "GT-AC2900" ] || [ "$(nvram get merlinr_rog)" == "1" ];then
	ROG=1
elif [ "$MODEL" == "TUF-AX3000" ] || [ "$(nvram get merlinr_tuf)" == "1" ] ;then
	TUF=1
fi

# stop ssserver first
enable=`dbus get ssserver_enable`
if [ "$enable" == "1" ];then
	sh /jffs/softcenter/scripts/ssserver_config.sh stop
fi

# cp files
cp -rf /tmp/ssserver/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/ssserver/bin/* /jffs/softcenter/bin/
cp -rf /tmp/ssserver/webs/* /jffs/softcenter/webs/
cp -rf /tmp/ssserver/res/* /jffs/softcenter/res/
cp -rf /tmp/ssserver/uninstall.sh /jffs/softcenter/scripts/uninstall_ssserver.sh
# creat start_up file
[ ! -L "/jffs/softcenter/init.d/N98ssserver.sh" ] && ln -sf /jffs/softcenter/scripts/ssserver_config.sh /jffs/softcenter/init.d/N97ssserver.sh
[ ! -L "/jffs/softcenter/init.d/S98ssserver.sh" ] && ln -sf /jffs/softcenter/scripts/ssserver_config.sh /jffs/softcenter/init.d/S97ssserver.sh

chmod +x /jffs/softcenter/scripts/ssserver*
chmod +x /jffs/softcenter/bin/ss-server
chmod +x /jffs/softcenter/bin/obfs-server
chmod +x /jffs/softcenter/init.d/*

# 离线安装用
dbus set ssserver_version="$(cat $DIR/version)"
dbus set softcenter_module_ssserver_version="$(cat $DIR/version)"
dbus set softcenter_module_ssserver_description="ss-server"
dbus set softcenter_module_ssserver_install="1"
dbus set softcenter_module_ssserver_name="ssserver"
dbus set softcenter_module_ssserver_title="ss-server"
# re-enable ssserver
if [ "$enable" == "1" ];then
	sh /jffs/softcenter/scripts/ssserver_config.sh
fi

# 完成
echo_date "ss-server插件安装完毕！"
rm -rf /tmp/ssserver* >/dev/null 2>&1
exit 0

