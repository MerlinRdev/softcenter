#!/bin/sh

cp -r /tmp/aliddns/* /jffs/softcenter/
chmod a+x /jffs/softcenter/scripts/aliddns_*

rm -rf /jffs/softcenter/install.sh

# add icon into softerware center
# dbus set softcenter_module_aliddns_install=1
# dbus set softcenter_module_aliddns_version=0.4
# dbus set softcenter_module_aliddns_description="阿里云解析自动更新IP"
