#!/bin/sh

source /jffs/softcenter/scripts/base.sh
zerotier_pid=`which zerotier`
if [ -n "$zerotier_pid" ];then
	zerotier_log="zerotier is running"
else
	zerotier_log="zerotier is disabled"
fi

echo "$zerotier_log" > /tmp/zerotier_status.log
