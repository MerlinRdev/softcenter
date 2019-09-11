#!/bin/sh
source /jffs/softcenter/scripts/base.sh
eval `dbus export serverchan`
/jffs/softcenter/scripts/serverchan_check.sh task
