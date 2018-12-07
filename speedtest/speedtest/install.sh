#!/bin/sh
cd /tmp
cp -rf /tmp/speedtest/scripts/speedtest_config.sh /jffs/softcenter/scripts/
cp -rf /tmp/speedtest/bin/speedtest /jffs/softcenter/bin/
cp -rf /tmp/speedtest/webs/Module_speedtest.asp /jffs/softcenter/webs/
rm -rf /tmp/speedtest* >/dev/null 2>&1

chmod a+x /jffs/softcenter/scripts/*.sh
chmod a+x /jffs/softcenter/bin/speedtest
