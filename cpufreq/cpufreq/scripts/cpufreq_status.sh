#!/bin/sh
[ -z "`echo ${LD_LIBRARY_PATH} |grep jffs`" ] && export LD_LIBRARY_PATH=/jffs/softcenter/lib:/lib:/usr/lib:/opt/lantiq/usr/lib:/opt/lantiq/usr/sbin/:/tmp/wireless/lantiq/usr/lib/:${LD_LIBRARY_PATH}
/jffs/softcenter/bin/cpufreq-info -c 0 > /tmp/cpufreq-info 2>&1

freq_cur=$(cat /tmp/cpufreq-info |grep 'current CPU' |awk '{printf $5}')
freq_max=$(cat /tmp/cpufreq-info |grep 'hardware limits' |awk '{printf $6}')

dbus set cpufreq_cur=$freq_cur
dbus set cpufreq_max=$freq_max


