#! /bin/sh
source /jffs/softcenter/scripts/base.sh

aria2_pid=`pidof aria2c`
aria2_version=`/jffs/softcenter/bin/aria2c --version | head -n 1`
if [ -n "$aria2_pid" ];then
    echo 进程运行正常！${aria2_version}（PID：$aria2_pid） > /tmp/.aria2.log
else
    echo \<em\>【警告】：进程未运行！\<\/em\> ${aria2_version} > /tmp/.aria2.log
fi
echo XU6J03M6 >> /tmp/.aria2.log
#博通的https性能太低交由系统在下次更新时清空
#sleep 2
#rm -rf /tmp/.aria2.log
