#! /bin/sh
# stop ssserver first
enable=`dbus get ssserver_enable`
if [ "$enable" == "1" ];then
	sh /jffs/softcenter/scripts/ssserver_config.sh stop
fi

# cp files
cp -rf /tmp/ssserver/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/ssserver/bin/* /jffs/softcenter/bin/
cp -rf /tmp/ssserver/webs/* /jffs/softcenter/webs/
cp -rf /tmp/ssserver/res/* /jffs/softcenter/res/
cp -rf /tmp/ssserver/init.d/* /jffs/softcenter/init.d/
cp -rf /tmp/ssserver/uninstall.sh /jffs/softcenter/scripts/uninstall_ssserver.sh

# delete install tar
rm -rf /tmp/ssserver* >/dev/null 2>&1

chmod +x /jffs/softcenter/scripts/ssserver*
chmod +x /jffs/softcenter/bin/ss-server
chmod +x /jffs/softcenter/bin/obfs-server
chmod +x /jffs/softcenter/init.d/*

# re-enable ssserver
if [ "$enable" == "1" ];then
	sh /jffs/softcenter/scripts/ssserver_config.sh
fi


