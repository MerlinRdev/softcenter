#!/bin/sh

source /jffs/softcenter/scripts/base.sh
#eval `dbus export filebrowser_`
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'
LOG_FILE="/tmp/filebrowser/filebrowser.log"
lan_ipaddr=$(nvram get lan_ipaddr)
dbpath=/jffs/softcenter/bin/filebrowser.db
dbpath_tmp=/tmp/filebrowser/filebrowser.db

port=$(dbus list filebrowser_port | grep -o "filebrowser_port.*"|awk -F\= '{print $2}')
#enable=$(dbus list filebrowser_enable | grep -o "filebrowser_enable.*"|awk -F\= '{print $2}')
watchdog=$(dbus list filebrowser_watchdog | grep -o "filebrowser_watchdog.*"|awk -F\= '{print $2}')
watchdog_delay_time=$(dbus list filebrowser_delay_time | grep -o "filebrowser_delay_time.*"|awk -F\= '{print $2}')
publicswitch=$(dbus list filebrowser_publicswitch | grep -o "filebrowser_publicswitch.*"|awk -F\= '{print $2}')
uploaddatabase=$(dbus list filebrowser_uploaddatabase | grep -o "filebrowser_uploaddatabase.*"|awk -F\= '{print $2}')
#echo_date "TEST" >> $LOG_FILE

#http_response $1
# mkdir -p /tmp/bin

auto_start() {
	#echo "创建开机重启任务"
	echo_date "创建开机重启任务" >> $LOG_FILE
	[ ! -L "/jffs/softcenter/init.d/S99filebrowser.sh" ] && ln -sf /jffs/softcenter/scripts/filebrowser_start.sh /jffs/softcenter/init.d/S99filebrowser.sh
}
write_watchdog_job(){
	#echo "创建看门狗任务"
	sed -i '/filebrowser_watchdog/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	if [ "$watchdog" == "1" ]; then
		echo_date "创建看门狗任务" >> $LOG_FILE
    	cru a filebrowser_watchdog  "*/$watchdog_delay_time * * * * /bin/sh /jffs/softcenter/scripts/filebrowser_watchdog.sh"
	fi
}

write_backup_job(){
	#echo "创建数据库备份任务"
	sed -i '/filebrowser_backupdb/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	echo_date "创建数据库备份任务" >> $LOG_FILE
    cru a filebrowser_backupdb  "*/1 * * * * /bin/sh /jffs/softcenter/scripts/filebrowser_backupdb.sh"
}

kill_cron_job() {
	if [ -n "$(cru l | grep filebrowser_watchdog)" ]; then
		echo_date 删除filebrowser看门狗任务...
		sed -i '/filebrowser_watchdog/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	fi
	if [ -n "$(cru l | grep filebrowser_backupdb)" ]; then
		echo_date 删除filebrowser数据库备份任务...
		sed -i '/filebrowser_backupdb/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	fi
}
public_access(){
	if [ "$publicswitch" == "1" ]; then
		echo_date "开启$port端口公网访问" >> $LOG_FILE 
		iptables -I INPUT -p tcp --dport $port -j ACCEPT
	else
		echo_date "关闭$port端口公网访问" >> $LOG_FILE 
		iptables -D INPUT -p tcp --dport $port -j ACCEPT
	fi
}
upload_db(){
	if [ -f "/tmp/upload/$uploaddatabase" ]; then
		echo_date "执行数据库还原工作" >> $LOG_FILE
		#先停止filebrowser
		close_fb
		rm -rf /tmp/$uploaddatabase
		cp -rf /tmp/upload/$uploaddatabase /tmp/filebrowser/$uploaddatabase
		rm -rf /tmp/upload/$uploaddatabase
	else
		echo_date "没找到数据库文件" >> $LOG_FILE
		rm -rf /tmp/upload/*.db
		exit 1
	fi	
}
close_fb(){
	filebrowser_process=$(pidof filebrowser);
	if [ -n "$filebrowser_process" ]; then
		killall filebrowser >/dev/null 2>&1
		kill_cron_job
		dbus set filebrowser_watchdog=0
		dbus set filebrowser_publicswitch=0
		public_access
	fi	
}

start_fb(){
	if [ -n "$filebrowser_process" ]; then
		killall filebrowser >/dev/null 2>&1
		kill_cron_job
		public_access
	fi
	#if [ ! -f "$dbpath" ] && [ ! -f "$dbpath_tmp" ]; then
	#	echo_date "初次启动" >> $LOG_FILE
    	  if [ -f "$dbpath" ] && [ ! -f "$dbpath_tmp" ]; then
		echo_date "初次/开机启动，迁移数据库至/tmp/filebrowser目录" >> $LOG_FILE
		cp -rf $dbpath $dbpath_tmp
	else
		echo_date "无需对数据库进行操作" >> $LOG_FILE
	fi

	[ ! -L "/tmp/filebrowser/filebrowser" ] && ln -sf /jffs/softcenter/bin/filebrowser /tmp/filebrowser/filebrowser
	cd /tmp/filebrowser
    ./filebrowser -a "$lan_ipaddr" -p $port -r // >/dev/null 2>&1 &
	sleep 5s
	filebrowser_process=$(pidof filebrowser);
	if [ -n "$filebrowser_process" ]; then
		echo_date "启动完成，pid：$filebrowser_process" >> $LOG_FILE
		sleep 1s
		auto_start
		write_watchdog_job
		write_backup_job
		public_access
	fi	
}
case $ACTION in
start)
	logger "[软件中心]: 开机启动FileBrowser！"
	echo_date "[软件中心]: 开机启动FileBrowser！" >> $LOG_FILE
	#echo_date "启动FileBrowser" >> $LOG_FILE
	start_fb	
	;;
restart)
	#echo_date "启动FileBrowser" >> $LOG_FILE
	start_fb	
	;;
stop)
	#echo_date "关闭FileBrowser" >> $LOG_FILE
	close_fb
	;;
upload)
	upload_db
	;;
esac
