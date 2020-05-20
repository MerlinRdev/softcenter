#! /bin/sh

eval `dbus export ss`
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
mkdir -p /jffs/softcenter/ss
mkdir -p /tmp/ss_backup
MODEL=`nvram get productid`

echo_date 检测jffs分区剩余空间...
if [ "$(nvram get sc_mount)" == 0 ];then
	SPACE_AVAL=$(df|grep jffs | awk '{print $4}')
	SPACE_NEED=$(du -s /tmp/shadowsocks | awk '{print $1}')
	if [ "$SPACE_AVAL" -gt "$SPACE_NEED" ];then
		echo_date 当前jffs分区剩余"$SPACE_AVAL" KB, 插件安装需要"$SPACE_NEED" KB，空间满足，继续安装！
	else
		echo_date 当前jffs分区剩余"$SPACE_AVAL" KB, 插件安装需要"$SPACE_NEED" KB，空间不足！
		echo_date 退出安装！
		exit 1
	fi
else
	echo_date U盘已挂载，继续安装！
fi
if [ "$ss_basic_enable" == "1" ];then
	echo_date 先关闭科学上网插件，保证文件更新成功!
	sh /jffs/softcenter/ss/ssconfig.sh stop
fi

if [ "$MODEL" == "GT-AC5300" ] || [ "$MODEL" == "GT-AC2900" ] || [ "$(nvram get merlinr_rog)" == "1" ];then
	ROG=1
fi

if [ "$MODEL" == "TUF-AX3000" -o "$(nvram get merlinr_tuf)" == "1" ];then
	TUF=1
fi

if [ -n "`ls /jffs/softcenter/ss/postscripts/P*.sh 2>/dev/null`" ];then
	echo_date 备份触发脚本!
	find /jffs/softcenter/ss/postscripts -name "P*.sh" | xargs -i mv {} -f /tmp/ss_backup
fi

