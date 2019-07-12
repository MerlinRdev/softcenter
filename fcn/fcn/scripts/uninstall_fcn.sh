#!/bin/sh

rm -f /jffs/softcenter/scripts/fcn_*.sh
rm -f /jffs/softcenter/bin/fcn
rm -f /jffs/softcenter/webs/Module_fcn.asp
find /jffs/softcenter/init.d/ -name "*fcn.sh" | xargs rm -rf
rm -f /jffs/softcenter/res/icon-fcn.png
rm -f /jffs/softcenter/res/fcn_status.htm

dbus remove fcn_version

rm -f /jffs/softcenter/scripts/uninstall_fcn.sh
