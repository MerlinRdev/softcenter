#! /bin/sh

sh /jffs/softcenter/ss/ssconfig.sh stop
sh /jffs/softcenter/scripts/ss_conf_remove.sh
sleep 1
rm -rf /jffs/softcenter/ss/*
rm -rf /jffs/softcenter/scripts/ss_*
rm -rf /jffs/softcenter/webs/Main_Ss*
rm -rf /jffs/softcenter/bin/ss-tunnel
rm -rf /jffs/softcenter/bin/ss-local
rm -rf /jffs/softcenter/bin/ss-server
rm -rf /jffs/softcenter/bin/ss-redir
rm -rf /jffs/softcenter/bin/rss*
rm -rf /jffs/softcenter/bin/obfs*
rm -rf /jffs/softcenter/bin/haproxy
rm -rf /jffs/softcenter/bin/redsocks2
rm -rf /jffs/softcenter/bin/pdnsd
#rm -rf /jffs/softcenter/bin/Pcap_DNSProxy
rm -rf /jffs/softcenter/bin/dnscrypt-proxy
rm -rf /jffs/softcenter/bin/dns2socks
rm -rf /jffs/softcenter/bin/client_linux_mips
rm -rf /jffs/softcenter/bin/chinadns
rm -rf /jffs/softcenter/bin/resolveip


dbus remove softcenter_module_shadowsocks_home_url
dbus remove softcenter_module_shadowsocks_install
dbus remove softcenter_module_shadowsocks_md5
dbus remove softcenter_module_shadowsocks_version

dbus remove ss_basic_enable
dbus remove ss_basic_version_local
dbus remove ss_basic_version_web
