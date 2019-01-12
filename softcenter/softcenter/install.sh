#!/bin/sh

softcenter_install() {
	if [ -d "/tmp/softcenter" ]; then
		cp -rf /tmp/softcenter/webs/* /jffs/softcenter/webs
		cp -rf /tmp/softcenter/res/* /jffs/softcenter/res/
		cp -rf /tmp/softcenter/bin/* /jffs/softcenter/bin/
		cp -rf /tmp/softcenter/perp /jffs/softcenter/
		cp -rf /tmp/softcenter/scripts /jffs/softcenter/
		chmod 755 /jffs/softcenter/bin/*
		chmod 755 /jffs/softcenter/perp/*
		chmod 755 /jffs/softcenter/perp/.boot/*
		chmod 755 /jffs/softcenter/perp/.control/*
		rm -rf /tmp/softcenter
		if [ ! -f "/jffs/softcenter/init.d/S10Softcenter.sh" ]; then
		ln -sf /jffs/softcenter/scripts/ks_app_install.sh /jffs/softcenter/init.d/S10Softcenter.sh
		fi
	fi
}

softcenter_install
