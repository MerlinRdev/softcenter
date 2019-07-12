#! /bin/sh

export KSROOT=/jffs/softcenter
source $KSROOT/scripts/base.sh
find /jffs/softcenter/init.d/ -name "*cpufreq*" | xargs rm -rf
mkdir -p /jffs/softcenter/lib
cp -rf /tmp/cpufreq/bin/* /jffs/softcenter/bin/
cp -rf /tmp/cpufreq/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/cpufreq/webs/* /jffs/softcenter/webs/
cp -rf /tmp/cpufreq/lib/* /jffs/softcenter/lib/
cp -rf /tmp/cpufreq/res/* /jffs/softcenter/res/
cp -rf /tmp/cpufreq/uninstall.sh /jffs/softcenter/scripts/uninstall_cpufreq.sh

rm -fr /tmp/cpufreq* >/dev/null 2>&1
chmod +x /jffs/softcenter/scripts/cpufreq*.sh
chmod +x /jffs/softcenter/scripts/uninstall_cpufreq.sh
cp -rf /jffs/softcenter/scripts/cpufreq_config.sh /jffs/softcenter/init.d/M40cpufreq.sh

dbus set cpufreq_version="1.0"
dbus set softcenter_module_cpufreq_version="1.0"
dbus set softcenter_module_cpufreq_description="Intel CPU频率设置"
dbus set softcenter_module_cpufreq_install=1
dbus set softcenter_module_cpufreq_name=cpufreq
dbus set softcenter_module_cpufreq_title="CPU频率设置"

