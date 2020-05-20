#! /bin/sh
source /jffs/softcenter/scripts/base.sh
eval `dbus export koolproxyR`
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
MODEL=$(nvram get productid)
DIR=$(cd $(dirname $0); pwd)
touch /tmp/kp_log.txt
if [ "$MODEL" == "GT-AC5300" ] || [ "$MODEL" == "GT-AX11000" ] || [ "$MODEL" == "GT-AC2900" ] || [ "$(nvram get merlinr_rog)" == "1" ];then
	ROG=1
elif [ "$MODEL" == "TUF-AX3000" ] || [ "$(nvram get merlinr_tuf)" == "1" ] ;then
	TUF=1
fi
# stop first
[ "$(dbus get koolproxy_enable)" == "1" ] && dbus set koolproxy_enable=0 && sh /jffs/softcenter/koolproxy/kp_config.sh stop
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
if [ "$ROG" == "1" ];then
	continue
elif [ "$TUF" == "1" ];then
	sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /jffs/softcenter/webs/Module_koolproxyR.asp >/dev/null 2>&1
else
	sed -i '/rogcss/d' /jffs/softcenter/webs/Module_koolproxyR.asp >/dev/null 2>&1
fi
if [ ! -f /jffs/softcenter/koolproxyR/data/rules/user.txt ];then
	cp -rf /tmp/koolproxyR/koolproxyR /jffs/softcenter/
else
	mv /jffs/softcenter/koolproxyR/data/rules/user.txt /tmp/user.txt.tmp
	cp -rf /tmp/koolproxyR/koolproxyR /jffs/softcenter/
	mv /tmp/user.txt.tmp /jffs/softcenter/koolproxyR/data/rules/user.txt
fi
cp -f /tmp/koolproxyR/uninstall.sh /jffs/softcenter/scripts/uninstall_koolproxyR.sh
chmod 755 /jffs/softcenter/koolproxyR/*
chmod 755 /jffs/softcenter/koolproxyR/data/*
chmod 755 /jffs/softcenter/scripts/*
chmod 777 /jffs/softcenter/scripts/kp_update.sh
chmod 777 /jffs/softcenter/scripts/kp.sh
# 创建开机启动文件
find /jffs/softcenter/init.d/ -name "*koolproxyR*" | xargs rm -rf
[ ! -L "/jffs/softcenter/init.d/S98koolproxyR.sh" ] && ln -sf /jffs/softcenter/koolproxyR/kp_config.sh /jffs/softcenter/init.d/S98koolproxyR.sh
[ ! -L "/jffs/softcenter/init.d/N98koolproxyR.sh" ] && ln -sf /jffs/softcenter/koolproxyR/kp_config.sh /jffs/softcenter/init.d/N98koolproxyR.sh

[ -z "$koolproxyR_mode" ] && dbus set koolproxyR_mode=1
[ -z "$koolproxyR_acl_default" ] && dbus set koolproxyR_acl_default=1

dbus set softcenter_module_koolproxyR_install=1
dbus set softcenter_module_koolproxyR_version="$(cat $DIR/version)"
dbus set koolproxyR_version="$(cat $DIR/version)"
dbus set softcenter_module_koolproxyR_name="koolproxyR"
dbus set softcenter_module_koolproxyR_title="koolproxyR"
dbus set softcenter_module_koolproxyR_description="神奇的玄学，谁用谁知道。"

[ "$koolproxyR_enable" == "1" ] && [ -f "/jffs/softcenter/koolproxyR/kp_config.sh" ] && sh /jffs/softcenter/koolproxyR/kp_config.sh restart
echo_date "koolproxyR插件安装完毕！"
rm -rf /tmp/koolproxyR* >/dev/null 2>&1
exit 0

