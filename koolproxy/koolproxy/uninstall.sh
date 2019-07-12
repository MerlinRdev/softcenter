#! /bin/sh

sh /jffs/softcenter/koolproxy/koolproxy.sh stop
rm -rf /jffs/softcenter/bin/koolproxy >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/ >/dev/null 2>&1
rm -rf /jffs/softcenter/res/koolproxy_check.htm
rm -rf /jffs/softcenter/res/koolproxy_run.htm
rm -rf /jffs/softcenter/res/koolproxy_user.htm
rm -rf /jffs/softcenter/scripts/koolproxy* >/dev/null 2>&1
rm -rf /jffs/softcenter/webs/Module_koolproxy.asp >/dev/null 2>&1
rm -rf /jffs/softcenter/res/icon-koolproxy.png >/dev/null 2>&1
find /jffs/softcenter/init.d/ -name "*koolproxy*" | xargs rm -rf
