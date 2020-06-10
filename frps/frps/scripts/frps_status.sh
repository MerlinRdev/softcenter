#! /bin/sh

source /jffs/softcenter/scripts/base.sh

frps_pid=`pidof frps`
frps_version=`dbus get frps_client_version`
if [ -n "$frps_pid" ];then
	echo "frps  $frps_version  进程运行正常！（PID：$frps_pid）" > /tmp/frps_status.log
else
	echo "frps  $frps_version 【警告】：进程未运行！" > /tmp/frps_status.log
fi
echo XU6J03M6 >> /tmp/frps_status.log
#sleep 2
rm -rf /tmp/.frps.log
