#!/bin/sh

source /jffs/softcenter/scripts/base.sh

find /jffs/softcenter/init.d/ -name "*cfddns*" | xargs rm -rf

cp -rf /tmp/cfddns/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/cfddns/webs/* /jffs/softcenter/webs/
cp -rf /tmp/cfddns/res/* /jffs/softcenter/res/
cp -rf /tmp/cfddns/uninstall.sh /jffs/softcenter/scripts/uninstall_cfddns.sh

rm -rf /tmp/cfddns* >/dev/null 2>&1
chmod +x /jffs/softcenter/scripts/cfddns*.sh
chmod +x /jffs/softcenter/scripts/uninstall_cfddns.sh
if [ "$(nvram get productid)" = "BLUECAVE" ];then
cp -r /jffs/softcenter/scripts/cfddns_config.sh /jffs/softcenter/init.d/M99cfddns.sh
else
[ ! -L "/jffs/softcenter/init.d/S99cfddns.sh" ] && ln -sf /jffs/softcenter/scripts/cfddns_config.sh /jffs/softcenter/init.d/S99cfddns.sh
fi
#离线安装用
dbus set cfddns_version="1.0"
dbus set softcenter_module_cfddns_version="1.0"
dbus set softcenter_module_cfddns_description="CloudFlare DDNS"
dbus set softcenter_module_cfddns_install="1"
dbus set softcenter_module_cfddns_name="cfddns"
dbus set softcenter_module_cfddns_title="CloudFlare DDNS"
