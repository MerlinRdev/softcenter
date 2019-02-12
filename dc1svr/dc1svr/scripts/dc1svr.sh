#!/bin/sh
# load path environment in dbus databse
eval `dbus export dc1svr`
source /jffs/softcenter/scripts/base.sh
CONFIG_FILE=/tmp/etc/dnsmasq.user/dc1.conf

start_dc1(){
	/jffs/softcenter/bin/dc1svr &
	echo "address=/Smartplugconnect.phicomm.com/$(nvram get lan_ipaddr)" > $CONFIG_FILE
	service restart_dnsmasq

	if [ ! -e "/jffs/softcenter/init.d/S97dc1svr.sh" ]; then 
		cp -f /jffs/softcenter/scripts/dc1svr.sh /jffs/softcenter/init.d/S97dc1svr.sh
	fi
}
stop_dc1(){
	killall dc1svr
	rm $CONFIG_FILE
	rm /jffs/softcenter/init.d/S97dc1svr.sh
	service restart_dnsmasq
}
startdc1(){
	if [ "$dc1svr_enable" == "1" ]; then
		logger "[软件中心]: 启动dc1服务器！"
		start_dc1
	else
		stop_dc1
	fi
}
case $ACTION in
	stop)
		stop_dc1
	;;
	*)
		startdc1
	;;
esac
