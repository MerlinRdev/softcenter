#! /bin/sh

eval `dbus export ss`
alias echo_date='echo $(date +%Y年%m月%d日\ %X):'

remove_conf(){
	ipset_value=`dbus list ss_ipset | cut -d "=" -f 1`
	redchn_value=`dbus list ss_redchn | cut -d "=" -f 1`
	overall_value=`dbus list ss_overall_ | cut -d "=" -f 1`
	for conf in $ipset_value $redchn_value $overall_value
	do
		echo 移除$conf
		dbus remove $conf
	done
}

remove_conf
# 判断路由架构和平台
case $(uname -m) in
	mips)
		echo_date 固件平台【 merlin mips 】符合安装要求，开始安装插件！
	;;
	*)
		echo_date 本插件适用于 merlin mips固件平台，你的平台"$(uname -m)"不能安装！！！
		echo_date 退出安装！
		exit 1
	;;
esac

# 关闭ss
mkdir -p /jffs/softcenter/ss
if [ "$ss_basic_enable" == "1" ];then
	echo_date 先关闭ss，保证文件更新成功!
	sh /jffs/softcenter/ss/stop.sh stop_all
fi

#升级前先删除无关文件
echo_date 清理旧文件
rm -rf /jffs/softcenter/ss/*
rm -rf /jffs/softcenter/scripts/ss_*
rm -rf /jffs/softcenter/webs/Main_Ss*
rm -rf /jffs/softcenter/bin/ss-*
rm -rf /jffs/softcenter/bin/rss-*
rm -rf /jffs/softcenter/bin/obfs*
rm -rf /jffs/softcenter/bin/haproxy
rm -rf /jffs/softcenter/bin/redsocks2
rm -rf /jffs/softcenter/bin/pdnsd
rm -rf /jffs/softcenter/bin/dnscrypt-proxy
rm -rf /jffs/softcenter/bin/dns2socks
rm -rf /jffs/softcenter/bin/chinadns
rm -rf /jffs/softcenter/bin/resolveip


echo_date 复制新文件！
cd /tmp

echo_date 复制相关二进制文件！
cp -rf /tmp/shadowsocks/bin/* /jffs/softcenter/bin/
chmod 755 /jffs/softcenter/bin/*
[ ! -L "/jffs/softcenter/bin/rss-tunnel" ] && cp -rf /jffs/softcenter/bin/rss-local /jffs/softcenter/bin/rss-tunnel

echo_date 复制ss的脚本文件！
cp -rf /tmp/shadowsocks/ss/* /jffs/softcenter/ss/
cp -rf /tmp/shadowsocks/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/shadowsocks/init.d/* /jffs/softcenter/init.d/

echo_date 复制网页文件！
cp -rf /tmp/shadowsocks/webs/* /jffs/softcenter/webs/
cp -rf /tmp/shadowsocks/res/* /jffs/softcenter/res/

echo_date 移除安装包！
rm -rf /tmp/shadowsocks* >/dev/null 2>&1


# transform data in skipd when ss version below 3.0.0
curr_version=`dbus get ss_basic_version_local`
comp=`/usr/bin/versioncmp $curr_version 3.0.0`
if [ -n "$curr_version" ] && [ "$comp" == "1" ];then
	echo_date 从ss3.0.0版本开始，将对界面内textarea内的值和ss的密码进行base64加密，方便储存！
	echo_date 生成当前SS版本：$curr_version的配置文件到/jffs根目录！
	dbus list ss > /jffs/ss_conf_backup_$curr_version.txt
	echo_date 对部分ss数据进行base64加密数据！
	node_pass=`dbus list ssconf_basic_password |cut -d "=" -f 1|cut -d "_" -f4|sort -n`
	for node in $node_pass
	do
		dbus set ssconf_basic_password_$node=`dbus get ssconf_basic_password_$node|base64`
	done
	dbus set ss_basic_password=`dbus get ss_basic_password|base64`
	dbus set ss_basic_black_lan=`dbus get ss_basic_black_lan | base64`
	dbus set ss_basic_white_lan=`dbus get ss_basic_white_lan | base64`
	dbus set ss_ipset_black_domain_web=`dbus get ss_ipset_black_domain_web | base64`
	dbus set ss_ipset_white_domain_web=`dbus get ss_ipset_white_domain_web | base64`
	dbus set ss_ipset_dnsmasq=`dbus get ss_ipset_dnsmasq | base64`
	dbus set ss_ipset_black_ip=`dbus get ss_ipset_black_ip | base64`
	dbus set ss_redchn_isp_website_web=`dbus get ss_redchn_isp_website_web | base64`
	dbus set ss_redchn_dnsmasq=`dbus get ss_redchn_dnsmasq | base64`
	dbus set ss_redchn_wan_white_ip=`dbus get ss_redchn_wan_white_ip | base64`
	dbus set ss_redchn_wan_white_domain=`dbus get ss_redchn_wan_white_domain | base64`
	dbus set ss_redchn_wan_black_ip=`dbus get ss_redchn_wan_black_ip | base64`
	dbus set ss_redchn_wan_black_domain=`dbus get ss_redchn_wan_black_domain | base64`
fi

# 设置一些默认值
echo_date 设置一些默认值
[ -z "$ss_dns_china" ] && dbus set ss_dns_china=11
[ -z "$ss_dns_foreign" ] && dbus set ss_dns_foreign=1
[ -z "$ss_basic_ss_obfs" ] && dbus set ss_basic_ss_obfs=0
[ -z "$ss_acl_default_mode" ] && dbus set ss_acl_default_mode="$ss_basic_mode"
[ -z "$ss_acl_default_port" ] && dbus set ss_acl_default_port=all
[ -z "$ss_dns_plan" ] && dbus set ss_dns_china=1
[ -z "$ss_dns_plan_chn" ] && dbus set ss_dns_china=2
[ -z "$ss_dns_plan_gfw" ] && dbus set ss_dns_china=1

echo_date 为新安装文件赋予执行权限...
chmod 755 /jffs/softcenter/ss/cru/*
chmod 755 /jffs/softcenter/ss/rules/*
chmod 755 /jffs/softcenter/ss/socks5/*
chmod 755 /jffs/softcenter/ss/*
chmod 755 /jffs/softcenter/scripts/ss*
chmod 755 /jffs/softcenter/bin/*

# add icon into softerware center
dbus set softcenter_module_shadowsocks_install=1
dbus set softcenter_module_shadowsocks_version=3.1.6
dbus set softcenter_module_shadowsocks_home_url=Main_Ss_Content.asp

new_version=`cat /jffs/softcenter/ss/version`
dbus set ss_basic_version_local=$new_version

sleep 2
echo_date 一点点清理工作...
rm -rf /tmp/shadowsocks* >/dev/null 2>&1
dbus set ss_basic_install_status="0"
echo_date 安装更新成功，你为什么这么屌？！

if [ "$ss_basic_enable" == "1" ];then
	echo_date 重启ss！
	dbus set ss_basic_action=1
	. /jffs/softcenter/ss/ssconfig.sh restart
fi
echo_date 更新完毕，请等待网页自动刷新！
echo XU6J03M6
sleep 1
killall ssconfig.sh >/dev/null 2>&1
killall sh >/dev/null 2>&1
kill `pidof ssconfig.sh` >/dev/null 2>&1








