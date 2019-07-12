#!/bin/sh

eval `dbus export serverchan_`
source /jffs/softcenter/scripts/base.sh

serverchan_nat_start(){
	if [ "${serverchan_enable}"x = "1"x ];then
		dbus remove __event__onnatstart_serverchan
		dbus set __event__onnatstart_serverchan="/jffs/softcenter/scripts/serverchan_config.sh"
	else
		dbus remove __event__onnatstart_serverchan
	fi
}

start_serverchan(){
	/jffs/softcenter/scripts/serverchan_check.sh &
}

stop_serverchan() {
	killall -9 serverchan_check.sh >/dev/null 2>&1
}

restart_serverchan() {
	stop_serverchan
	sleep 1
	if [ "$serverchan_enable" == "1" ] ;then
		start_serverchan
	fi
}

case ${ACTION} in
stop)
	stop_serverchan
	serverchan_nat_start
	;;
*)
	restart_serverchan
	serverchan_nat_start
	;;
esac
