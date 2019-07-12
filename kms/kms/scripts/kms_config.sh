#!/bin/sh
# load path environment in dbus databse
eval `dbus export kms`
source /jffs/softcenter/scripts/base.sh
CONFIG_FILE=/etc/dnsmasq.user/kms.conf

start_kms(){
	/jffs/softcenter/bin/vlmcsd
	echo "srv-host=_vlmcs._tcp.lan,`uname -n`.lan,1688,0,100" > $CONFIG_FILE
	nvram set lan_domain=lan
	nvram commit
	service restart_dnsmasq
	# creat start_up file
	if [ "$(nvram get productid)" = "BLUECAVE" ];then
		[ ! -f "/jffs/softcenter/init.d/N97Kms.sh" ] && cp -r /jffs/softcenter/scripts/kms_config.sh /jffs/softcenter/init.d/N97Kms.sh
		[ ! -f "/jffs/softcenter/init.d/M97Kms.sh" ] && cp -r /jffs/softcenter/scripts/kms_config.sh /jffs/softcenter/init.d/M97Kms.sh
	else
		[ ! -L "/jffs/softcenter/init.d/N97Kms.sh" ] && ln -sf /jffs/softcenter/scripts/kms_config.sh /jffs/softcenter/init.d/N97Kms.sh
		[ ! -L "/jffs/softcenter/init.d/S97Kms.sh" ] && ln -sf /jffs/softcenter/scripts/kms_config.sh /jffs/softcenter/init.d/S97Kms.sh
	fi
}

stop_kms(){
	killall vlmcsd
	rm $CONFIG_FILE
	rm -rf /jffs/softcenter/init.d/N97Kms.sh
	if [ "$(nvram get productid)" = "BLUECAVE" ];then
		rm -rf /jffs/softcenter/init.d/M97Kms.sh
	else
		rm -rf /jffs/softcenter/init.d/S97Kms.sh
	fi
	service restart_dnsmasq
}

open_port(){
	ifopen=`iptables -S -t filter | grep INPUT | grep dport |grep 1688`
	[ -z "$ifopen" ] && iptables -t filter -I INPUT -p tcp --dport 1688 -j ACCEPT
}

close_port(){
	ifopen=`iptables -S -t filter | grep INPUT | grep dport |grep 1688`
	[ -n "$ifopen" ] && iptables -t filter -D INPUT -p tcp --dport 1688 -j ACCEPT
}

case $1 in
start)
	if [ "$kms_enable" == "1" ]; then
		logger "[软件中心]: 启动KMS！"
		start_kms
		[ "$kms_wan_port" == "1" ] && open_port
	else
		logger "[软件中心]: KMS未设置开机启动，跳过！"
	fi
	;;
stop)
	close_port >/dev/null 2>&1
	stop_kms
	;;
start_nat)
	if [ "$kms_enable" == "1" -a -n "$(pidof vlmcsd)" ]; then
		close_port >/dev/null 2>&1
		[ "$kms_wan_port" == "1" ] && open_port
	fi
	;;
*)
	if [ "$kms_enable" == "1" ]; then
		close_port >/dev/null 2>&1
		stop_kms
		start_kms
		[ "$kms_wan_port" == "1" ] && open_port
	else
		close_port >/dev/null 2>&1
		stop_kms
	fi
	;;
esac
