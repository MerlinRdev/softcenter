#!/bin/sh

source /jffs/softcenter/scripts/base.sh

killall frps
find /jffs/softcenter/init.d/ -name "*frps*" | xargs rm -rf
rm -rf /jffs/softcenter/res/icon-frps.png
rm -rf /jffs/softcenter/res/frps_check.html
rm -rf /jffs/softcenter/res/frps_ini.html
rm -rf /jffs/softcenter/res/frps_stcp.html
rm -rf /jffs/softcenter/scripts/frps*.sh
rm -rf /jffs/softcenter/webs/Module_frps.asp
rm -f /jffs/softcenter/scripts/uninstall_frps.sh
