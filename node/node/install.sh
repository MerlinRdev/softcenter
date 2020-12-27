#! /bin/sh

source /jffs/softcenter/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
DIR=$(cd $(dirname $0); pwd)
MODEL=$(nvram get productid)
if [ "$MODEL" == "GT-AC5300" ] || [ "$MODEL" == "GT-AX11000" ] || [ "$MODEL" == "GT-AC2900" ] || [ "$(nvram get merlinr_rog)" == "1" ];then
	ROG=1
elif [ "$MODEL" == "TUF-AX3000" ] || [ "$(nvram get merlinr_tuf)" == "1" ] ;then
	TUF=1
fi
enable=`dbus get node_enable`
if [ "$enable" == "1" ] && [ -f "/jffs/softcenter/scripts/node_config.sh" ];then
	/jffs/softcenter/scripts/node_config.sh stop >/dev/null 2>&1
fi
echo_date "开始安装node"
find /jffs/softcenter/init.d/ -name "*node*" | xargs rm -rf
mkdir -p /jffs/softcenter/lib

cp -rf /tmp/node/bin/* /jffs/softcenter/bin/
cp -rf /tmp/node/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/node/lib/* /jffs/softcenter/lib/
cp -rf /tmp/node/webs/* /jffs/softcenter/webs/
cp -rf /tmp/node/res/* /jffs/softcenter/res/
cp -rf /tmp/node/uninstall.sh /jffs/softcenter/scripts/uninstall_node.sh
if [ "$ROG" == "1" ];then
	continue
elif [ "$TUF" == "1" ];then
	sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /jffs/softcenter/webs/Module_node.asp >/dev/null 2>&1
else
	sed -i '/rogcss/d' /jffs/softcenter/webs/Module_node.asp >/dev/null 2>&1
fi

chmod +x /jffs/softcenter/scripts/*
chmod +x /jffs/softcenter/bin/*



cp -rf /jffs/softcenter/scripts/node_config.sh /jffs/softcenter/init.d/S99node.sh

dbus set node_version="$(cat $DIR/version)"
dbus set softcenter_module_node_version="$(cat $DIR/version)"
dbus set softcenter_module_node_description="node.js"
dbus set softcenter_module_node_install=1
dbus set softcenter_module_node_name=node
dbus set softcenter_module_node_title="node.js"
dbus set node_bin_version="8.17.0"
if [ "$enable" == "1" ] && [ -f "/jffs/softcenter/scripts/node_config.sh" ];then
	/jffs/softcenter/scripts/node_config start >/dev/null 2>&1
fi

rm -fr /tmp/node* >/dev/null 2>&1
echo_date "node插件安装完毕！"
exit 0

