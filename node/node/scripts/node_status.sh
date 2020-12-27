#!/bin/sh

source /jffs/softcenter/scripts/base.sh
eval `dbus export node_`
node_ok=`which node`
if [ "$node_enable" == "0" ];then
	echo "node is disable" > /tmp/node_status.log
	exit 0
fi
if [ -n "$node_ok" ];then
	node_version="version:${node_bin_version}"
else
	node_version="node is not installed"
fi
if [ "$node_jd_enable" == "1" ];then
	jd_log="京东签到启用"
fi
echo "$node_version $jd_log" > /tmp/node_status.log
