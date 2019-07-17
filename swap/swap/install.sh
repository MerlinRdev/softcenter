#! /bin/sh

find /jffs/softcenter/init.d/ -name "*swap.sh*"|xargs rm -rf
cd /tmp
cp -rf /tmp/swap/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/swap/init.d/* /jffs/softcenter/init.d/
cp -rf /tmp/swap/webs/* /jffs/softcenter/webs/
cp -rf /tmp/swap/res/* /jffs/softcenter/res/
cd /
rm -rf /tmp/swap* >/dev/null 2>&1

if [ ! -f "/jffs/scripts/post-mount" ];then
	cat > /jffs/scripts/post-mount <<-EOF
	#!/bin/sh
	/jffs/softcenter/bin/softcenter-mount.sh start
	EOF
	chmod +x /jffs/scripts/post-mount
else
	STARTCOMAND2=`cat /jffs/scripts/post-mount | grep softcenter-mount`
	[ -z "$STARTCOMAND2" ] && sed -i '1a /jffs/softcenter/bin/softcenter-mount.sh start' /jffs/scripts/post-mount
fi

chmod +x /jffs/scripts/post-mount
chmod +X /jffs/softcenter/scripts/swap*
chmod +X /jffs/softcenter/init.d/*

