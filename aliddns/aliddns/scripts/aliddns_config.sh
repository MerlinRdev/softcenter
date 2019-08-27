#!/bin/sh

source /jffs/softcenter/scripts/base.sh
eval `dbus export aliddns`
modelname=`nvram get modelname`
start_aliddns(){
	cru a aliddns_checker "*/$aliddns_interval * * * * /jffs/softcenter/scripts/aliddns_update.sh"
	sh /jffs/softcenter/scripts/aliddns_update.sh

	if [ "$(nvram get productid)" = "BLUECAVE" -o "$modelname" = "R7900P" -o "$modelname" = "R8000P" ];then
		[ ! -f "/jffs/softcenter/init.d/M98Aliddns.sh" ] && cp -r /jffs/softcenter/scripts/aliddns_config.sh /jffs/softcenter/init.d/M98Aliddns.sh
	else
		[ ! -L "/jffs/softcenter/init.d/S98Aliddns.sh" ] && ln -sf /jffs/softcenter/scripts/aliddns_config.sh /jffs/softcenter/init.d/S98Aliddns.sh
	fi
}

stop_aliddns(){
	jobexist=`cru l|grep aliddns_checker`
	# kill crontab job
	if [ -n "$jobexist" ];then
		sed -i '/aliddns_checker/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	fi
	nvram set ddns_hostname_x=`nvram get ddns_hostname_old`
}

case $1 in
start)
	if [ "$aliddns_enable" == "1" ];then
		logger "[软件中心]: 启动阿里DDNS！"
		start_aliddns
	else
		logger "[软件中心]: 阿里DDNS未设置开机启动，跳过！"
	fi
	;;
stop)
	stop_aliddns
	;;
*)
	if [ "$aliddns_enable" == "1" ];then
		start_aliddns
	else
		stop_aliddns
	fi
	;;
esac
