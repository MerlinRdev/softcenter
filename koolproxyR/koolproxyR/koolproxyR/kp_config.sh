#! /bin/sh

alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
source /jffs/softcenter/scripts/base.sh
eval `dbus export koolproxyR_`
SOFT_DIR=/jffs/softcenter
KP_DIR=/jffs/softcenter/koolproxyR
lan_ipaddr=$(nvram get lan_ipaddr)
LOCK_FILE=/var/lock/koolproxyR.lock
#=======================================

set_lock(){
	exec 1000>"$LOCK_FILE"
	flock -x 1000
}

unset_lock(){
	flock -u 1000
	rm -rf "$LOCK_FILE"
}

get_lan_cidr(){
	netmask=`nvram get lan_netmask`
	local x=${netmask##*255.}
	set -- 0^^^128^192^224^240^248^252^254^ $(( (${#netmask} - ${#x})*2 )) ${x%%.*}
	x=${1%%$3*}
	suffix=$(( $2 + (${#x}/4) ))
	#prefix=`nvram get lan_ipaddr | cut -d "." -f1,2,3`
	echo $lan_ipaddr/$suffix
}

write_sourcelist(){
	if [ -n "$koolproxyR_sourcelist" ];then
		echo $koolproxyR_sourcelist|sed 's/>/\n/g' > /jffs/softcenter/koolproxyR/data/source.list
	else
		cat > /jffs/softcenter/koolproxyR/data/source.list <<-EOF
			1|koolproxy.txt|https://kprule.com/koolproxy.txt|
			1|daily.txt|https://kprule.com/daily.txt|
			1|kp.dat|https://kprule.com/kp.dat|
			1|user.txt||
			
		EOF
	fi
	
	if [ -n "$koolproxyR_custom_rule" ];then
		echo $koolproxyR_custom_rule| base64_decode |sed 's/\\n/\n/g' > /jffs/softcenter/koolproxyR/data/rules/user.txt
		dbus remove koolproxyR_custom_rule
	fi
}

detect_start_up(){
	if [ "$(nvram get productid)" = "BLUECAVE" ];then
		[ ! -f "/jffs/softcenter/init.d/M98koolproxyR.sh" ] && cp -r /jffs/softcenter/koolproxyR/kp_config.sh /jffs/softcenter/init.d/M98koolproxyR.sh
		[ ! -f "/jffs/softcenter/init.d/N98koolproxyR.sh" ] && cp -r /jffs/softcenter/koolproxyR/kp_config.sh /jffs/softcenter/init.d/N98koolproxyR.sh
	else
		[ ! -L "/jffs/softcenter/init.d/S98koolproxyR.sh" ] && ln -sf /jffs/softcenter/koolproxyR/kp_config.sh /jffs/softcenter/init.d/S98koolproxyR.sh
		[ ! -L "/jffs/softcenter/init.d/N98koolproxyR.sh" ] && ln -sf /jffs/softcenter/koolproxyR/kp_config.sh /jffs/softcenter/init.d/N98koolproxyR.sh
	fi
}

start_koolproxyR(){
	write_sourcelist
	echo_date 开启koolproxyR主进程！
	if [ "$(nvram get productid)" = "BLUECAVE" ];then
		[ ! -f "/jffs/softcenter/bin/koolproxy" ] && cp -r /jffs/softcenter/koolproxyR/koolproxy /jffs/softcenter/bin/koolproxy
	else
		[ ! -L "/jffs/softcenter/bin/koolproxy" ] && ln -sf /jffs/softcenter/koolproxyR/koolproxy /jffs/softcenter/bin/koolproxy
	fi
	/jffs/softcenter/koolproxyR/koolproxy --mark -d
	[ "$?" != "0" ] && dbus set koolproxyR_enable=0 && exit 1
}

stop_koolproxyR(){
	if [ -n "`pidof koolproxy`" ];then
		echo_date 关闭koolproxyR主进程...
		kill -9 `pidof koolproxy` >/dev/null 2>&1
		killall koolproxy >/dev/null 2>&1
	fi
}

add_ipset_conf(){
	if [ "$koolproxyR_mode" == "2" ];then
		echo_date 添加黑名单软连接...
		rm -rf /etc/dnsmasq.user/koolproxyR_ipset.conf
		ln -sf /jffs/softcenter/koolproxyR/data/koolproxyR_ipset.conf /etc/dnsmasq.user/koolproxyR_ipset.conf
		dnsmasq_restart=1
	fi
}

remove_ipset_conf(){
	if [ -L "/etc/dnsmasq.user/koolproxyR_ipset.conf" ];then
		echo_date 移除黑名单软连接...
		rm -rf /etc/dnsmasq.user/koolproxyR_ipset.conf
		dnsmasq_restart=1
	fi
}

restart_dnsmasq(){
	if [ "$dnsmasq_restart" == "1" ];then
		echo_date 重启dnsmasq进程...
		service restart_dnsmasq > /dev/null 2>&1
	fi
}

write_reboot_job(){
	# start setvice
	if [ "1" == "$koolproxyR_reboot" ]; then
		echo_date 开启插件定时重启，每天"$koolproxyR_reboot_hour"时"$koolproxyR_reboot_min"分，自动更新规则...
	
                cru a koolproxyR_reboot "$koolproxyR_reboot_min $koolproxyR_reboot_hour * * * /bin/sh /jffs/softcenter/scripts/kp.sh "

	elif [ "2" == "$koolproxyR_reboot" ]; then
		echo_date 开启插件间隔重启，每隔"$koolproxyR_reboot_inter_hour"时"$koolproxyR_reboot_inter_min"分，自动更新规则...
		
                cru a koolproxyR_reboot "0 */$koolproxyR_reboot_inter_hour * * * /bin/sh /jffs/softcenter/scripts/kp.sh "
	fi
}

remove_reboot_job(){
	jobexist=`cru l|grep koolproxyR_reboot`
	# kill crontab job
	if [ -n "$jobexist" ];then
		echo_date 关闭插件定时重启...
		sed -i '/koolproxyR_reboot/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	fi
}

creat_ipset(){
	xt=`lsmod | grep xt_set`
	OS=$(uname -r)
	if [ -z "$xt" ] && [ -f "/lib/modules/${OS}/kernel/net/netfilter/xt_set.ko" ];then
		echo_date "加载xt_set.ko内核模块！"
		insmod /lib/modules/${OS}/kernel/net/netfilter/xt_set.ko
	fi
	if [ -z "`lsmod | grep ip_set_bitmap_port`" ] && [ -f "/lib/modules/${OS}/kernel/net/netfilter/ipset/ip_set_bitmap_port.ko" ];then
		echo_date "加载ip_set_bitmap_port.ko内核模块！"
		insmod /lib/modules/${OS}/kernel/net/netfilter/ipset/ip_set_bitmap_port.ko
	fi
	echo_date 创建ipset名单
	ipset -! creat white_kp_list nethash
	ipset -! creat black_koolproxyR nethash
	ipset -! create kp_port_http bitmap:port range 0-65535
	ipset -! create kp_port_https bitmap:port range 0-65535
	
	ip_lan="0.0.0.0/8 10.0.0.0/8 100.64.0.0/10 127.0.0.0/8 169.254.0.0/16 172.16.0.0/12 192.168.0.0/16 224.0.0.0/4 240.0.0.0/4"
	for ip in $ip_lan
	do
		ipset -A white_kp_list $ip >/dev/null 2>&1
	done
	
	ports=`cat /jffs/softcenter/koolproxyR/data/rules/koolproxy.txt | grep -Eo "(.\w+\:[1-9][0-9]{1,4})/" | grep -Eo "([0-9]{1,5})" | sort -un`
	for port in $ports 80
	do
		ipset -A kp_port_http $port >/dev/null 2>&1
		ipset -A kp_port_https $port >/dev/null 2>&1
	done

	ipset -A kp_port_https 443 >/dev/null 2>&1
	ipset -A black_koolproxyR 110.110.110.110 >/dev/null 2>&1
}

get_mode_name() {
	case "$1" in
		0)
			echo "不过滤"
		;;
		1)
			echo "http模式"
		;;
		2)
			echo "http + https"
		;;
	esac
}

get_jump_mode(){
	case "$1" in
		0)
			echo "-j"
		;;
		*)
			echo "-g"
		;;
	esac
}

get_action_chain() {
	case "$1" in
		0)
			echo "RETURN"
		;;
		1)
			echo "KP_HTTP"
		;;
		2)
			echo "KP_HTTPS"
		;;
	esac
}

factor(){
	if [ -z "$1" ] || [ -z "$2" ]; then
		echo ""
	else
		echo "$2 $1"
	fi
}

flush_nat(){
	if [ -n "`iptables -t nat -S|grep koolproxyR`" ];then
		echo_date 移除nat规则...
		cd /tmp
		iptables -t nat -S | grep -E "koolproxyR|KP_HTTP|KP_HTTPS" | sed 's/-A/iptables -t nat -D/g'|sed 1,3d > clean.sh && chmod 777 clean.sh && ./clean.sh > /dev/null 2>&1 && rm clean.sh
		iptables -t nat -X koolproxyR > /dev/null 2>&1
		iptables -t nat -X KP_HTTP > /dev/null 2>&1
		iptables -t nat -X KP_HTTPS > /dev/null 2>&1
	fi
	[ -n "`ipset -L -n|grep black_koolproxyR`" ] && ipset -F black_koolproxyR > /dev/null 2>&1 && ipset -X black_koolproxyR > /dev/null 2>&1
	[ -n "`ipset -L -n|grep white_kp_list`" ] && ipset -F white_kp_list > /dev/null 2>&1 && ipset -X white_kp_list > /dev/null 2>&1
	[ -n "`ipset -L -n|grep kp_port_http`" ] && ipset -F kp_port_http > /dev/null 2>&1 && ipset -X kp_port_http > /dev/null 2>&1
	[ -n "`ipset -L -n|grep kp_port_https`" ] && ipset -F kp_port_https > /dev/null 2>&1 && ipset -X kp_port_https > /dev/null 2>&1
}

lan_acess_control(){
	# lan access control
	[ -z "$koolproxyR_acl_default" ] && koolproxyR_acl_default=1
	acl_nu=`dbus list koolproxyR_acl_mode|sort -n -t "=" -k 2|cut -d "=" -f 1 | cut -d "_" -f 4 | sort -n`
	if [ -n "$acl_nu" ]; then
		for min in $acl_nu
		do
			ipaddr=`dbus get koolproxyR_acl_ip_$min`
			mac=`dbus get koolproxyR_acl_mac_$min`
			proxy_name=`dbus get koolproxyR_acl_name_$min`
			proxy_mode=`dbus get koolproxyR_acl_mode_$min`
		
			[ "$koolproxyR_acl_method" == "1" ] && echo_date 加载ACL规则：【$ipaddr】【$mac】模式为：$(get_mode_name $proxy_mode)
			[ "$koolproxyR_acl_method" == "2" ] && mac="" && echo_date 加载ACL规则：【$ipaddr】模式为：$(get_mode_name $proxy_mode)
			[ "$koolproxyR_acl_method" == "3" ] && ipaddr="" && echo_date 加载ACL规则：【$mac】模式为：$(get_mode_name $proxy_mode)
			#echo iptables -t nat -A koolproxyR $(factor $ipaddr "-s") $(factor $mac "-m mac --mac-source") -p tcp $(get_jump_mode $proxy_mode) $(get_action_chain $proxy_mode)
			iptables -t nat -A koolproxyR $(factor $ipaddr "-s") $(factor $mac "-m mac --mac-source") -p tcp $(get_jump_mode $proxy_mode) $(get_action_chain $proxy_mode)
		done
		echo_date 加载ACL规则：其余主机模式为：$(get_mode_name $koolproxyR_acl_default)
	else
		echo_date 加载ACL规则：所有模式为：$(get_mode_name $koolproxyR_acl_default)
	fi
}

load_nat(){
	nat_ready=$(iptables -t nat -L PREROUTING -v -n --line-numbers|grep -v PREROUTING|grep -v destination)
	i=120
	# laod nat rules
	until [ -n "$nat_ready" ]
	do
	    i=$(($i-1))
	    if [ "$i" -lt 1 ];then
	        echo_date "Could not load nat rules!"
	        sh /jffs/softcenter/koolproxyR/kp_config.sh stop
	        exit
	    fi
	    sleep 1
		nat_ready=$(iptables -t nat -L PREROUTING -v -n --line-numbers|grep -v PREROUTING|grep -v destination)
	done
	
	echo_date 加载nat规则！
	#----------------------BASIC RULES---------------------
	echo_date 写入iptables规则到nat表中...
	# 创建koolproxyR nat rule
	iptables -t nat -N koolproxyR
	# 局域网地址不走KP
	iptables -t nat -A koolproxyR -m set --match-set white_kp_list dst -j RETURN
	#  生成对应CHAIN
	iptables -t nat -N KP_HTTP
	#iptables -t nat -A KP_HTTP -p tcp -m multiport --dport 80,82,8080 -j REDIRECT --to-ports 3000
	iptables -t nat -A KP_HTTP -p tcp -m set --match-set kp_port_http dst -j REDIRECT --to-ports 3000
	iptables -t nat -N KP_HTTPS
	#iptables -t nat -A KP_HTTPS -p tcp -m multiport --dport 80,82,443,8080 -j REDIRECT --to-ports 3000
	iptables -t nat -A KP_HTTPS -p tcp -m set --match-set kp_port_https dst -j REDIRECT --to-ports 3000
	# 局域网控制
	lan_acess_control
	# 剩余流量转发到缺省规则定义的链中
	iptables -t nat -A koolproxyR -p tcp -j $(get_action_chain $koolproxyR_acl_default)
	# 重定所有流量到 koolproxyR
	# 全局模式和视频模式
	[ "$koolproxyR_mode" == "1" ] || [ "$koolproxyR_mode" == "3" ] && iptables -t nat -I PREROUTING 1 -p tcp -j koolproxyR
	# ipset 黑名单模式
	[ "$koolproxyR_mode" == "2" ] && iptables -t nat -I PREROUTING 1 -p tcp -m set --match-set black_koolproxyR dst -j koolproxyR
}

dns_takeover(){
	ss_chromecast=`dbus get ss_basic_chromecast`
	lan_ipaddr=`nvram get lan_ipaddr`
	#chromecast=`iptables -t nat -L PREROUTING -v -n|grep "dpt:53"`
	chromecast_nu=`iptables -t nat -L PREROUTING -v -n --line-numbers|grep "dpt:53"|awk '{print $1}'`
	if [ "$koolproxyR_mode" == "2" ]; then
		if [ -z "$chromecast_nu" ]; then
			echo_date 黑名单模式开启DNS劫持
			iptables -t nat -A PREROUTING -p udp -s $(get_lan_cidr) --dport 53 -j DNAT --to $lan_ipaddr >/dev/null 2>&1
		fi
	fi
}

detect_cert(){
	if [ ! -f /jffs/softcenter/koolproxyR/data/private/ca.key.pem ]; then
		echo_date 检测到首次运行，开始生成koolproxyR证书，用于https过滤！
		cd /jffs/softcenter/koolproxyR/data && sh gen_ca.sh
		echo_date 证书生成完毕！！！
	fi
	ln -sf /jffs/softcenter/koolproxyR/data/certs/ca.crt /www/ext/kp.crt
}

case $1 in
start)
	#开机触发，wan重启触发，所以需要先关后开
	set_lock
	if [ "$koolproxyR_enable" == "1" ];then
		logger "[软件中心]: 启动koolproxyR插件！"
		rm -rf /tmp/user.txt && ln -sf /jffs/softcenter/koolproxyR/data/rules/user.txt /tmp/user.txt
		remove_reboot_job
		flush_nat
		stop_koolproxyR
		remove_ipset_conf && restart_dnsmasq
		detect_cert >> /tmp/syslog.log
		start_koolproxyR >> /tmp/syslog.log
		add_ipset_conf && restart_dnsmasq >> /tmp/syslog.log
		creat_ipset >> /tmp/syslog.log
		load_nat >> /tmp/syslog.log
		dns_takeover >> /tmp/syslog.log
		write_reboot_job >> /tmp/syslog.log
	else
		logger "[软件中心]: koolproxyR插件未开启，不启动！"
	fi
	unset_lock
	;;
