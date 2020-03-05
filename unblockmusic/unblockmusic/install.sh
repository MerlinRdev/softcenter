#! /bin/sh

source /jffs/softcenter/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
DIR=$(cd $(dirname $0); pwd)

plugin_need=5000
JFFS_FREE=`df |grep jffs |awk '{printf $4}'`
if [ $JFFS_FREE -gt $plugin_need ];then
	if [ -n "$(pidof node)" ];then
		killall node
	fi
elif [ "$(nvram get sc_mount)" == "1" ];then
	if [ -n "$(pidof node)" ];then
		killall node
	fi
else
	echo_date "jffs空间不足,jffs扩展挂载未开启,退出安装..."
	echo_date "Not enough free space for JFFS and jffs extended is disabled ,exit..."
	exit 1
fi

enable=`dbus get unblockmusic_enable`
if [ "$enable" == "1" ] && [ -f "/jffs/softcenter/scripts/unblockmusic_config.sh" ];then
	/jffs/softcenter/scripts/unblockmusic_config.sh stop >/dev/null 2>&1
fi
echo_date "开始安装unblockmusic..."
echo_date "Start intall unblockmusic..."
find /jffs/softcenter/init.d/ -name "*unblockmusic*" | xargs rm -rf
mkdir -p /jffs/softcenter/lib

cp -rf /tmp/unblockmusic/bin/* /jffs/softcenter/bin/
cp -rf /tmp/unblockmusic/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/unblockmusic/webs/* /jffs/softcenter/webs/
cp -rf /tmp/unblockmusic/res/* /jffs/softcenter/res/
cp -rf /tmp/unblockmusic/uninstall.sh /jffs/softcenter/scripts/uninstall_unblockmusic.sh
if [ "`nvram get model`" == "GT-AC5300" ] || [ "`nvram get model`" == "GT-AC2900" ];then
	cp -rf /tmp/unblockmusic/ROG/Module_unblockmusic.asp /jffs/softcenter/webs/
fi

chmod +x /jffs/softcenter/scripts/*
chmod +x /jffs/softcenter/bin/*



cp -rf /jffs/softcenter/scripts/unblockmusic_config.sh /jffs/softcenter/init.d/S99unblockmusic.sh

dbus set unblockmusic_version="1.0.0"
dbus set softcenter_module_unblockmusic_version="1.0.0"
dbus set softcenter_module_unblockmusic_description="解锁网易云灰色歌曲"
dbus set softcenter_module_unblockmusic_install=1
dbus set softcenter_module_unblockmusic_name=unblockmusic
dbus set softcenter_module_unblockmusic_title="解锁网易云灰色歌曲"
[ -z "$unblockmusic_musicapptype" ] && dbus set unblockmusic_musicapptype='default'
[ -z "$unblockmusic_endpoint" ] && dbus set unblockmusic_endpoint='https://music.163.com'
[ -z "$unblockmusic_autoupdate" ] && dbus set unblockmusic_autoupdate=1
dbus set unblockmusic_bin_version=`/jffs/softcenter/bin/UnblockNeteaseMusic -v |grep Version|awk '{print $2}'`
if [ "$enable" == "1" ] && [ -f "/jffs/softcenter/scripts/unblockmusic_config.sh" ];then
	/jffs/softcenter/scripts/unblockmusic_config start >/dev/null 2>&1
fi

rm -fr /tmp/unblockmusic* >/dev/null 2>&1
echo_date "unblockmusic插件安装完毕！"
echo_date "The plugin [unblockmusic] is installed"
exit 0

