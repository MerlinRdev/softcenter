#! /bin/sh
source /jffs/softcenter/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
DIR=$(cd $(dirname $0); pwd)

firmware_version=`nvram get extendno|cut -d "_" -f2|cut -d "-" -f1|cut -c2-5`
productid=`nvram get productid`
if [ "$productid" == "BLUECAVE" ];then
	if [ "$(nvram get modelname)" == "K3C" ];then
	firmware_ver=`nvram get extendno|grep B`
	if [ -n "$firmware_ver" ];then
		firmware_check=22.2
	else
		firmware_check=7.2
	fi
	else
		firmware_check=17.2
	fi
elif [ "$productid" == "RT-AC68U" ];then
	if [ "$(nvram get modelname)" == "SBR-AC1900P" ];then
		firmware_check=4.3
	else
		firmware_check=1
	fi
elif [ "$productid" == "RT-AC3200" ];then
	if [ "$(nvram get modelname)" == "SBR-AC3200P" ];then
		firmware_check=4.3
	else
		firmware_check=1
	fi
elif [ "$productid" == "RT-AC3100" ];then
	if [ "$(nvram get modelname)" == "K3" ];then
		firmware_check=5.0
	else
		firmware_check=1
	fi
elif [ "$productid" == "GT-AC5300" ];then
	if [ "$(nvram get modelname)" == "R7900P" ];then
		firmware_check=1
	else
		firmware_check=1
	fi
elif [ "$productid" == "GT-AC2900" ];then
	firmware_check=1
elif [ "$productid" == "RT-AC86U" ];then
	firmware_check=1
elif [ "$productid" == "RT-AC88U" ];then
	firmware_check=1
elif [ "$productid" == "RT-ACRH17" ];then
	firmware_check=1
else
	firmware_check=100
fi
firmware_comp=`/jffs/softcenter/bin/versioncmp $firmware_version $firmware_check`
if [ "$firmware_comp" == "1" ];then
	echo_date 固件版本过低，无法安装
	exit 1
fi
# 安装插件
cd /tmp
cp -rf /tmp/acme/acme /jffs/softcenter/
cp -rf /tmp/acme/res/* /jffs/softcenter/res/
cp -rf /tmp/acme/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/acme/webs/* /jffs/softcenter/webs/
cp -rf /tmp/acme/uninstall.sh /jffs/softcenter/scripts/uninstall_acme.sh
if [ "$(nvram get productid)" = "BLUECAVE" ];then
	[ ! -f "/jffs/softcenter/init.d/M99acme.sh" ] && cp -rf /jffs/softcenter/scripts/acme_config.sh /jffs/softcenter/init.d/M99acme.sh
else
	[ ! -L "/jffs/softcenter/init.d/S99acme.sh" ] && ln -sf /jffs/softcenter/scripts/acme_config.sh /jffs/softcenter/init.d/S99acme.sh
fi
chmod 755 /jffs/softcenter/acme/*
chmod 755 /jffs/softcenter/init.d/*
chmod 755 /jffs/softcenter/scripts/acme*
if [ "`nvram get model`" == "GT-AC5300" ] || [ "`nvram get model`" == "GT-AC2900" ];then
	continue
else
	sed -i '/rogcss/d' /jffs/softcenter/webs/Module_acme.asp >/dev/null 2>&1
fi

# 离线安装需要向skipd写入安装信息
dbus set acme_version="$(cat $DIR/version)"
dbus set softcenter_module_acme_version="$(cat $DIR/version)"
dbus set softcenter_module_acme_install="1"
dbus set softcenter_module_acme_name="acme"
dbus set softcenter_module_acme_title="Let's Encrypt"
dbus set softcenter_module_acme_description="自动部署SSL证书"

# 完成
echo_date "Let's Encrypt插件安装完毕！"
rm -rf /tmp/acme* >/dev/null 2>&1
exit 0
