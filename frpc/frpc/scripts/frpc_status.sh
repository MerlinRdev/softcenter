#! /bin/sh

eval `dbus export frpc_`
source /jffs/softcenter/scripts/base.sh

frpc_pid=`pidof frpc`
frpc_version=`/jffs/softcenter/bin/frpc -v`
if [ -n "$frpc_pid" ];then
    echo 进程运行正常！版本：${frpc_version} （PID：${frpc_pid}）> /tmp/.frpc.log
else
    echo \<em\>【警告】：进程未运行！\<\/em\> 版本：${frpc_version} > /tmp/.frpc.log
fi
echo XU6J03M6 >> /tmp/.frpc.log
#sleep 2
#rm -rf /tmp/.frpc.log
