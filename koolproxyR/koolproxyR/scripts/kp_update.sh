#!/bin/sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
source /jffs/softcenter/scripts/base.sh
eval `dbus export koolproxyR_`

url_cjx="https://shaoxia1991.coding.net/p/cjxlist/d/cjxlist/git/raw/master/cjx-annoyance.txt"
url_kp="https://houzi-.coding.net/p/my_dream/d/my_dream/git/raw/master/kp.dat"
url_kp_md5="https://houzi-.coding.net/p/my_dream/d/my_dream/git/raw/master/kp.dat.md5"
# url_koolproxyR="https://kprules.b0.upaiyun.com/koolproxyR.txt"
# 原网址跳转到https://kprule.com/koolproxyR.txt跳转到又拍云，为了节省时间，还是直接去又拍云下载吧！避免某些时候跳转不过去
url_easylist="https://easylist-downloads.adblockplus.org/easylistchina.txt"
url_yhosts="https://shaoxia1991.coding.net/p/yhosts/d/yhosts/git/raw/master/hosts"
url_yhosts1="https://shaoxia1991.coding.net/p/yhosts/d/yhosts/git/raw/master/data/tvbox.txt"
kpr_our_rule="https://shaoxia1991.coding.net/p/koolproxyR_rule_list/d/koolproxyR_rule_list/git/raw/master/kpr_our_rule.txt"
url_fanboy="https://secure.fanboy.co.nz/fanboy-annoyance.txt"

    
update_kp_rules(){
	echo_date ================== 规则更新 =================

    echo_date 开始更新koolproxyR的规则，请等待...
    # 赋予文件夹权限 
    chmod -R 777 /jffs/softcenter/koolproxyR/data/rules
	echo_date "-------------------------------------------------"
    # easylistchina 规则
        cd /tmp
      curl -L -O $url_easylist
      curl -L -O $url_cjx
     cd /jffs/softcenter/koolproxyR/data/rules
         curl -L -O $kpr_our_rule
    koolproxyR_https_ChinaList=0
    if [ -s "/tmp/cjx-annoyance.txt" ]; then
	   if [ -s "/tmp/easylistchina.txt" ]; then
		  sleep 1
		  cat /tmp/cjx-annoyance.txt >> /tmp/easylistchina.txt
         	rm /tmp/cjx-annoyance.txt

		   easylist_rules_local=`cat /jffs/softcenter/koolproxyR/data/rules/easylistchina.txt  | sed -n '3p'|awk '{print $3,$4}'`
		   easylist_rules_local1=`cat /tmp/easylistchina.txt  | sed -n '3p'|awk '{print $3,$4}'`
		   echo_date KPR主规则的本地版本号： $easylist_rules_local
		   echo_date KPR主规则的在线版本号： $easylist_rules_local1
		    if [[ "$easylist_rules_local" != "$easylist_rules_local1" ]]; then
			  echo_date 检测到 KPR主规则 已更新，现在开始更新...
		        echo_date 将临时的KPR主规则文件移动到指定位置
			  mv /tmp/easylistchina.txt /jffs/softcenter/koolproxyR/data/rules/easylistchina.txt
			  koolproxyR_https_ChinaList=1
		    else
			  echo_date 检测到 KPR主规则 版本号相同，无需更新!	
		    fi
	    fi
    fi
	echo_date "-------------------------------------------------"
    # update 补充规则
    cd /tmp
    curl -L -O $url_yhosts
    mv hosts yhosts.txt
    curl -L -O $url_yhosts1
    koolproxyR_https_mobile=0
    if [ -s "/tmp/tvbox.txt" ]; then
	   if [ -s "/tmp/yhosts.txt" ]; then
		  sleep 1
		    cat /tmp/tvbox.txt >> /tmp/yhosts.txt
		    replenish_rules_local=`cat /jffs/softcenter/koolproxyR/data/rules/yhosts.txt  | sed -n '2p' | cut -d "=" -f2`
		    replenish_rules_local1=`cat /tmp/yhosts.txt | sed -n '2p' | cut -d "=" -f2`
			echo_date 补充规则本地版本号： $replenish_rules_local
			echo_date 补充规则在线版本号： $replenish_rules_local1
		    if [[ "$replenish_rules_local" != "$replenish_rules_local1" ]] ; then
	         	echo_date 将临时文件覆盖到原始 补充规则 文件
			   mv /tmp/yhosts.txt /jffs/softcenter/koolproxyR/data/rules/yhosts.txt
			   koolproxyR_https_mobile=1
		    else
			  echo_date 检测到 补充规则 版本号相同，无需更新!
		    fi
	    fi
    fi
	echo_date "-------------------------------------------------"
    # update 视频规则
    cd /tmp
    curl -L -O $url_kp
    curl -L -O $url_kp_md5
    kpr_video_md5=`md5sum /jffs/softcenter/koolproxyR/data/rules/kp.dat | awk '{print $1}'`
    kpr_video_new_md5=`cat /tmp/kp.dat.md5 | sed -n '1p'`
	echo_date 远程视频规则md5：$kpr_video_new_md5
    echo_date 您本地视频规则md5：$kpr_video_md5
    if [ -s "/tmp/kp.dat" ]; then
	    if [[ "$kpr_video_md5" != "$kpr_video_new_md5" ]]; then
	       echo_date 将临时文件覆盖到原始 视频规则 文件
		  mv /tmp/kp.dat /jffs/softcenter/koolproxyR/data/rules/kp.dat
		   mv /tmp/kp.dat.md5 /jffs/softcenter/koolproxyR/data/rules/kp.dat.md5
	    else
		   echo_date 检测到 视频规则 版本号相同，无需更新!
	    fi
    fi
    echo_date "-------------------------------------------------"
    # update fanboy规则
    cd /tmp
    curl -L -O $url_fanboy
    fanboy_rules_local=`cat /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance.txt  | sed -n '3p'|awk '{print $3,$4}'`
    fanboy_rules_local1=`cat /tmp/fanboy-annoyance.txt  | sed -n '3p'|awk '{print $3,$4}'`
	echo_date fanboy规则本地版本号： $fanboy_rules_local
	echo_date fanboy规则在线版本号： $fanboy_rules_local1
    koolproxyR_https_fanboy=0
    if [ -s "/tmp/fanboy-annoyance.txt" ];then
	    if [[ "$fanboy_rules_local" != "$fanboy_rules_local1" ]]; then
             		echo_date 检测到新版本 fanboy规则 列表，开始更新...
			echo_date 将临时文件覆盖到原始 fanboy规则 文件
		  mv /tmp/fanboy-annoyance.txt /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance.txt
		   koolproxyR_https_fanboy=1
		   
	    else
	     echo_date 检测到 fanboy规则 版本号相同，无需更新!
	   fi
    fi


    rm -rf /tmp/fanboy-annoyance.txt
    rm -rf /tmp/yhosts.txt
    rm -rf /tmp/easylistchina.txt
	echo_date "-------------------------------------------------"
    echo_date ===============================优化规则===============================
    
 	if [[ "$koolproxyR_https_fanboy" == "1" ]]; then
		echo_date 正在优化 fanboy规则。。。。。
		# 删除导致KP崩溃的规则
		# 听说高手?都打的很多、这样才能体现技术
		sed -i '/^\$/d' /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance.txt
		sed -i '/\*\$/d' /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance.txt
		# 给三大视频网站放行 由kp.dat负责
		sed -i '/youku.com/d' /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance.txt
		sed -i '/iqiyi.com/d' /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance.txt
		sed -i '/qq.com/d' /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance.txt
		sed -i '/g.alicdn.com/d' /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance.txt
		sed -i '/tudou.com/d' /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance.txt
		sed -i '/gtimg.cn/d' /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance.txt
		# 给知乎放行
		sed -i '/zhihu.com/d' /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance.txt


		# 将规则转化成kp能识别的https
		cat /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance.txt | grep "^||" | sed 's#^||#||https://#g' >> /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance_https.txt
		# 移出https不支持规则domain=
		sed -i 's/\(,domain=\).*//g' /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance_https.txt
		sed -i 's/\(\$domain=\).*//g' /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance_https.txt
		sed -i 's/\(domain=\).*//g' /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance_https.txt
		sed -i '/\^$/d' /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance_https.txt
		sed -i '/\^\*\.gif/d' /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance_https.txt
		sed -i '/\^\*\.jpg/d' /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance_https.txt

		cat /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance.txt | grep "^||" | sed 's#^||#||http://#g' >> /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance_https.txt

		cat /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance.txt | grep -i '^[0-9a-z]'| grep -v '^http'| sed 's#^#https://#g' >> /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance_https.txt
		cat /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance.txt | grep -i '^[0-9a-z]'| grep -v '^http'| sed 's#^#http://#g' >> /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance_https.txt
		cat /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance.txt | grep -i '^[0-9a-z]'| grep -i '^http' >> /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance_https.txt


		# 给github放行
		sed -i '/github/d' /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance_https.txt
		# 给api.twitter.com的https放行
		sed -i '/twitter.com/d' /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance_https.txt
		# 给facebook.com的https放行
		sed -i '/facebook.com/d' /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance_https.txt
		sed -i '/fbcdn.net/d' /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance_https.txt
		# 给 instagram.com 放行
		sed -i '/instagram.com/d' /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance_https.txt
		# 给 twitch.tv 放行
		sed -i '/twitch.tv/d' /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance_https.txt
		# 删除可能导致卡顿的HTTPS规则
		sed -i '/\.\*\//d' /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance_https.txt
		# 给国内三大电商平台放行
		sed -i '/jd.com/d' /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance_https.txt
		sed -i '/taobao.com/d' /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance_https.txt
		sed -i '/tmall.com/d' /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance_https.txt

		# 删除不必要信息重新打包 15 表示从第15行开始 $表示结束
		sed -i '15,$d' /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance.txt
		# 合二归一
		cat /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance_https.txt >> /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance.txt
		# 删除可能导致kpr卡死的神奇规则
		sed -i '/https:\/\/\*/d' /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance.txt
		# 给 netflix.com 放行
		sed -i '/netflix.com/d' /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance.txt
		# 给 tvbs.com 放行
		sed -i '/tvbs.com/d' /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance.txt
		sed -i '/googletagmanager.com/d' /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance.txt
		# 给 microsoft.com 放行
		sed -i '/microsoft.com/d' /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance.txt
		# 给apple的https放行
		sed -i '/apple.com/d' /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance.txt
		sed -i '/mzstatic.com/d' /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance.txt
		# 终极 https 卡顿优化 grep -n 显示行号  awk -F 分割数据  sed -i "${del_rule}d" 需要""" 和{}引用变量
		# 当 koolproxyR_del_rule 是1的时候就一直循环，除非 del_rule 变量为空了。
		koolproxyR_del_rule=1
		while [ $koolproxyR_del_rule = 1 ];do
			del_rule=`cat /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance.txt | grep -n 'https://' | grep '\*' | grep -v '/\*'| grep -v '\^\*' | grep -v '\*\=' | grep -v '\$s\@' | grep -v '\$r\@'| awk -F":" '{print $1}' | sed -n '1p'`
			if [[ "$del_rule" != "" ]]; then
				sed -i "${del_rule}d" /jffs/softcenter/koolproxyR/data/rules/fanboy-annoyance.txt
			else
				koolproxyR_del_rule=0
			fi
		done


	else
		echo_date 跳过优化 fanboy规则。。。。。
	fi



	if [[ "$koolproxyR_https_ChinaList" == "1" ]]; then
		echo_date 正在优化 KPR主规则。。。。。
		sed -i '/^\$/d' /jffs/softcenter/koolproxyR/data/rules/easylistchina.txt
		sed -i '/\*\$/d' /jffs/softcenter/koolproxyR/data/rules/easylistchina.txt
		# 给btbtt.替换过滤规则。
		sed -i 's#btbtt.\*#\*btbtt.\*#g' /jffs/softcenter/koolproxyR/data/rules/easylistchina.txt
		# 给手机百度图片放行
		sed -i '/baidu.com\/it\/u/d' /jffs/softcenter/koolproxyR/data/rules/easylistchina.txt
		# # 给手机百度放行
		# sed -i '/mbd.baidu.comd' /jffs/softcenter/koolproxyR/data/rules/easylistchina.txt
		# 给知乎放行
		sed -i '/zhihu.com/d' /jffs/softcenter/koolproxyR/data/rules/easylistchina.txt
		# 给apple的https放行
		sed -i '/apple.com/d' /jffs/softcenter/koolproxyR/data/rules/easylistchina.txt
		sed -i '/mzstatic.com/d' /jffs/softcenter/koolproxyR/data/rules/easylistchina.txt



		# 将规则转化成kp能识别的https
		cat /jffs/softcenter/koolproxyR/data/rules/easylistchina.txt | grep "^||" | sed 's#^||#||https://#g' >> /jffs/softcenter/koolproxyR/data/rules/easylistchina_https.txt
		# 移出https不支持规则domain=
		sed -i 's/\(,domain=\).*//g' /jffs/softcenter/koolproxyR/data/rules/easylistchina_https.txt
		sed -i 's/\(\$domain=\).*//g' /jffs/softcenter/koolproxyR/data/rules/easylistchina_https.txt
		sed -i 's/\(domain=\).*//g' /jffs/softcenter/koolproxyR/data/rules/easylistchina_https.txt
		sed -i '/\^$/d' /jffs/softcenter/koolproxyR/data/rules/easylistchina_https.txt
		sed -i '/\^\*\.gif/d' /jffs/softcenter/koolproxyR/data/rules/easylistchina_https.txt
		sed -i '/\^\*\.jpg/d' /jffs/softcenter/koolproxyR/data/rules/easylistchina_https.txt



		cat /jffs/softcenter/koolproxyR/data/rules/easylistchina.txt | grep "^||" | sed 's#^||#||http://#g' >> /jffs/softcenter/koolproxyR/data/rules/easylistchina_https.txt

		cat /jffs/softcenter/koolproxyR/data/rules/easylistchina.txt | grep -i '^[0-9a-z]'| grep -v '^http'| sed 's#^#https://#g' >> /jffs/softcenter/koolproxyR/data/rules/easylistchina_https.txt
		cat /jffs/softcenter/koolproxyR/data/rules/easylistchina.txt | grep -i '^[0-9a-z]'| grep -v '^http'| sed 's#^#http://#g' >> /jffs/softcenter/koolproxyR/data/rules/easylistchina_https.txt
		cat /jffs/softcenter/koolproxyR/data/rules/easylistchina.txt | grep -i '^[0-9a-z]'| grep -i '^http' >> /jffs/softcenter/koolproxyR/data/rules/easylistchina_https.txt
		# 给facebook.com的https放行
		sed -i '/facebook.com/d' /jffs/softcenter/koolproxyR/data/rules/easylistchina_https.txt
		sed -i '/fbcdn.net/d' /jffs/softcenter/koolproxyR/data/rules/easylistchina_https.txt
		# 删除可能导致卡顿的HTTPS规则
		sed -i '/\.\*\//d' /jffs/softcenter/koolproxyR/data/rules/easylistchina_https.txt



		# 删除不必要信息重新打包 15 表示从第15行开始 $表示结束
		sed -i '6,$d' /jffs/softcenter/koolproxyR/data/rules/easylistchina.txt
		# 合二归一
		cat /jffs/softcenter/koolproxyR/data/rules/easylistchina_https.txt >> /jffs/softcenter/koolproxyR/data/rules/easylistchina.txt
		# 给三大视频网站放行 由kp.dat负责
		sed -i '/youku.com/d' /jffs/softcenter/koolproxyR/data/rules/easylistchina.txt
		sed -i '/iqiyi.com/d' /jffs/softcenter/koolproxyR/data/rules/easylistchina.txt
		sed -i '/g.alicdn.com/d' /jffs/softcenter/koolproxyR/data/rules/easylistchina.txt
		sed -i '/tudou.com/d' /jffs/softcenter/koolproxyR/data/rules/easylistchina.txt
		sed -i '/gtimg.cn/d' /jffs/softcenter/koolproxyR/data/rules/easylistchina.txt
		# 给https://qq.com的html规则放行
		sed -i '/qq.com/d' /jffs/softcenter/koolproxyR/data/rules/easylistchina.txt
		# 删除可能导致kpr卡死的神奇规则
		sed -i '/https:\/\/\*/d' /jffs/softcenter/koolproxyR/data/rules/easylistchina.txt
		# 给国内三大电商平台放行
		sed -i '/jd.com/d' /jffs/softcenter/koolproxyR/data/rules/easylistchina.txt
		sed -i '/taobao.com/d' /jffs/softcenter/koolproxyR/data/rules/easylistchina.txt
		sed -i '/tmall.com/d' /jffs/softcenter/koolproxyR/data/rules/easylistchina.txt
		# 给 netflix.com 放行
		sed -i '/netflix.com/d' /jffs/softcenter/koolproxyR/data/rules/easylistchina.txt
		# 给 tvbs.com 放行
		sed -i '/tvbs.com/d' /jffs/softcenter/koolproxyR/data/rules/easylistchina.txt
		sed -i '/googletagmanager.com/d' /jffs/softcenter/koolproxyR/data/rules/easylistchina.txt
		# 给 microsoft.com 放行
		sed -i '/microsoft.com/d' /jffs/softcenter/koolproxyR/data/rules/easylistchina.txt
		# 终极 https 卡顿优化 grep -n 显示行号  awk -F 分割数据  sed -i "${del_rule}d" 需要""" 和{}引用变量
		# 当 koolproxyR_del_rule 是1的时候就一直循环，除非 del_rule 变量为空了。
		koolproxyR_del_rule=1
		while [ $koolproxyR_del_rule = 1 ];do
			del_rule=`cat /jffs/softcenter/koolproxyR/data/rules/easylistchina.txt | grep -n 'https://' | grep '\*' | grep -v '/\*'| grep -v '\^\*' | grep -v '\*\=' | grep -v '\$s\@' | grep -v '\$r\@'| awk -F":" '{print $1}' | sed -n '1p'`
			if [[ "$del_rule" != "" ]]; then
				sed -i "${del_rule}d" /jffs/softcenter/koolproxyR/data/rules/easylistchina.txt
			else
				koolproxyR_del_rule=0
			fi
		done	
		cat /jffs/softcenter/koolproxyR/data/rules/kpr_our_rule.txt >> /jffs/softcenter/koolproxyR/data/rules/easylistchina.txt

	else
		echo_date 跳过优化 KPR主规则。。。。。
	fi


	if [[ "$koolproxyR_https_mobile" == "1" ]]; then
		# 删除不必要信息重新打包 0-11行 表示从第15行开始 $表示结束
		# sed -i '1,11d' /jffs/softcenter/koolproxyR/data/rules/yhosts.txt
		echo_date 正在优化 补充规则yhosts。。。。。

		# 开始Kpr规则化处理
		cat /jffs/softcenter/koolproxyR/data/rules/yhosts.txt > /jffs/softcenter/koolproxyR/data/rules/yhosts_https.txt
		sed -i 's/^127.0.0.1\ /||https:\/\//g' /jffs/softcenter/koolproxyR/data/rules/yhosts_https.txt
		cat /jffs/softcenter/koolproxyR/data/rules/yhosts.txt >> /jffs/softcenter/koolproxyR/data/rules/yhosts_https.txt
		sed -i 's/^127.0.0.1\ /||http:\/\//g' /jffs/softcenter/koolproxyR/data/rules/yhosts_https.txt
		# 处理tvbox.txt本身规则。
		sed -i 's/^127.0.0.1\ /||/g' /tmp/tvbox.txt

		# 合二归一
		cat  /jffs/softcenter/koolproxyR/data/rules/yhosts_https.txt > /jffs/softcenter/koolproxyR/data/rules/yhosts.txt
		cat /tmp/tvbox.txt >> /jffs/softcenter/koolproxyR/data/rules/yhosts.txt
		rm -rf /tmp/tvbox.txt

		# 此处对yhosts进行单独处理
		sed -i 's/^@/!/g' /jffs/softcenter/koolproxyR/data/rules/yhosts.txt
		sed -i 's/^#/!/g' /jffs/softcenter/koolproxyR/data/rules/yhosts.txt
		sed -i '/localhost/d' /jffs/softcenter/koolproxyR/data/rules/yhosts.txt
		sed -i '/broadcasthost/d' /jffs/softcenter/koolproxyR/data/rules/yhosts.txt
		sed -i '/broadcasthost/d' /jffs/softcenter/koolproxyR/data/rules/yhosts.txt
		sed -i '/cn.bing.com/d' /jffs/softcenter/koolproxyR/data/rules/yhosts.txt
		# 给三大视频网站放行 由kp.dat负责
		sed -i '/youku.com/d' /jffs/softcenter/koolproxyR/data/rules/yhosts.txt
		sed -i '/iqiyi.com/d' /jffs/softcenter/koolproxyR/data/rules/yhosts.txt
		sed -i '/g.alicdn.com/d' /jffs/softcenter/koolproxyR/data/rules/yhosts.txt
		sed -i '/tudou.com/d' /jffs/softcenter/koolproxyR/data/rules/yhosts.txt
		sed -i '/gtimg.cn/d' /jffs/softcenter/koolproxyR/data/rules/yhosts.txt


		# 给知乎放行
		sed -i '/zhihu.com/d' /jffs/softcenter/koolproxyR/data/rules/yhosts.txt
		# 给https://qq.com的html规则放行
		sed -i '/qq.com/d' /jffs/softcenter/koolproxyR/data/rules/yhosts.txt
		# 给github的https放行
		sed -i '/github/d' /jffs/softcenter/koolproxyR/data/rules/yhosts.txt
		# 给apple的https放行
		sed -i '/apple.com/d' /jffs/softcenter/koolproxyR/data/rules/yhosts.txt
		sed -i '/mzstatic.com/d' /jffs/softcenter/koolproxyR/data/rules/yhosts.txt
		# 给api.twitter.com的https放行
		sed -i '/twitter.com/d' /jffs/softcenter/koolproxyR/data/rules/yhosts.txt
		# 给facebook.com的https放行
		sed -i '/facebook.com/d' /jffs/softcenter/koolproxyR/data/rules/yhosts.txt
		sed -i '/fbcdn.net/d' /jffs/softcenter/koolproxyR/data/rules/yhosts.txt
		# 给 instagram.com 放行
		sed -i '/instagram.com/d' /jffs/softcenter/koolproxyR/data/rules/yhosts.txt
		# 删除可能导致kpr卡死的神奇规则
		sed -i '/https:\/\/\*/d' /jffs/softcenter/koolproxyR/data/rules/yhosts.txt
		# 给国内三大电商平台放行
		sed -i '/jd.com/d' /jffs/softcenter/koolproxyR/data/rules/yhosts.txt
		sed -i '/taobao.com/d' /jffs/softcenter/koolproxyR/data/rules/yhosts.txt
		sed -i '/tmall.com/d' /jffs/softcenter/koolproxyR/data/rules/yhosts.txt
		# 给 netflix.com 放行
		sed -i '/netflix.com/d' /jffs/softcenter/koolproxyR/data/rules/yhosts.txt
		# 给 tvbs.com 放行
		sed -i '/tvbs.com/d' /jffs/softcenter/koolproxyR/data/rules/yhosts.txt
		sed -i '/googletagmanager.com/d' /jffs/softcenter/koolproxyR/data/rules/yhosts.txt
		# 给 microsoft.com 放行
		sed -i '/microsoft.com/d' /jffs/softcenter/koolproxyR/data/rules/yhosts.txt
		# 终极 https 卡顿优化 grep -n 显示行号  awk -F 分割数据  sed -i "${del_rule}d" 需要""" 和{}引用变量
		# 当 koolproxyR_del_rule 是1的时候就一直循环，除非 del_rule 变量为空了。
		koolproxyR_del_rule=1
		while [ $koolproxyR_del_rule = 1 ];do
			del_rule=`cat /jffs/softcenter/koolproxyR/data/rules/yhosts.txt | grep -n 'https://' | grep '\*' | grep -v '/\*'| grep -v '\^\*' | grep -v '\*\=' | grep -v '\$s\@' | grep -v '\$r\@'| awk -F":" '{print $1}' | sed -n '1p'`
			if [[ "$del_rule" != "" ]]; then
				sed -i "${del_rule}d" /jffs/softcenter/koolproxyR/data/rules/yhosts.txt
			else
				koolproxyR_del_rule=0
			fi
		done	


	else
		echo_date 跳过优化 补充规则yhosts。。。。。
	fi
    # 删除临时文件
    rm -rf /tmp/tvbox.txt
    rm -rf /tmp/kp.dat
    rm -rf /tmp/kp.dat.md5
    rm /jffs/softcenter/koolproxyR/data/rules/kpr_our_rule.txt
    rm /jffs/softcenter/koolproxyR/data/rules/*_https.txt
    echo_date ===============================所有规则更新并优化完毕！===============================
    echo_date 自动重启koolproxyR，以应用新的规则文件！请稍后！
    sleep 3
    sh /jffs/softcenter/koolproxyR/kp_config.sh restart
}

update_kp_rules > /tmp/kpr_log.txt
echo_date ================================================= >> /tmp/kpr_log.txt
echo XU6J03M6 >> /tmp/kpr_log.txt
sleep 1
rm -rf /tmp/kpr_log.txt
