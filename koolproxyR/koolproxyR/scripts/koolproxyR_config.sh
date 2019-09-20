#!/bin/sh

alias echo_date1='echo $(date +%Y年%m月%d日\ %X)'
source /jffs/softcenter/scripts/base.sh
eval `dbus export koolproxyR_`

echo "" > /tmp/kpr_log.txt
sleep 1
case $1 in
start)
	sh /jffs/softcenter/koolproxyR/kp_config.sh start
	;;
clean)
	#do nothing
	;;
restart)
	if [[ "$koolproxyR_enable" == "1" ]]; then
		sh /jffs/softcenter/koolproxyR/kp_config.sh restart >> /tmp/kpr_log.txt 2>&1
	else
		sh /jffs/softcenter/koolproxyR/kp_config.sh stop >> /tmp/kpr_log.txt 2>&1
	fi
	echo XU6J03M6 >> /tmp/kpr_log.txt
	sleep 1
	rm -rf /tmp/kpr_log.txt
	;;
esac


