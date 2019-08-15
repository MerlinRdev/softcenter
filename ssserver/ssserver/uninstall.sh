#!/bin/sh

sh /jffs/softcenter/scripts/ssserver_config.sh stop
rm /jffs/softcenter/bin/ss-server
rm /jffs/softcenter/bin/obfs-server
rm /jffs/softcenter/scripts/uninstall_ssserver.sh
rm /jffs/softcenter/res/icon-ssserver.png
rm /jffs/softcenter/scripts/ssserver*
rm /jffs/softcenter/webs/Module_ssserver.asp
find /jffs/softcenter/init.d/ -name "*ssserver*" | xargs rm -rf
