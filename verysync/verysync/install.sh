#!/bin/sh

source /jffs/softcenter/scripts/base.sh
DIR=$(cd $(dirname $0); pwd)

cp -rf /tmp/verysync/bin/* /jffs/softcenter/bin/
cp -rf /tmp/verysync/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/verysync/webs/* /jffs/softcenter/webs/
cp -rf /tmp/verysync/res/* /jffs/softcenter/res/

if [ "$(nvram get productid)" = "BLUECAVE" ];then
	[ ! -f "/jffs/softcenter/init.d/M99verysync.sh" ] && cp -r /jffs/softcenter/scripts/verysync_config.sh /jffs/softcenter/init.d/M99verysync.sh
	[ ! -f "/jffs/softcenter/init.d/N99verysync.sh" ] && cp -r /jffs/softcenter/scripts/verysync_config.sh /jffs/softcenter/init.d/N99verysync.sh
else
	[ ! -L "/jffs/softcenter/init.d/M99verysync.sh" ] && ln -sf /jffs/softcenter/scripts/verysync_config.sh /jffs/softcenter/init.d/M99verysync.sh
	[ ! -L "/jffs/softcenter/init.d/N99verysync.sh" ] && ln -sf /jffs/softcenter/scripts/verysync_config.sh /jffs/softcenter/init.d/N99verysync.sh
fi

chmod +x /jffs/softcenter/bin/verysync
chmod +x /jffs/softcenter/scripts/*
chmod +x /jffs/softcenter/init.d/*

# add icon into softerware center
dbus set verysync_version=`/jffs/softcenter/bin/verysync -version|awk '{print $2}'`
dbus set softcenter_module_verysync_install="1"
dbus set softcenter_module_verysync_version="$(cat $DIR/version)"
dbus set softcenter_module_verysync_name="verysync"
dbus set softcenter_module_verysync_title="微力同步"
dbus set softcenter_module_verysync_description="自己的私有云"


dbus set verysync_disklist=`df -h $1  | grep mnt| awk '
    BEGIN { ORS = ""; print " [ "}
    /Filesystem/ {next}
    { printf "%s{\"name\": \"%s\", \"size\": \"%s\", \"usage\": \"%s\", \"free\": \"%s\", \"mount_point\": \"%s\"}",
          separator, $1, $2, $3, $4, $6
      separator = ", "
    }
    END { print " ] " }
'|openssl base64`

rm -rf /tmp/verysync* >/dev/null 2>&1
exit 0
