#!/bin/sh
source /jffs/softcenter/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
DIR=$(cd $(dirname $0); pwd)


# stop mdial first
enable=`dbus get mdial_enable`
if [ "$enable" == "1" ] && [ -f "/jffs/softcenter/scripts/mdial_config.sh" ];then
	sh /jffs/softcenter/scripts/mdial_config.sh stop
fi

# 安装插件
find /jffs/softcenter/init.d/ -name "*mdial*" | xargs rm -rf
cp -rf /tmp/mdial/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/mdial/webs/* /jffs/softcenter/webs/
cp -rf /tmp/mdial/res/* /jffs/softcenter/res/
cp -rf /tmp/mdial/uninstall.sh /jffs/softcenter/scripts/uninstall_mdial.sh
chmod +x /jffs/softcenter/scripts/mdial*.sh
chmod +x /jffs/softcenter/scripts/uninstall_mdial.sh
if [ "$(nvram get productid)" = "BLUECAVE" ];then
	[ ! -f "/jffs/softcenter/init.d/S10mdial.sh" ] && cp -rf /jffs/softcenter/scripts/mdial_config.sh /jffs/softcenter/init.d/S10mdial.sh
else
	[ ! -L "/jffs/softcenter/init.d/S10mdial.sh" ] && ln -sf /jffs/softcenter/scripts/mdial_config.sh /jffs/softcenter/init.d/S10mdial.sh
fi
# 离线安装用
dbus set mdial_version="$(cat $DIR/version)"
dbus set softcenter_module_mdial_version="$(cat $DIR/version)"
dbus set softcenter_module_mdial_description="pppoe单线多拨，带宽提升神器！"
dbus set softcenter_module_mdial_install="1"
dbus set softcenter_module_mdial_name="mdial"
dbus set softcenter_module_mdial_title="单线多拨"

# re-enable mdial
if [ "$enable" == "1" ] && [ -f "/jffs/softcenter/scripts/mdial_config.sh" ];then
	[ -f "/jffs/softcenter/scripts/mdial_config.sh" ] && sh /jffs/softcenter/scripts/mdial_config.sh start
fi

# 完成
echo_date "frpc内网穿透插件安装完毕！"
rm -rf /tmp/mdial* >/dev/null 2>&1
exit 0