restart)
	#web提交触发，需要先关后开
	# now stop
	set_lock
	echo_date ================================ 关闭 ===============================
	rm -rf /tmp/user.txt && ln -sf /jffs/softcenter/koolproxyR/data/rules/user.txt /tmp/user.txt
	remove_reboot_job
	flush_nat
	stop_koolproxyR
	remove_ipset_conf && restart_dnsmasq
	# now start
	echo_date ============================ koolproxyR启用 ===========================
	detect_cert
	start_koolproxyR
	add_ipset_conf && restart_dnsmasq
	creat_ipset
	load_nat
	dns_takeover
	write_reboot_job
	detect_start_up
	echo_date koolproxyR启用成功，请等待日志窗口自动关闭，页面会自动刷新...
	echo_date =====================================================================
	unset_lock
	;;
stop)
	#web提交触发，需要先关后开
	set_lock
	echo_date ================================ 关闭 ===============================
	remove_reboot_job
	add_ipset_conf && restart_dnsmasq
	flush_nat
	stop_koolproxyR
	remove_ipset_conf && restart_dnsmasq
	echo_date koolproxyR插件已关闭
	echo_date =====================================================================
	unset_lock
	;;
start_nat)
	#nat重启触发，所以需要先关后开
	set_lock
	if [ "$koolproxyR_enable" == "1" -a -n "$(pidof koolproxy)"];then
		logger "[软件中心]: koolproxyR nat重启！"
		rm -rf /tmp/user.txt && ln -sf /jffs/softcenter/koolproxyR/data/rules/user.txt /tmp/user.txt
		remove_reboot_job
		flush_nat
		stop_koolproxyR
		remove_ipset_conf && restart_dnsmasq
		detect_cert
		start_koolproxyR
		add_ipset_conf && restart_dnsmasq
		creat_ipset
		load_nat
		dns_takeover
		write_reboot_job
		detect_start_up
	fi
	unset_lock
	;;
esac
