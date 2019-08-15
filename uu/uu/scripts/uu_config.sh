#!/bin/sh

eval `dbus export uu_`
source /jffs/softcenter/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'

start()
{
	nohup /bin/sh /jffs/uu/uuplugin_monitor.sh &
	if [ "$(nvram get productid)" = "BLUECAVE" ];then
		cp -r /jffs/softcenter/scripts/uu_config.sh /jffs/softcenter/init.d/M97uu.sh
	else
		[ ! -L "/jffs/softcenter/init.d/S97uu.sh" ] && ln -sf /jffs/softcenter/scripts/uu_config.sh /jffs/softcenter/init.d/S97uu.sh
	fi
	[ -f "/tmp/uu/uu.conf" ] && dbus set uu_version=`cat /tmp/uu/uu.conf |sed -n '2p' |cut -c10-15`
}

stop()
{
	killall uuplugin_monitor.sh >/dev/null 2>&1
	killall -9 uuplugin >/dev/null 2>&1
}

case $1 in
start)
	if [ "$uu_enable" == "1" ];then
		logger "[软件中心]: 启动网易uu！"
		start
	else
		logger "[软件中心]: 网易uu未设置开机启动，跳过！"
	fi
	;;
stop)
	stop
	;;

restart)
	if [ "$uu_enable" == "1" ];then
		stop
		sleep 1
		start
	else
		stop
	fi
	;;
esac
