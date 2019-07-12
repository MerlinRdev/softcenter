#!/bin/sh

source /jffs/softcenter/scripts/base.sh

pid=`pidof fcn`

if [ -n "$pid" ];then
	echo "FCN运行正常(PID: $pid)" > /tmp/fcn_status.log
else
	echo "<font color='#FF0000'>FCN未运行！</font>" > /tmp/fcn_status.log
fi
