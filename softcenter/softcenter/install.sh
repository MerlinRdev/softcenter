#!/bin/sh

MODEL=`nvram get productid`

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
		if [ "$MODEL" == "GT-AC5300" ] || [ "$MODEL" == "GT-AX11000" ] || [ "$MODEL" == "GT-AC2900" ];then
			cp -rf /tmp/softcenter/ROG/webs/* /jffs/softcenter/webs/
			cp -rf /tmp/softcenter/ROG/res/* /jffs/softcenter/res/
		elif [ "$MODEL" == "TUF-AX3000" ] ;then
			cp -rf /tmp/softcenter/TUF/webs/* /jffs/softcenter/webs/
			cp -rf /tmp/softcenter/TUF/res/* /jffs/softcenter/res/
		fi
		#cp -rf /tmp/softcenter/init.d/* /jffs/softcenter/init.d/
		cp -rf /tmp/softcenter/bin/* /jffs/softcenter/bin/
		#for axhnd
		#if [ "`nvram get model`" == "RT-AX88U" ] || [ "`nvram get model`" == "GT-AX11000" ];then
			#cp -rf /tmp/softcenter/axbin/* /jffs/softcenter/bin/
		#fi
		cp -rf /tmp/softcenter/perp /jffs/softcenter/
		cp -rf /tmp/softcenter/scripts/* /jffs/softcenter/scripts
		cp -rf /tmp/softcenter/.soft_ver /jffs/softcenter/
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
		# make some link
		if [ "$MODEL" == "BLUECAVE" ];then
			cp -r /jffs/softcenter/bin/base64_encode /jffs/softcenter/bin/base64_decode
			cp -r /jffs/softcenter/scripts/ks_app_install.sh /jffs/softcenter/scripts/ks_app_remove.sh
			cp -rf /jffs/softcenter/bin/softcenter.sh /jffs/.asusrouter
		else
			[ ! -L "/jffs/softcenter/bin/base64_decode" ] && ln -sf /jffs/softcenter/bin/base64_encode /jffs/softcenter/bin/base64_decode
			[ ! -L "/jffs/softcenter/scripts/ks_app_remove.sh" ] && ln -sf /jffs/softcenter/scripts/ks_app_install.sh /jffs/softcenter/scripts/ks_app_remove.sh
			ln -sf /jffs/softcenter/bin/softcenter.sh /jffs/.asusrouter
			[ -L "/jffs/softcenter/bin/base64" ] && rm -rf /jffs/softcenter/bin/base64
		fi
		chmod 755 /jffs/softcenter/bin/*
		#chmod 755 /jffs/softcenter/init.d/*
		chmod 755 /jffs/softcenter/perp/*
		chmod 755 /jffs/softcenter/perp/.boot/*
		chmod 755 /jffs/softcenter/perp/.control/*
		chmod 755 /jffs/softcenter/scripts/*

		# remove install package
		rm -rf /tmp/softcenter

		firmware_comp=`/jffs/softcenter/bin/versioncmp "$(dbus get softcenter_firmware_version)" 5.0.8`
		[ "$firmware_comp" -ge "0" ] && exit 0

		# creat wan-start nat-start post-mount
		if [ ! -f "/jffs/scripts/wan-start" ];then
			cat > /jffs/scripts/wan-start <<-EOF
			#!/bin/sh
			/jffs/softcenter/bin/softcenter-wan.sh start
			EOF
			chmod +x /jffs/scripts/wan-start
		else
			STARTCOMAND1=`cat /jffs/scripts/wan-start | grep -c "/jffs/softcenter/bin/softcenter-wan.sh start"`
			[ "$STARTCOMAND1" -gt "1" ] && sed -i '/softcenter-wan.sh/d' /jffs/scripts/wan-start && sed -i '1a /jffs/softcenter/bin/softcenter-wan.sh start' /jffs/scripts/wan-start
			[ "$STARTCOMAND1" == "0" ] && sed -i '1a /jffs/softcenter/bin/softcenter-wan.sh start' /jffs/scripts/wan-start
		fi
		
		if [ ! -f "/jffs/scripts/nat-start" ];then
			cat > /jffs/scripts/nat-start <<-EOF
			#!/bin/sh
			/jffs/softcenter/bin/softcenter-net.sh start_nat
			EOF
			chmod +x /jffs/scripts/nat-start
		else
			STARTCOMAND2=`cat /jffs/scripts/nat-start | grep -c "/jffs/softcenter/bin/softcenter-net.sh start"`
			[ "$STARTCOMAND2" -gt "1" ] && sed -i '/softcenter-net.sh/d' /jffs/scripts/nat-start && sed -i '1a /jffs/softcenter/bin/softcenter-net.sh start_nat' /jffs/scripts/nat-start
			[ "$STARTCOMAND2" == "0" ] && sed -i '1a /jffs/softcenter/bin/softcenter-net.sh start_nat' /jffs/scripts/nat-start
		fi
		
		if [ ! -f "/jffs/scripts/post-mount" ];then
			cat > /jffs/scripts/post-mount <<-EOF
			#!/bin/sh
			/jffs/softcenter/bin/softcenter-mount.sh start
			EOF
			chmod +x /jffs/scripts/post-mount
		else
			STARTCOMAND2=`cat /jffs/scripts/post-mount | grep -c "/jffs/softcenter/bin/softcenter-mount.sh start"`
			[ "$STARTCOMAND2" -gt "1" ] && sed -i '/softcenter-mount.sh/d' /jffs/scripts/post-mount && sed -i '1a /jffs/softcenter/bin/softcenter-mount.sh start' /jffs/scripts/post-mount
			[ "$STARTCOMAND2" == "0" ] && sed -i '1a /jffs/softcenter/bin/softcenter-mount.sh start' /jffs/scripts/post-mount
		fi
	fi
	exit 0
}

softcenter_install
