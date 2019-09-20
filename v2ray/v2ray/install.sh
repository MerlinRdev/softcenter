#! /bin/sh
cd /tmp
cp -rf /tmp/v2ray/bin/* /jffs/softcenter/bin/
cp -rf /tmp/v2ray/webs/Module_v2ray.asp /jffs/softcenter/webs/
cp -rf /tmp/v2ray/res/* /jffs/softcenter/res/
cp -rf /tmp/v2ray/scripts/*.sh /jffs/softcenter/scripts/
cp -rf /tmp/v2ray/scripts/gfwlist.conf /jffs/softcenter/scripts/
cp -rf /tmp/v2ray/scripts/gfw_addr.conf /jffs/softcenter/scripts/
cd /
rm -rf /tmp/v2ray* >/dev/null 2>&1


chmod 755 /jffs/softcenter/bin/*
chmod 755 /jffs/softcenter/scripts/*.sh

