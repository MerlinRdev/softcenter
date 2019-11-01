#! /bin/sh
source /jffs/softcenter/scripts/base.sh

aria2_pid=`pidof aria2c`
aria2_version=`/jffs/softcenter/bin/aria2c --version | head -n 1`
if [ -n "$aria2_pid" ];then
    echo "${aria2_version} 进程运行正常！（PID：$aria2_pid）" > /tmp/aria2.log
else
    echo "${aria2_version} 进程未运行！" > /tmp/aria2.log
fi

