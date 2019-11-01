#!/bin/sh

source /jffs/softcenter/scripts/base.sh
DIR=$(cd $(dirname $0); pwd)
frpc_enable=`dbus get frpc_enable`

if [ "$frpc_enable" == "1" ];then
	killall frpc
fi

cp -rf /tmp/frpc/bin/* /jffs/softcenter/bin/
cp -rf /tmp/frpc/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/frpc/webs/* /jffs/softcenter/webs/
cp -rf /tmp/frpc/res/* /jffs/softcenter/res/
cp -rf /tmp/frpc/uninstall.sh /jffs/softcenter/scripts/uninstall_frpc.sh
if [ "`nvram get model`" == "GT-AC5300" ] || [ "`nvram get model`" == "GT-AC2900" ];then
	cp -rf /tmp/frpc/ROG/webs/* /jffs/softcenter/webs/
fi

chmod +x /jffs/softcenter/bin/*
chmod +x /jffs/softcenter/scripts/frpc*.sh
chmod +x /jffs/softcenter/scripts/uninstall_frpc.sh

# for offline install
dbus set frpc_version="$(cat $DIR/version)"
dbus set softcenter_module_frpc_install="1"
dbus set softcenter_module_frpc_name="frpc"
dbus set softcenter_module_frpc_title="frpc内网穿透"
dbus set softcenter_module_frpc_description="支持多种协议的内网穿透软件"
sleep 1
rm -fr /tmp/frpc* >/dev/null 2>&1
if [ "$frpc_enable" == "1" ];then
	[ -f "/jffs/softcenter/scripts/frpc_config.sh" ] && sh /jffs/softcenter/scripts/frpc_config.sh start
fi

