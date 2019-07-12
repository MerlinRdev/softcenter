#! /bin/sh

source /jffs/softcenter/scripts/base.sh
cd /tmp
cp -rf /tmp/qiandao/bin/* /jffs/softcenter/bin/
cp -rf /tmp/qiandao/res/* /jffs/softcenter/res/
cp -rf /tmp/qiandao/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/qiandao/webs/* /jffs/softcenter/webs/
cp -rf /tmp/qiandao/uninstall.sh /jffs/softcenter/scripts/uninstall_qiandao.sh
rm -rf /tmp/qiandao* >/dev/null 2>&1
rm -rf /jffs/softcenter/init.d/*qiandao.sh
sleep 1
if [ "$(nvram get productid)" = "BLUECAVE" ];then
	cp -r /jffs/softcenter/scripts/qiandao_config.sh /jffs/softcenter/init.d/M99qiandao.sh
else
	[ ! -L "/jffs/softcenter/init.d/S99qiandao.sh" ] && cp -r /jffs/softcenter/scripts/qiandao_config.sh /jffs/softcenter/init.d/S99qiandao.sh
fi
chmod 755 /jffs/softcenter/bin/qiandao
chmod 755 /jffs/softcenter/init.d/*
chmod 755 /jffs/softcenter/scripts/qiandao*

dbus set qiandao_action="2"

