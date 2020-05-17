#! /bin/sh
source /jffs/softcenter/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
DIR=$(cd $(dirname $0); pwd)
MODEL=$(nvram get productid)
#firmware_version=`nvram get extendno|cut -d "_" -f2|cut -d "-" -f1|cut -c2-6`
#firmware_check=5.0.1
#if [ ${#firmware_version} -lt 5 ];then
#	firmware_version=1.0.0
#fi
#firmware_comp=`/jffs/softcenter/bin/versioncmp $firmware_version $firmware_check`
#if [ "$firmware_comp" == "1" ];then
#	echo_date 固件版本过低，无法安装
#	exit 1
#fi
if [ "$MODEL" == "GT-AC5300" ] || [ "$MODEL" == "GT-AX11000" ] || [ "$MODEL" == "GT-AC2900" ] || [ "$(nvram get merlinr_rog)" == "1" ];then
	ROG=1
elif [ "$MODEL" == "TUF-AX3000" ] || [ "$(nvram get merlinr_tuf)" == "1" ] ;then
	TUF=1
fi
# 安装插件
cd /tmp
cp -rf /tmp/acme/acme /jffs/softcenter/
cp -rf /tmp/acme/res/* /jffs/softcenter/res/
cp -rf /tmp/acme/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/acme/webs/* /jffs/softcenter/webs/
cp -rf /tmp/acme/uninstall.sh /jffs/softcenter/scripts/uninstall_acme.sh
chmod 755 /jffs/softcenter/acme/*
chmod 755 /jffs/softcenter/init.d/*
chmod 755 /jffs/softcenter/scripts/acme*
[ ! -L "/jffs/softcenter/init.d/S99acme.sh" ] && ln -sf /jffs/softcenter/scripts/acme_config.sh /jffs/softcenter/init.d/S99acme.sh
if [ "$ROG" == "1" ];then
	echo_date "安装ROG皮肤！"
	continue
elif [ "$TUF" == "1" ];then
	echo_date "安装TUF皮肤！"
	sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /jffs/softcenter/webs/Module_acme.asp >/dev/null 2>&1
else
	echo_date "安装ASUSWRT皮肤！"
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
