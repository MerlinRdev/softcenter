#! /bin/sh
eval `dbus export koolproxy`

# stop first
dbus set koolproxy_enable=0
[ -f /jffs/softcenter/koolproxy/koolproxy.sh ] && sh /jffs/softcenter/koolproxy/koolproxy.sh stop
[ -f /jffs/softcenter/koolproxy/kp_config.sh ] && sh /jffs/softcenter/koolproxy/kp_config.sh stop
# remove old files
rm -rf /jffs/softcenter/bin/koolproxy >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/koolproxy.sh >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/nat_load.sh >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/*.dat >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/*.txt >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/*.conf >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/gen_ca.sh >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/openssl.cnf >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/version >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/serial >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/rule_store >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/rules/1.dat >/dev/null 2>&1

# copy new files
cd /tmp
mkdir -p /jffs/softcenter/koolproxy
mkdir -p /jffs/softcenter/koolproxy/data
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


cd /

chmod 755 /jffs/softcenter/koolproxy/koolproxy
chmod 755 /jffs/softcenter/koolproxy/*
chmod 755 /jffs/softcenter/koolproxy/data/*
chmod 755 /jffs/softcenter/scripts/*
[ ! -e "/jffs/softcenter/bin/koolproxy" ] && cp -f /jffs/softcenter/koolproxy/koolproxy /jffs/softcenter/bin/koolproxy

rm -rf /tmp/koolproxy* >/dev/null 2>&1

[ -z "$koolproxy_policy" ] && dbus set koolproxy_policy=1
[ -z "$koolproxy_acl_default_mode" ] && dbus set koolproxy_acl_default_mode=1

dbus set softcenter_module_koolproxy_install=1
dbus set softcenter_module_koolproxy_version=3.3.7
dbus set koolproxy_version=3.3.7

