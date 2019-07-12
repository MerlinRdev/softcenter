#!/bin/sh

# stop kms first
enable=`dbus get kms_enable`
if [ "$enable" == "1" ];then
	sh /jffs/softcenter/scripts/kms_config.sh stop
fi

# cp files
cp -rf /tmp/kms/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/kms/bin/* /jffs/softcenter/bin/
cp -rf /tmp/kms/webs/* /jffs/softcenter/webs/
cp -rf /tmp/kms/res/* /jffs/softcenter/res/

# delete install tar
rm -rf /tmp/kms* >/dev/null 2>&1

chmod +x /jffs/softcenter/scripts/kms*
chmod +x /jffs/softcenter/bin/vlmcsd

# re-enable kms
if [ "$enable" == "1" ];then
	sh /jffs/softcenter/scripts/kms_config.sh start
fi