echo_date 清理旧文件
rm -rf /jffs/softcenter/ss/*
rm -rf /jffs/softcenter/scripts/ss_*
rm -rf /jffs/softcenter/webs/Main_Ss*
rm -rf /jffs/softcenter/bin/ss-redir
rm -rf /jffs/softcenter/bin/ss-tunnel
rm -rf /jffs/softcenter/bin/ss-local
rm -rf /jffs/softcenter/bin/rss-redir
rm -rf /jffs/softcenter/bin/rss-tunnel
rm -rf /jffs/softcenter/bin/rss-local
rm -rf /jffs/softcenter/bin/obfs-local
rm -rf /jffs/softcenter/bin/v2ray-plugin
rm -rf /jffs/softcenter/bin/koolgame
rm -rf /jffs/softcenter/bin/pdu
rm -rf /jffs/softcenter/bin/haproxy
rm -rf /jffs/softcenter/bin/pdnsd
rm -rf /jffs/softcenter/bin/Pcap_DNSProxy
rm -rf /jffs/softcenter/bin/dnscrypt-proxy
rm -rf /jffs/softcenter/bin/dns2socks
rm -rf /jffs/softcenter/bin/cdns
rm -rf /jffs/softcenter/bin/client_linux
rm -rf /jffs/softcenter/bin/chinadns
rm -rf /jffs/softcenter/bin/chinadns1
rm -rf /jffs/softcenter/bin/resolveip
rm -rf /jffs/softcenter/bin/udp2raw
rm -rf /jffs/softcenter/bin/speeder*
rm -rf /jffs/softcenter/bin/v2ray
rm -rf /jffs/softcenter/bin/v2ctl
rm -rf /jffs/softcenter/bin/jitterentropy-rngd
rm -rf /jffs/softcenter/bin/haveged
rm -rf /jffs/softcenter/bin/https_dns_proxy
rm -rf /jffs/softcenter/bin/dnsmassq
rm -rf /jffs/softcenter/res/shadowsocks.css
rm -rf /jffs/softcenter/res/icon-shadowsocks.png
rm -rf /jffs/softcenter/res/ss-menu.js
rm -rf /jffs/softcenter/res/all.png
rm -rf /jffs/softcenter/res/gfwlist.png
rm -rf /jffs/softcenter/res/chn.png
rm -rf /jffs/softcenter/res/game.png
rm -rf /jffs/softcenter/res/shadowsocks.css
rm -rf /jffs/softcenter/res/gameV2.png
rm -rf /jffs/softcenter/res/ss_proc_status.htm
find /jffs/softcenter/init.d/ -name "*shadowsocks.sh" | xargs rm -rf
find /jffs/softcenter/init.d/ -name "*socks5.sh" | xargs rm -rf

echo_date 开始复制文件！
cd /tmp

echo_date 复制相关二进制文件！此步时间可能较长！
echo_date 如果长时间没有日志刷新，请等待2分钟后进入插件看是否安装成功..。
cp -rf /tmp/shadowsocks/bin/* /jffs/softcenter/bin/
chmod 755 /jffs/softcenter/bin/*

echo_date 复制相关的脚本文件！
cp -rf /tmp/shadowsocks/ss/* /jffs/softcenter/ss/
cp -rf /tmp/shadowsocks/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/shadowsocks/install.sh /jffs/softcenter/scripts/ss_install.sh

echo_date 复制相关的网页文件！
cp -rf /tmp/shadowsocks/webs/* /jffs/softcenter/webs/
cp -rf /tmp/shadowsocks/res/* /jffs/softcenter/res/
if [ "$ROG" == "1" ];then
	cp -rf /tmp/shadowsocks/rog/res/* /jffs/softcenter/res/
elif [ "$TUF" == "1" ];then
	sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /tmp/shadowsocks/rog/res/shadowsocks.css >/dev/null 2>&1
	cp -rf /tmp/shadowsocks/rog/res/* /jffs/softcenter/res/
fi

echo_date 为新安装文件赋予执行权限...
chmod 755 /jffs/softcenter/ss/cru/*
chmod 755 /jffs/softcenter/ss/rules/*
chmod 755 /jffs/softcenter/ss/*
chmod 755 /jffs/softcenter/scripts/ss*
chmod 755 /jffs/softcenter/bin/*

if [ -n "`ls /tmp/ss_backup/P*.sh 2>/dev/null`" ];then
	echo_date 恢复触发脚本!
	mkdir -p /jffs/softcenter/ss/postscripts
	find /tmp/ss_backup -name "P*.sh" | xargs -i mv {} -f /jffs/softcenter/ss/postscripts
fi

echo_date 创建一些二进制文件的软链接！
[ ! -e "/jffs/softcenter/bin/rss-tunnel" ] && cp -rf /jffs/softcenter/bin/rss-local /jffs/softcenter/bin/rss-tunnel
[ ! -e "/jffs/softcenter/init.d/S99shadowsocks.sh" ] && cp -rf /jffs/softcenter/ss/ssconfig.sh /jffs/softcenter/init.d/S99shadowsocks.sh
[ ! -e "/jffs/softcenter/init.d/N99shadowsocks.sh" ] && cp -rf /jffs/softcenter/ss/ssconfig.sh /jffs/softcenter/init.d/N99shadowsocks.sh
[ ! -e "/jffs/softcenter/init.d/S99socks5.sh" ] && cp -rf /jffs/softcenter/scripts/ss_socks5.sh /jffs/softcenter/init.d/S99socks5.sh

echo_date 设置一些默认值
[ -z "$ss_dns_china" ] && dbus set ss_dns_china=11
[ -z "$ss_dns_foreign" ] && dbus set ss_dns_foreign=1
[ -z "$ss_basic_ss_v2ray_plugin" ] && dbus set ss_basic_ss_v2ray_plugin=0
[ -z "$ss_acl_default_mode" ] && [ -n "$ss_basic_mode" ] && dbus set ss_acl_default_mode="$ss_basic_mode"
[ -z "$ss_acl_default_mode" ] && [ -z "$ss_basic_mode" ] && dbus set ss_acl_default_mode=1
[ -z "$ss_acl_default_port" ] && dbus set ss_acl_default_port=all
[ "$ss_basic_v2ray_network" == "ws_hd" ] && dbus set ss_basic_v2ray_network="ws"

# 移除一些没用的值
dbus remove ss_basic_version

# 离线安装时设置软件中心内储存的版本号和连接
CUR_VERSION=`cat /jffs/softcenter/ss/version`
dbus set ss_basic_version_local="$CUR_VERSION"
dbus set softcenter_module_shadowsocks_install="4"
dbus set softcenter_module_shadowsocks_version="$CUR_VERSION"
dbus set softcenter_module_shadowsocks_title="科学上网"
dbus set softcenter_module_shadowsocks_description="科学上网"
dbus set softcenter_module_shadowsocks_home_url="Main_Ss_Content.asp"

# 设置v2ray 版本号
dbus set ss_basic_v2ray_version="v4.21.3"
dbus set ss_basic_v2ray_date="20190712"

echo_date 一点点清理工作...
rm -rf /tmp/shadowsocks* >/dev/null 2>&1
dbus set ss_basic_install_status="0"
echo_date 科学上网插件安装成功！

if [ "$ss_basic_enable" == "1" ];then
	echo_date 重启ss！
	dbus set ss_basic_action=1
	sh /jffs/softcenter/ss/ssconfig.sh restart
fi
echo_date 更新完毕，请等待网页自动刷新！
