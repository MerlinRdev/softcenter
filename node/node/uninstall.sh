#!/bin/sh
eval `dbus export node_`
source /jffs/softcenter/scripts/base.sh

sh /jffs/softcenter/scripts/node_config.sh stop

find /jffs/softcenter/init.d/ -name "*node*" | xargs rm -rf
rm -rf /jffs/softcenter/res/icon-node.png
rm -rf /jffs/softcenter/scripts/node*.sh
rm -rf /jffs/softcenter/webs/Module_node.asp
rm -rf /jffs/softcenter/bin/node
rm -rf /jffs/softcenter/bin/JDCookie.crx
find /jffs/softcenter/lib/ -name "*openssl*" | xargs rm -rf
rm -f /jffs/softcenter/scripts/uninstall_node.sh
