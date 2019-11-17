#! /bin/sh
source /jffs/softcenter/scripts/base.sh
eval `dbus export koolproxy`
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
DIR=$(cd $(dirname $0); pwd)
touch /tmp/kp_log.txt
firmware_version=`nvram get extendno|cut -d "_" -f2|cut -d "-" -f1|cut -c2-6`
firmware_check=5.0.1
if [ ${#firmware_version} -lt 5 ];then
	firmware_version=1.0.0
fi
firmware_comp=`/jffs/softcenter/bin/versioncmp $firmware_version $firmware_check`
if [ "$firmware_comp" == "1" ];then
	echo_date 固件版本过低，无法安装
	exit 1
fi
# stop first
[ "$(dbus get koolproxyR_enable)" == "1" ] && dbus set koolproxyR_enable=0
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
if [ "`nvram get model`" == "GT-AC5300" ] || [ "`nvram get model`" == "GT-AC2900" ];then
	cp -rf /tmp/koolproxy/ROG/webs/* /jffs/softcenter/webs/
fi
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
if [ "$productid" = "BLUECAVE" ];then
	[ ! -f "/jffs/softcenter/init.d/M98koolproxy.sh" ] && cp -r /jffs/softcenter/koolproxy/kp_config.sh /jffs/softcenter/init.d/M98koolproxy.sh
	[ ! -f "/jffs/softcenter/init.d/N98koolproxy.sh" ] && cp -r /jffs/softcenter/koolproxy/kp_config.sh /jffs/softcenter/init.d/N98koolproxy.sh
else
	[ ! -L "/jffs/softcenter/init.d/S98koolproxy.sh" ] && ln -sf /jffs/softcenter/koolproxy/kp_config.sh /jffs/softcenter/init.d/S98koolproxy.sh
	[ ! -L "/jffs/softcenter/init.d/N98koolproxy.sh" ] && ln -sf /jffs/softcenter/koolproxy/kp_config.sh /jffs/softcenter/init.d/N98koolproxy.sh
fi

[ -z "$koolproxy_mode" ] && dbus set koolproxy_mode=1
[ -z "$koolproxy_acl_default" ] && dbus set koolproxy_acl_default=1

dbus set softcenter_module_koolproxy_install=1
dbus set softcenter_module_koolproxy_version="$(cat $DIR/version)"
dbus set koolproxy_version=3.8.4
dbus set softcenter_module_koolproxy_name="koolproxy"
dbus set softcenter_module_koolproxy_title="koolproxy"
# 删除安装包
rm -rf /tmp/koolproxy* >/dev/null 2>&1
# restart
[ "$koolproxy_enable" == "1" ] && [ -f "/jffs/softcenter/koolproxy/kp_config.sh" ] && sh /jffs/softcenter/koolproxy/kp_config.sh restart

exit 0

