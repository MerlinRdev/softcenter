#! /bin/sh
source /jffs/softcenter/scripts/base.sh
eval `dbus export koolproxyR`
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
[ "$(dbus get koolproxy_enable)" == "1" ] && dbus set koolproxy_enable=0
[ "$koolproxyR_enable" == "1" ] && [ -f "/jffs/softcenter/koolproxyR/kp_config.sh" ] && sh /jffs/softcenter/koolproxyR/kp_config.sh stop

# remove old files, do not remove user.txt incase of upgrade
rm -rf /jffs/softcenter/bin/koolproxyR >/dev/null 2>&1
rm -rf /jffs/softcenter/scripts/koolproxyR* >/dev/null 2>&1
rm -rf /jffs/softcenter/webs/Module_koolproxyR.asp >/dev/null 2>&1
rm -rf /jffs/softcenter/res/icon-koolproxyR.png >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxyR/*.sh >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxyR/data/dnsmasq.adblock >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxyR/data/gen_ca.sh >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxyR/data/koolproxyR_ipset.conf >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxyR/data/openssl.cnf >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxyR/data/serial >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxyR/data/version >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxyR/data/rules/*.dat >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxyR/data/rules/*.txt >/dev/null 2>&1


# copy new files
cd /tmp
mkdir -p /jffs/softcenter/koolproxyR
mkdir -p /jffs/softcenter/koolproxyR/data
mkdir -p /jffs/softcenter/koolproxyR/data/rules

cp -rf /tmp/koolproxyR/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/koolproxyR/webs/* /jffs/softcenter/webs/
cp -rf /tmp/koolproxyR/res/* /jffs/softcenter/res/
if [ "`nvram get model`" == "GT-AC5300" ] || [ "`nvram get model`" == "GT-AC2900" ];then
	cp -rf /tmp/koolproxyR/ROG/webs/* /jffs/softcenter/webs/
fi
if [ ! -f /jffs/softcenter/koolproxyR/data/rules/user.txt ];then
	cp -rf /tmp/koolproxyR/koolproxyR /jffs/softcenter/
else
	mv /jffs/softcenter/koolproxyR/data/rules/user.txt /tmp/user.txt.tmp
	cp -rf /tmp/koolproxyR/koolproxyR /jffs/softcenter/
	mv /tmp/user.txt.tmp /jffs/softcenter/koolproxyR/data/rules/user.txt
fi
cp -f /tmp/koolproxyR/uninstall.sh /jffs/softcenter/scripts/uninstall_koolproxyR.sh
#[ ! -L "/jffs/softcenter/bin/koolproxyR" ] && ln -sf /jffs/softcenter/koolproxyR/koolproxyR /jffs/softcenter/bin/koolproxyR
chmod 755 /jffs/softcenter/koolproxyR/*
chmod 755 /jffs/softcenter/koolproxyR/data/*
chmod 755 /jffs/softcenter/scripts/*
chmod 777 /jffs/softcenter/scripts/kp_update.sh
chmod 777 /jffs/softcenter/scripts/kp.sh
# 创建开机启动文件
find /jffs/softcenter/init.d/ -name "*koolproxyR*" | xargs rm -rf
if [ "$productid" = "BLUECAVE" ];then
	[ ! -f "/jffs/softcenter/init.d/M98koolproxyR.sh" ] && cp -r /jffs/softcenter/koolproxyR/kp_config.sh /jffs/softcenter/init.d/M98koolproxyR.sh
	[ ! -f "/jffs/softcenter/init.d/N98koolproxyR.sh" ] && cp -r /jffs/softcenter/koolproxyR/kp_config.sh /jffs/softcenter/init.d/N98koolproxyR.sh
else
	[ ! -L "/jffs/softcenter/init.d/S98koolproxyR.sh" ] && ln -sf /jffs/softcenter/koolproxyR/kp_config.sh /jffs/softcenter/init.d/S98koolproxyR.sh
	[ ! -L "/jffs/softcenter/init.d/N98koolproxyR.sh" ] && ln -sf /jffs/softcenter/koolproxyR/kp_config.sh /jffs/softcenter/init.d/N98koolproxyR.sh
fi

[ -z "$koolproxyR_mode" ] && dbus set koolproxyR_mode=1
[ -z "$koolproxyR_acl_default" ] && dbus set koolproxyR_acl_default=1

dbus set softcenter_module_koolproxyR_install=1
dbus set softcenter_module_koolproxyR_version="$(cat $DIR/version)"
dbus set koolproxyR_version=3.8.4
dbus set softcenter_module_koolproxyR_name="koolproxyR"
dbus set softcenter_module_koolproxyR_title="koolproxyR"
dbus set softcenter_module_koolproxyR_description="神奇的玄学，谁用谁知道。"
# 删除安装包
rm -rf /tmp/koolproxyR* >/dev/null 2>&1
# restart
[ "$koolproxyR_enable" == "1" ] && [ -f "/jffs/softcenter/koolproxyR/kp_config.sh" ] && sh /jffs/softcenter/koolproxyR/kp_config.sh restart

exit 0

