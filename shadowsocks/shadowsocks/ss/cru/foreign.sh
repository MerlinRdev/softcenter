#!/bin/sh
LOGTIME=$(date "+%Y-%m-%d %H:%M:%S")
server_ip=`nslookup "facebook.com" 127.0.0.1 | sed '1,4d' | awk '{print $3}' | grep -v :|awk 'NR==1{print}'`
/usr/sbin/wget -4 --spider --quiet --tries=2 --timeout=2 $server_ip

if [ "$?" == "0" ]; then
  log='[ '$LOGTIME' ] working...'
else
  log='[ '$LOGTIME' ] Problem detected!'
fi

nvram set ss_foreign_state="$log"
#dbus ram ss_basic_state_foreign="$log"
