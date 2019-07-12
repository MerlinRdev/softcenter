#!/bin/sh

source /jffs/softcenter/scripts/base.sh
eval `dbus export fcn_`

if [ ! -d /jffs/softcenter/etc ]; then
   mkdir -p /jffs/softcenter/etc
fi

conf_file="/jffs/softcenter/etc/fcn.conf"

write_conf(){
    # fcn configuration
    echo "[uid]="$fcn_uid > $conf_file
    echo "[name]="$fcn_name >> $conf_file
    echo "[psk]="$fcn_psk >> $conf_file
    [ ! -z "$fcn_uic" ] && echo "[uic]="$fcn_uic >> $conf_file
    [ ! -z "$fcn_host" ] && echo "[host]="$fcn_host >> $conf_file
    echo "[udp]="$fcn_udp >> $conf_file
    echo "[notun]=1" >> $conf_file
    echo "[nat_nic]=br0" >> $conf_file
    echo "[cipher]=chacha20" >> $conf_file
}

start_fcn(){
    /jffs/softcenter/bin/fcn --cfg $conf_file &
}

stop_fcn(){
    killall fcn
}

creat_start_up(){
	if [ "$(nvram get productid)" = "BLUECAVE" ];then
		cp -r /jffs/softcenter/scripts/fcn_config.sh /jffs/softcenter/init.d/M97fcn.sh
		cp -r /jffs/softcenter/scripts/fcn_config.sh /jffs/softcenter/init.d/N97fcn.sh
	else
		[ ! -L "/jffs/softcenter/init.d/S97fcn.sh" ] && ln -sf /jffs/softcenter/scripts/fcn_config.sh /jffs/softcenter/init.d/S97fcn.sh
	fi
}

del_start_up(){
	if [ "$(nvram get productid)" = "BLUECAVE" ];then
		[ -f "/jffs/softcenter/init.d/M97fcn.sh" ] && rm -rf /jffs/softcenter/init.d/M97fcn.sh
		[ -f "/jffs/softcenter/init.d/N97fcn.sh" ] && rm -rf /jffs/softcenter/init.d/N97fcn.sh
	else
		[ -L "/jffs/softcenter/init.d/S97fcn.sh" ] && rm -rf /jffs/softcenter/init.d/S97Kms.sh
	fi
}

case $1 in
start)
	if [ "$fcn_enable" == "1" ];then
		write_conf
		stop_fcn
		start_fcn
		creat_start_up
	else
		stop_fcn
		del_start_up
	fi
	;;
start_nat)
	if [ "$fcn_enable" == "1" -a -n "$(pidof fcn)" ];then
		write_conf
		stop_fcn
		start_fcn
		creat_start_up
	fi
	;;
restart)
	if [ "$fcn_enable" == "1" ];then
		write_conf
		stop_fcn
		start_fcn
		creat_start_up
	else
		stop_fcn
		del_start_up
	fi
	;;
esac
