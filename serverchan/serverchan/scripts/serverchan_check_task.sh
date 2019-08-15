#!/bin/sh
source /jffs/softcenter/scripts/base.sh
eval `dbus export serverchan`
/jffs/softcenter/serverchan/serverchan_check task
