#!/bin/sh

alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
source /jffs/softcenter/scripts/base.sh

uupid=`pidof uuplugin`

if [ -n "$uupid" ]; then
	echo "<font color=green>$(echo_date) uu正在运行，(pid：$uupid)</font>"  > /tmp/uu_log.log
else
	echo "<font color=red>$(echo_date) uu未运行...</font>"  > /tmp/uu_log.log
fi
