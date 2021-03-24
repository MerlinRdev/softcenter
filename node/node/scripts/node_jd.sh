#!/bin/sh
#
# Copyright (C) 2020 luci-app-jd-dailybonus <jerrykuku@qq.com>
# Copyright (C) 2020 paldier <paldier@hotmail.com>
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#
# 501 下载脚本出错
# 101 没有新版本无需更新
# 0   更新成功

source /jffs/softcenter/scripts/base.sh
eval `dbus export node_jd_`

NAME=jd-dailybonus
TEMP_SCRIPT=/tmp/JD_DailyBonus.js
JD_SCRIPT=/jffs/softcenter/res/JD_DailyBonus.js
LOG_HTM=/tmp/JD_DailyBonus.htm
usage() {
    cat <<-EOF
		Usage: app.sh [options]
		Valid options are:

		    -a                      Add Cron
		    -n                      Check 
		    -r                      Run Script
		    -u                      Update Script From Server
		    -s                      Save Cookie And Add Cron
		    -w                      Background Run With Wechat Message
		    -h                      Help
EOF
    exit $1
}

# Common functions

cancel() {
    if [ $# -gt 0 ]; then
        echo "$1"
    fi
    exit 1
}

fill_cookie() {
    cookie1=$node_jd_cookie
    if [ ! "$cookie1" = "" ]; then
        varb="var Key = '$cookie1';"
        a=$(sed -n '/var Key =/=' $JD_SCRIPT)
        b=$((a-1))
        sed -i "${a}d" $JD_SCRIPT
        sed -i "${b}a ${varb}" $JD_SCRIPT
    fi

    cookie2=$node_jd_cookie2
    if [ ! "$cookie2" = "" ]; then
        varb2="var DualKey = '$cookie2';"
        aa=$(sed -n '/var DualKey =/=' $JD_SCRIPT)
        bb=$((aa-1))
        sed -i "${aa}d" $JD_SCRIPT
        sed -i "${bb}a ${varb2}" $JD_SCRIPT
    fi

    stop=$node_jd_stop
    if [ ! "$stop" = "" ]; then
        varb3="var stop = $stop;"
        sed -i "s/^var stop =.*/$varb3/g" $JD_SCRIPT
    fi
}

add_cron() {
    sed -i '/jd-dailybonus-up/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
    sed -i '/jd-dailybonus/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	timegen=$(expr $(head -n 128 /dev/urandom | tr -dc "0123456789" | head -c4) % 180)
	[ $node_jd_auto_run -eq 1 ] && cru a jd-dailybonus "5 $node_jd_auto_run_time * * * sleep ${timegen}s; /jffs/softcenter/scripts/node_jd.sh -w"
    [ $node_jd_auto_update -eq 1 ] && cru a jd-dailybonus-up "1 $node_jd_auto_update_time * * * /jffs/softcenter/scripts/node_jd.sh -u"
}

# Run Script

serverchan() {
	[ "$node_jd_serverchan_enable" == "0" ] && exit
    sckey=${node_jd_serverchan}
    failed=$node_jd_failed
    desc=$(cat $LOG_HTM | grep -E '签到号|签到概览|签到奖励|其他奖励|账号总计|其他总计' | sed 's/$/&\n/g')
    serverurlflag=$node_jd_serverurl
    serverurl="https://sc.ftqq.com/"

    if [ $failed -eq 1 ]; then
        grep "Cookie失效" $LOG_HTM > /dev/null
        if [ $? -eq 0 ]; then
            title="$(date '+%Y年%m月%d日') 京东签到 Cookie 失效"
            wget -q --output-document=/dev/null --post-data="text=$title~&desp=$desc" $serverurl$sckey.send
        fi
    else
        title="$(date '+%Y年%m月%d日') 京东签到"
        wget -q --output-document=/dev/null --post-data="text=$title~&desp=$desc" $serverurl$sckey.send
    fi

}

run() {
    fill_cookie
    echo -e $(date '+%Y-%m-%d %H:%M:%S %A') >$LOG_HTM 2>/dev/null
    [ ! -f "/jffs/softcenter/bin/node" ] && echo -e "未安装node.js,请安装后再试!\nNode.js is not installed, please try again after installation!">>$LOG_HTM && exit 1
    node $JD_SCRIPT >> $LOG_HTM 2>/dev/null
}

back_run() {
    run
    sleep 1s
    serverchan
}

save() {
    fill_cookie
    add_cron
}

# Update Script From Server
download() {
	[ "$node_jd_remote_url" == "nil" ] && return 0
    wget --user-agent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36" --no-check-certificate -t 3 -T 10 -q $node_jd_remote_url -O $TEMP_SCRIPT
    return $?
}

get_ver() {
    echo $(cat $1 | sed -n '/更新时间/p' | awk '{for (i=1;i<=NF;i++){if ($i ~/v/) {print $i}}}' | sed 's/v//')
}

check_ver() {
    download
    if [ $? -ne 0 ]; then
        cancel "501"
    else
        echo $(get_ver $TEMP_SCRIPT)
    fi
}

update() {
    download
    if [ $? -ne 0 ]; then
        cancel "501"
    fi
    if [ -e $JD_SCRIPT ]; then
        local_ver=$(get_ver $JD_SCRIPT)
    else
        local_ver=0
    fi
    remote_ver=$(get_ver $TEMP_SCRIPT)
    if [ $(expr "$local_ver" \< "$remote_ver") -eq 1 ]; then
        cp -r $TEMP_SCRIPT $JD_SCRIPT
        fill_cookie
        dbus set node_jd_version=$remote_ver
        cancel "0"
    else
        cancel "101"
    fi
}


case "$1" in
a)
	add_cron
        ;;
l)
        serverchan
        ;;
n)
        check_ver
        ;;
r)
        run
        ;;
u)
        update
        ;;
s)
        save
        ;;
w)
        back_run
        ;;
h)
        usage 0
        ;;
esac

