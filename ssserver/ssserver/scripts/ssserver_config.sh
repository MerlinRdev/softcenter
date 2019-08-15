#!/bin/sh
# load path environment in dbus databse
eval `dbus export ssserver`
source /jffs/softcenter/scripts/base.sh

start_ssserver(){
	[ "$ssserver_udp" -ne 1 ] && ARG_UDP="" || ARG_UDP="-u";
	if [ "$ssserver_obfs" == "http" ];then
		ARG_OBFS="--plugin obfs-server --plugin-opts obfs=http"
	elif [ "$ssserver_obfs" == "tls" ];then
		ARG_OBFS="--plugin obfs-server --plugin-opts obfs=tls"
	else
		ARG_OBFS=""
	fi

	#ss-server -c /jffs/softcenter/ssserver/ss.json $ARG_UDP $ARG_OBFS -f /tmp/ssserver.pid
	ss-server -s 0.0.0.0 -p $ssserver_port -k $ssserver_password -m $ssserver_method -t $ssserver_time $ARG_UDP $ARG_OBFS -f /tmp/ssserver.pid 

	# creat start_up file
	if [ "$(nvram get productid)" = "BLUECAVE" ];then
		if [ ! -f "/jffs/softcenter/init.d/N98ssserver.sh" ]; then 
			cp -r /jffs/softcenter/scripts/ssserver_config.sh /jffs/softcenter/init.d/N97ssserver.sh
		fi
	else
		if [ ! -L "/jffs/softcenter/init.d/N98ssserver.sh" ]; then 
			ln -sf /jffs/softcenter/scripts/ssserver_config.sh /jffs/softcenter/init.d/N97ssserver.sh
		fi
	fi

	# creat start_up file
	if [ "$(nvram get productid)" = "BLUECAVE" ];then
		if [ ! -f "/jffs/softcenter/init.d/M98ssserver.sh" ]; then 
			cp -r /jffs/softcenter/scripts/ssserver_config.sh /jffs/softcenter/init.d/M97ssserver.sh
		fi
	else
		if [ ! -L "/jffs/softcenter/init.d/S98ssserver.sh" ]; then 
			ln -sf /jffs/softcenter/scripts/ssserver_config.sh /jffs/softcenter/init.d/S97ssserver.sh
		fi
	fi
}

stop_ssserver(){
	killall ss-server >/dev/null 2>&1
	killall obfs-server >/dev/null 2>&1
}

open_port(){
	ifopen=`iptables -S -t filter | grep INPUT | grep dport |grep $ssserver_port`
	[ -z "$ifopen" ] && iptables -t filter -I INPUT -p tcp --dport $ssserver_port -j ACCEPT >/dev/null 2>&1
	[ -z "$ifopen" ] && iptables -t filter -I INPUT -p udp --dport $ssserver_port -j ACCEPT >/dev/null 2>&1
}

close_port(){
	ifopen=`iptables -S -t filter | grep INPUT | grep dport |grep $ssserver_port`
	[ -n "$ifopen" ] && iptables -t filter -D INPUT -p tcp --dport $ssserver_port -j ACCEPT >/dev/null 2>&1
	[ -n "$ifopen" ] && iptables -t filter -D INPUT -p udp --dport $ssserver_port -j ACCEPT >/dev/null 2>&1
}

write_output(){
	ss_enable=`dbus get ss_basic_enable`
	if [ "$ssserver_use_ss" == "1" ] && [ "$ss_enable" == "1" ];then
		if [ ! -f "/etc/dnsmasq.user/gfwlist.conf" ];then
			echo link gfwlist.conf
			cp -r /jffs/softcenter/ss/rules/gfwlist.conf /etc/dnsmasq.user/gfwlist.conf
		fi
		service restart_dnsmasq
		iptables -t nat -A OUTPUT -p tcp -m set --match-set gfwlist dst -j REDIRECT --to-ports 3333
	fi
}

del_output(){
	iptables -t nat -D OUTPUT -p tcp -m set --match-set gfwlist dst -j REDIRECT --to-ports 3333 >/dev/null 2>&1
}

case $1 in
start)
	if [ "$ssserver_enable" == "1" ]; then
		logger "[软件中心]: 启动ssserver！"
		start_ssserver
		open_port
		write_output
	else
		logger "[软件中心]: ssserver未设置开机启动，跳过！"
	fi
	;;
stop)
	close_port >/dev/null 2>&1
	stop_ssserver
	del_output
	;;
start_nat)
	if [ "$ssserver_enable" == "1" -a -n "$(pidof ss-server)" ]; then
		close_port >/dev/null 2>&1
		open_port
		write_output
	fi
	;;
restart)
	if [ "$ssserver_enable" == "1" ]; then
		close_port >/dev/null 2>&1
		stop_ssserver
		sleep 1
		start_ssserver
		open_port
		write_output
	else
		close_port >/dev/null 2>&1
		stop_ssserver
		del_output
	fi
	;;
esac
