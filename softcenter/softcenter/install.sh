#!/bin/sh

MODEL=`nvram get productid`
if [ "$MODEL" == "GT-AC5300" ] || [ "$MODEL" == "GT-AX11000" ] || [ "$MODEL" == "GT-AC2900" ] || [ "$(nvram get merlinr_rog)" == "1" ];then
	ROG=1
elif [ "$MODEL" == "TUF-AX3000" ] || [ "$(nvram get merlinr_tuf)" == "1" ] ;then
	TUF=1
fi
softcenter_install() {
	if [ -d "/tmp/softcenter" ]; then
		# make some folders
		mkdir -p /jffs/configs/dnsmasq.d
		mkdir -p /jffs/scripts
		mkdir -p /jffs/etc
		mkdir -p /jffs/softcenter/etc/
		mkdir -p /jffs/softcenter/bin/
		mkdir -p /jffs/softcenter/init.d/
		mkdir -p /jffs/softcenter/scripts/
		mkdir -p /jffs/softcenter/configs/
		mkdir -p /jffs/softcenter/webs/
		mkdir -p /jffs/softcenter/res/
		
		# remove useless files
		[ -L "/jffs/configs/profile" ] && rm -rf /jffs/configs/profile
		
		# coping files
		cp -rf /tmp/softcenter/webs/* /jffs/softcenter/webs/
		cp -rf /tmp/softcenter/res/* /jffs/softcenter/res/

		#cp -rf /tmp/softcenter/init.d/* /jffs/softcenter/init.d/
		cp -rf /tmp/softcenter/bin/* /jffs/softcenter/bin/
		cp -rf /tmp/softcenter/perp /jffs/softcenter/
		cp -rf /tmp/softcenter/scripts/* /jffs/softcenter/scripts
		cp -rf /tmp/softcenter/.soft_ver /jffs/softcenter/
		if [ "$ROG" == "1" ]; then
			cp -rf /tmp/softcenter/ROG/res/* /jffs/softcenter/res/
		elif [ "$TUF" == "1" ]; then
			sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /tmp/softcenter/ROG/res/*.css >/dev/null 2>&1
			cp -rf /tmp/softcenter/ROG/res/* /jffs/softcenter/res/
		fi
		dbus set softcenter_version=`cat /jffs/softcenter/.soft_ver`
		dbus set softcenter_firmware_version=`nvram get extendno|cut -d "_" -f2|cut -d "-" -f1|cut -c2-6`
		ARCH=`uname -m`
		KVER=`uname -r`
		if [ "$ARCH" == "armv7l" ]; then
			if [ "$KVER" == "4.1.52" -o "$KVER" == "3.14.77" ];then
				dbus set softcenter_arch="armng"
			else
				dbus set softcenter_arch="$ARCH"
			fi
		else
			if [ "$KVER" == "3.10.14" ];then
				dbus set softcenter_arch="mipsle"
			else
				dbus set softcenter_arch="$ARCH"
			fi
		fi
		dbus set softcenter_api=`cat /jffs/softcenter/.soft_ver`
		if [ -f "/jffs/softcenter/scripts/ks_tar_intall.sh" ];then
			rm -rf /jffs/softcenter/scripts/ks_tar_intall.sh
		fi
		# make some link
		[ ! -L "/jffs/softcenter/bin/base64_decode" ] && cd /jffs/softcenter/bin && ln -sf base64_encode base64_decode
		[ ! -L "/jffs/softcenter/scripts/ks_app_remove.sh" ] && cd /jffs/softcenter/scripts && ln -sf ks_app_install.sh ks_app_remove.sh
		chmod 755 /jffs/softcenter/bin/*
		#chmod 755 /jffs/softcenter/init.d/*
		chmod 755 /jffs/softcenter/perp/*
		chmod 755 /jffs/softcenter/perp/.boot/*
		chmod 755 /jffs/softcenter/perp/.control/*
		chmod 755 /jffs/softcenter/scripts/*

		# remove install package
		rm -rf /tmp/softcenter

		# creat wan-start nat-start post-mount
		if [ ! -f "/jffs/scripts/wan-start" ];then
			cat > /jffs/scripts/wan-start <<-EOF
			#!/bin/sh
			EOF
			chmod +x /jffs/scripts/wan-start
		fi
		
		if [ ! -f "/jffs/scripts/nat-start" ];then
			cat > /jffs/scripts/nat-start <<-EOF
			#!/bin/sh
			EOF
			chmod +x /jffs/scripts/nat-start
		fi
		
		if [ ! -f "/jffs/scripts/post-mount" ];then
			cat > /jffs/scripts/post-mount <<-EOF
			#!/bin/sh
			EOF
			chmod +x /jffs/scripts/post-mount
		fi
	fi
	exit 0
}

softcenter_install
