#!/bin/sh
eval `dbus export cpufreq_`
source /jffs/softcenter/scripts/base.sh

sh /jffs/softcenter/scripts/cpufreq_config.sh stop

find /jffs/softcenter/init.d/ -name "*cpufreq*" | xargs rm -rf
rm -rf /jffs/softcenter/bin/cpufreq-info
rm -rf /jffs/softcenter/bin/cpufreq-set
rm -rf /jffs/softcenter/res/icon-cpufreq.png
rm -rf /jffs/softcenter/scripts/cpufreq*.sh
rm -rf /jffs/softcenter/webs/Module_cpufreq.asp
rm -rf /jffs/softcenter/lib/libcpufreq.so
rm -rf /jffs/softcenter/lib/libcpufreq.so.0
rm -rf /jffs/softcenter/lib/libcpufreq.so.0.0.0
rm -f /jffs/softcenter/scripts/uninstall_cpufreq.sh
