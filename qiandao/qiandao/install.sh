#!/bin/sh

source /jffs/softcenter/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
DIR=$(cd $(dirname $0); pwd)
cd /tmp
cp -rf /tmp/qiandao/bin/* /jffs/softcenter/bin/
cp -rf /tmp/qiandao/res/* /jffs/softcenter/res/
cp -rf /tmp/qiandao/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/qiandao/webs/* /jffs/softcenter/webs/
cp -rf /tmp/qiandao/uninstall.sh /jffs/softcenter/scripts/uninstall_qiandao.sh
rm -rf /jffs/softcenter/init.d/*qiandao.sh
if [ "$(nvram get productid)" = "BLUECAVE" ];then
	cp -r /jffs/softcenter/scripts/qiandao_config.sh /jffs/softcenter/init.d/M99qiandao.sh
else
	[ ! -L "/jffs/softcenter/init.d/S99qiandao.sh" ] && ln -sf /jffs/softcenter/scripts/qiandao_config.sh /jffs/softcenter/init.d/S99qiandao.sh
fi
chmod 755 /jffs/softcenter/bin/qiandao
chmod 755 /jffs/softcenter/init.d/*
chmod 755 /jffs/softcenter/scripts/qiandao*

dbus set qiandao_action="2"
# 离线安装用
dbus set qiandao_version="$(cat $DIR/version)"
dbus set softcenter_module_qiandao_version="$(cat $DIR/version)"
dbus set softcenter_module_qiandao_description="自动签到"
dbus set softcenter_module_qiandao_install="1"
dbus set softcenter_module_qiandao_name="qiandao"
dbus set softcenter_module_qiandao_title="自动签到"

# 完成
echo_date "自动签到插件安装完毕！"
rm -rf /tmp/qiandao* >/dev/null 2>&1
exit 0

