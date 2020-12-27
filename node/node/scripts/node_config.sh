#!/bin/sh

source /jffs/softcenter/scripts/base.sh
eval `dbus export node_`

create_init(){
	if [ ! -L "/jffs/softcenter/init.d/S99node.sh" ];then
		ln -sf /jffs/softcenter/scripts/node_config.sh /jffs/softcenter/init.d/S99node.sh
	fi
}

remove_init(){
	rm -f /jffs/softcenter/init.d/*node.sh
}

load_jd(){
	if [ "$node_jd_enable" == "1" ]; then
		/jffs/softcenter/scripts/node_jd.sh -s
		ln -sf /jffs/softcenter/bin/JDCookie.crx /tmp/upload/JDCookie.crx
	else
	    sed -i '/jd-dailybonus-up/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	    sed -i '/jd-dailybonus/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	fi
}

start_node(){
	stop_node
	create_init
	load_jd
}

stop_node(){
	killall node >/dev/null 2>&1
	remove_init
}

case $ACTION in
start)
	if [ "$node_enable" == "1" ]; then
		start_node
	fi
	;;
stop)
	stop_node
	;;
*)
	if [ "$node_enable" == "1" ]; then
		start_node
	else
		stop_node
	fi
	;;
esac
