#! /bin/sh

killall shellinaboxd
rm -rf /jffs/softcenter/init.d/*shellinabox*
cp -rf /tmp/shellinabox/shellinabox /jffs/softcenter/
cp -rf /tmp/shellinabox/res/* /jffs/softcenter/res/
cp -rf /tmp/shellinabox/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/shellinabox/webs/* /jffs/softcenter/webs/
cp -rf /tmp/shellinabox/uninstall.sh /jffs/softcenter/scripts/uninstall_shellinabox
chmod 755 /jffs/softcenter/shellinabox/*	
chmod 755 /jffs/softcenter/scripts/*
# open in new window
dbus set softcenter_module_shellinabox_install="1"
dbus set softcenter_module_shellinabox_target="target=_blank"
dbus remove shellinabox_enable
rm -rf /tmp/shellinabox*
