#!/bin/sh

alias echo_date1='echo $(date +%Y年%m月%d日\ %X)'
source /jffs/softcenter/scripts/base.sh
eval `dbus export koolproxyR_`

version="koolproxyR `koolproxy -v`"
pid=`pidof koolproxy`
date=`echo_date1`
#kpr规则
easylist_rules_local=`cat /jffs/softcenter/koolproxyR/data/rules/easylistchina.txt  | sed -n '3p'|awk '{print $3,$4}' | sed -n 's/\([0-9]\{4\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)/\1年\2月\3日 /p'`
easylist_nu_local=`grep -E -v "^!" /jffs/softcenter/koolproxyR/data/rules/easylistchina.txt | wc -l`
# 补充规则版本号暂时没有
replenish_rules_local=`cat /jffs/softcenter/koolproxyR/data/rules/yhosts.txt  | sed -n '2p' | cut -d "=" -f2 | sed -n 's/\([0-9]\{4\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)/\1年\2月\3日 /p'`
replenish_nu_local=`grep -E -v "^!" /jffs/softcenter/koolproxyR/data/rules/yhosts.txt | wc -l`
fanboy_nu_local=`grep -E -v "^!" /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance.txt | wc -l`
# 不启用fanboy 全规则版本
fanboy_rules_local=`cat /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance.txt  | sed -n '3p'|awk '{print $3,$4}' | sed -n 's/\([0-9]\{4\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)/\1年\2月\3日 /p'`
# 从此由kpr自己更新视频规则
video_rules_local=`cat /jffs/softcenter/koolproxyR/data/rules/kp.dat.md5 | sed -n '2p'`
video_nu_local=`cat /jffs/softcenter/koolproxyR/data/rules/kp.dat.md5 | sed -n '3p'`
#kpr规则
rules_date_local=`cat /jffs/softcenter/koolproxyR/data/rules/koolproxy.txt  | sed -n '3p'|awk '{print $3,$4}'`
rules_nu_local=`grep -E -v "^!" /jffs/softcenter/koolproxyR/data/rules/koolproxy.txt | wc -l`
video_date_local=`cat /jffs/softcenter/koolproxyR/data/rules/koolproxy.txt  | sed -n '4p'|awk '{print $3,$4}'`
daily_nu_local=""
[ -f "/jffs/softcenter/koolproxyR/data/rules/daily.txt" ] && daily_nu_local=`grep -E -v "^!" /jffs/softcenter/koolproxyR/data/rules/daily.txt | wc -l`
custom_nu_local=`grep -E -v "^!" /jffs/softcenter/koolproxyR/data/rules/user.txt | wc -l`

rm -rf /tmp/kp_tp.txt
tp_rules=`dbus list koolproxyR_rule_file_|cut -d "=" -f1|cut -d "_" -f4|sort -n`
local i=1
for tp_rule in $tp_rules
do
	tprule_name=`dbus get koolproxyR_rule_file_$tp_rule`
	if [ -f "/jffs/softcenter/koolproxyR/data/rules/$tprule_name" ]; then
		eval tprule_nu_$i=`grep -E -v "^!" /jffs/softcenter/koolproxyR/data/rules/$tprule_name | wc -l`
		eval temp=$(echo \$tprule_nu_$i)
		#echo $tp_rule $tprule_name $temp条
		echo -n "@@<span>$temp条</span>&&$tp_rule" >>/tmp/kp_tp.txt
		let i++
	else
		echo -n "@@<span>null</span>&&$tp_rule" >>/tmp/kp_tp.txt
	fi
done

if [ -f "/tmp/kp_tp.txt" ];then
	TP=`cat /tmp/kp_tp.txt`
else
	TP=""
fi
rm -rf /tmp/koolproxyR.log
if [ "$pid" != "" ];then
	echo "【$date】 $version  运行正常！(PID: $pid)@@<span>$easylist_rules_local<br>$easylist_nu_local条</span>@@<span>$fanboy_rules_local<br>$fanboy_nu_local条</span>@@<span>$video_rules_local<br>$video_nu_local条<span>@@$custom_nu_local条</span>@@<span>$rules_date_local<br>$rules_nu_local条</span>@@<span>$replenish_rules_local<br>$replenish_nu_local条</span>$TP" > /tmp/koolproxyR.log
else
	echo "<font color='#FF0000'>【警告】：进程未运行！请点击提交按钮！</font>@@<span>$easylist_rules_local<br>$easylist_nu_local条</span>@@<span>$fanboy_rules_local<br>$fanboy_nu_local条</span>@@<span>$video_rules_local<br>$video_nu_local条<span>@@$custom_nu_local条</span>@@<span>$rules_date_local<br>$rules_nu_local条</span>@@<span>$replenish_rules_local<br>$replenish_nu_local条</span>$TP" > /tmp/koolproxyR.log
fi
echo XU6J03M6 >> /tmp/koolproxyR.log



