#!/bin/sh 

eval `dbus export baidupcs_`
source /jffs/softcenter/scripts/base.sh
alias echo_date='echo $(date +%Y年%m月%d日\ %X):'

baidu_nat_start(){
	if [ "${baidupcs_enable}"x = "1"x ];then
		echo_date 添加nat-start触发事件... >> /tmp/baidupcs.log
		cp -r /jffs/softcenter/scripts/baidupcs_config.sh /jffs/softcenter/init.d/M98baidupcs.sh
	else
		echo_date 删除nat-start触发... >> /tmp/baidupcs.log
		rm -rf /jffs/softcenter/init.d/M98baidupcs.sh
	fi
}

stop_baidu() {
	killall -9 BaiduPCS >/dev/null 2>&1
}

get_function_switch() {
	case "$1" in
		1)
			echo "true"
		;;
		0|*)
			echo "false"
		;;
	esac
}
creat_baidu_json(){
	local savedir maxdown https
	#rm -rf /root/.config/BaiduPCS-Go/pcs_config.json
	[ -z "$baidupcs_savedir" ] && dbus set baidupcs_savedir="/tmp/mnt/${baidupcs_disk}" && eval `dbus export baidupcs_savedir`
	[ -z "$baidupcs_max_download" ] && dbus set baidupcs_max_download=2 && eval `dbus export baidupcs_max_download`
	if [ ! -e "/jffs/softcenter/bin/pcs_config.json" ]; then
	echo_date 生成配置文件 >> /tmp/baidupcs.log
	cat >> /jffs/softcenter/bin/pcs_config.json <<-EOF
{
 "baidu_active_uid": 0,
 "baidu_user_list": null,
 "appid": 266719,
 "cache_size": 30000,
 "max_parallel": 100,
 "max_upload_parallel": 10,
 "max_download_load": $baidupcs_max_download,
 "user_agent": "netdisk;8.3.1;android-android",
 "savedir": "$baidupcs_savedir",
 "enable_https": $(get_function_switch $baidupcs_https),
 "proxy": "",
 "access_pass": "",
 "local_addrs": "",
 "download_opts": {
  "IsExecutedPermission": false,
  "IsOverwrite": false,
  "IsShareDownload": false,
  "IsLocateDownload": false,
  "IsLocatePanAPIDownload": false,
  "IsStreaming": false,
  "NoCheck": false
 },
 "sessions": {
  
 }
}
EOF
	else
		savedir=`cat /jffs/softcenter/bin/pcs_config.json |grep savedir |grep ${baidupcs_savedir}`
		if [ -z "$savedir" ]; then
			sed -i "s/ \"savedir\": .*$/ \"savedir\": \"$baidupcs_savedir\",/" /jffs/softcenter/bin/pcs_config.json
		fi
		maxdown=`cat /jffs/softcenter/bin/pcs_config.json |grep max_download_load |grep ${baidupcs_max_download}`
		if [ -z "$maxdown" ]; then
			sed -i "s/ \"max_download_load\": .*$/ \"max_download_load\": $baidupcs_max_download,/" /jffs/softcenter/bin/pcs_config.json
		fi
		https=`cat /jffs/softcenter/bin/pcs_config.json |grep enable_https |grep $(get_function_switch $baidupcs_https)`
		if [ -z "$https" ]; then
			sed -i "s/ \"enable_https\": .*$/ \"enable_https\": $(get_function_switch $baidupcs_https),/" /jffs/softcenter/bin/pcs_config.json
		fi
	fi
	export BAIDUPCS_GO_CONFIG_DIR=/jffs/softcenter/bin
	#cp -r /jffs/softcenter/bin/pcs_config.json /root/.config/BaiduPCS-Go/pcs_config.json
}

start_baidu() {
	local checkdisk
	checkdisk=`ls /tmp/mnt |grep ${baidupcs_disk}`
	if [ -z "$checkdisk" ]; then
		echo_date 未检测到指定挂载的USB设备 >> /tmp/baidupcs.log
		dbus set baidupcs_enable=0
		exit 1
	fi
	creat_baidu_json
	echo_date 启动百度盘 >> /tmp/baidupcs.log
	/jffs/softcenter/bin/BaiduPCS >> /tmp/baidupcs.log &
}
restart_baidu() {
	stop_baidu
	sleep 1
	if [ "$baidupcs_enable" == "1" ] ;then
		start_baidu
	fi
}

case $1 in
stop)
	stop_baidu
	baidu_nat_start
	;;
*)
	restart_baidu
	baidu_nat_start
	;;
esac
