#!/bin/sh

eval `dbus export cpufreq`
start(){
if [ -n "$cpufreq_set" ];then
	[ -z "`echo ${LD_LIBRARY_PATH} |grep jffs`" ] && export LD_LIBRARY_PATH=/jffs/softcenter/lib:/lib:/usr/lib:/opt/lantiq/usr/lib:/opt/lantiq/usr/sbin/:/tmp/wireless/lantiq/usr/lib/:${LD_LIBRARY_PATH}
	[ "$cpufreq_set" -gt "$cpufreq_max" ] && echo "$(date "+%F %T"): 频率设置错误" >> /tmp/cpufreq.log && exit 1
	[ "$cpufreq_set" -lt 150 ] && echo "$(date "+%F %T"): 频率设置错误" >> /tmp/cpufreq.log && exit 1
	if [ "$cpufreq_set" -eq 667 ] ;then
		/jffs/softcenter/bin/cpufreq-set -f 666666
	else
		/jffs/softcenter/bin/cpufreq-set -f ${cpufreq_set}MHz
	fi
	echo "$(date "+%F %T"): 已设置频率：${cpufreq_set}MHz" >> /tmp/cpufreq.log
	/jffs/softcenter/scripts/cpufreq_status.sh
fi
}

stop(){
[ -e "/jffs/softcenter/init.d/M99cpufreq.sh" ] && rm -rf /jffs/softcenter/init.d/M99cpufreq.sh
}
restart() {
	if [ "`dbus get cpufreq_enable`" == "1" ];then
		[ ! -e "/jffs/softcenter/init.d/M99cpufreq.sh" ] && cp -r /jffs/softcenter/scripts/cpufreq_config.sh /jffs/softcenter/init.d/M99cpufreq.sh
		echo "$(date "+%F %T"): 已开启自动频率设置" >> /tmp/cpufreq.log
		start
	else
		echo "$(date "+%F %T"): 插件未启用,已关闭自动频率设置" >> /tmp/cpufreq.log
		stop
	fi
}

restart

