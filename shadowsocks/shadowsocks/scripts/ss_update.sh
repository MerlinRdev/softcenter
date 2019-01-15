#!/bin/sh

eval `dbus export ss`

sh /jffs/softcenter/ss/ssconfig.sh update
