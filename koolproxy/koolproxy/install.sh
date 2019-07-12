#! /bin/sh
source /jffs/softcenter/scripts/base.sh
eval `dbus export koolproxy`
touch /tmp/kp_log.txt

# stop first
[ "$koolproxy_enable" == "1" ] && [ -f "/jffs/softcenter/koolproxy/kp_config.sh" ] && sh /jffs/softcenter/koolproxy/kp_config.sh stop

# remove old files, do not remove user.txt incase of upgrade
rm -rf /jffs/softcenter/bin/koolproxy >/dev/null 2>&1
rm -rf /jffs/softcenter/scripts/koolproxy* >/dev/null 2>&1
rm -rf /jffs/softcenter/webs/Module_koolproxy.asp >/dev/null 2>&1
rm -rf /jffs/softcenter/res/icon-koolproxy.png >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/*.sh >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/dnsmasq.adblock >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/gen_ca.sh >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/koolproxy_ipset.conf >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/openssl.cnf >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/serial >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/version >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/rules/*.dat >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/rules/daily.txt >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/rules/koolproxy.txt >/dev/null 2>&1

# copy new files
cd /tmp
mkdir -p /jffs/softcenter/koolproxy
mkdir -p /jffs/softcenter/koolproxy/data
mkdir -p /jffs/softcenter/koolproxy/data/rules

cp -rf /tmp/koolproxy/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/koolproxy/webs/* /jffs/softcenter/webs/
cp -rf /tmp/koolproxy/res/* /jffs/softcenter/res/
if [ ! -f /jffs/softcenter/koolproxy/data/rules/user.txt ];then
	cp -rf /tmp/koolproxy/koolproxy /jffs/softcenter/
else
	mv /jffs/softcenter/koolproxy/data/rules/user.txt /tmp/user.txt.tmp
	cp -rf /tmp/koolproxy/koolproxy /jffs/softcenter/
	mv /tmp/user.txt.tmp /jffs/softcenter/koolproxy/data/rules/user.txt
fi
cp -f /tmp/koolproxy/uninstall.sh /jffs/softcenter/scripts/uninstall_koolproxy.sh
#[ ! -L "/jffs/softcenter/bin/koolproxy" ] && ln -sf /jffs/softcenter/koolproxy/koolproxy /jffs/softcenter/bin/koolproxy
chmod 755 /jffs/softcenter/koolproxy/*
chmod 755 /jffs/softcenter/koolproxy/data/*
chmod 755 /jffs/softcenter/scripts/*

# 创建开机启动文件
find /jffs/softcenter/init.d/ -name "*koolproxy*" | xargs rm -rf
if [ "$(nvram get productid)" = "BLUECAVE" ];then
	[ ! -f "/jffs/softcenter/init.d/M98koolproxy.sh" ] && cp -r /jffs/softcenter/koolproxy/kp_config.sh /jffs/softcenter/init.d/M98koolproxy.sh
	[ ! -f "/jffs/softcenter/init.d/N98koolproxy.sh" ] && cp -r /jffs/softcenter/koolproxy/kp_config.sh /jffs/softcenter/init.d/N98koolproxy.sh
else
	[ ! -L "/jffs/softcenter/init.d/S98koolproxy.sh" ] && ln -sf /jffs/softcenter/koolproxy/kp_config.sh /jffs/softcenter/init.d/S98koolproxy.sh
	[ ! -L "/jffs/softcenter/init.d/N98koolproxy.sh" ] && ln -sf /jffs/softcenter/koolproxy/kp_config.sh /jffs/softcenter/init.d/N98koolproxy.sh
fi

# 删除安装包
rm -rf /tmp/koolproxy* >/dev/null 2>&1

[ -z "$koolproxy_mode" ] && dbus set koolproxy_mode=1
[ -z "$koolproxy_acl_default" ] && dbus set koolproxy_acl_default=1

dbus set softcenter_module_koolproxy_install=1
dbus set softcenter_module_koolproxy_version=3.8.4
dbus set koolproxy_version=3.8.4

# restart
[ "$koolproxy_enable" == "1" ] && [ -f "/jffs/softcenter/koolproxy/kp_config.sh" ] && sh /jffs/softcenter/koolproxy/kp_config.sh restart

exit 0
