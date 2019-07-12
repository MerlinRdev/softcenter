<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - ServerChan(微信通知)</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/> 
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="css/element.css">
<style>
.Bar_container {
    width:85%;
    height:20px;
    border:1px inset #999;
    margin:0 auto;
    margin-top:20px \9;
    background-color:#FFFFFF;
    z-index:100;
}
#proceeding_img_text {
    position:absolute;
    z-index:101;
    font-size:11px;
    color:#000000;
    line-height:21px;
    width: 83%;
}
#proceeding_img {
    height:21px;
    background:#C0D1D3 url(/images/ss_proceding.gif);
}
#ClientList_Block_PC{
    border:1px outset #999;
    background-color:#576D73;
    position:absolute;
    *margin-top:26px;
    margin-left:2px;
    *margin-left:-353px;
    width:346px;
    text-align:left;
    height:auto;
    overflow-y:auto;
    z-index:200;
    padding: 1px;
    display:none;
}
#ClientList_Block_PC div{
    background-color:#576D73;
    height:auto;
    *height:20px;
    line-height:20px;
    text-decoration:none;
    font-family: Lucida Console;
    padding-left:2px;
}

#ClientList_Block_PC a{
    background-color:#EFEFEF;
    color:#FFF;
    font-size:12px;
    font-family:Arial, Helvetica, sans-serif;
    text-decoration:none;
}
#ClientList_Block_PC div:hover, #ClientList_Block a:hover {
    background-color:#3366FF;
    color:#FFFFFF;
    cursor:default;
}
.close {
    background: red;
    color: black;
    border-radius: 12px;
    line-height: 18px;
    text-align: center;
    height: 18px;
    width: 18px;
    font-size: 16px;
    padding: 1px;
    top: -10px;
    right: -10px;
    position: absolute;
}
/* use cross as close button */
.close::before {
    content: "\2716";
}
.contentM_qis {
    position: fixed;
    -webkit-border-radius: 5px;
    -moz-border-radius: 5px;
    border-radius:10px;
    z-index: 10;
    background-color:#2B373B;
    margin-left: -100px;
    top: 10px;
    width:720px;
    return height:auto;
    box-shadow: 3px 3px 10px #000;
    background: rgba(0,0,0,0.85);
    display:none;
}
.user_title{
    text-align:center;
    font-size:18px;
    color:#99FF00;
    padding:10px;
    font-weight:bold;
}
.serverchan_btn {
    border: 1px solid #222;
    background: linear-gradient(to bottom, #003333  0%, #000000 100%); /* W3C */
    font-size:10pt;
    color: #fff;
    padding: 5px 5px;
    border-radius: 5px 5px 5px 5px;
    width:16%;
}
.serverchan_btn:hover {
    border: 1px solid #222;
    background: linear-gradient(to bottom, #27c9c9  0%, #279fd9 100%); /* W3C */
    font-size:10pt;
    color: #fff;
    padding: 5px 5px;
    border-radius: 5px 5px 5px 5px;
    width:16%;
}
input[type=button]:focus {
    outline: none;
}
</style>
<link rel="stylesheet" type="text/css" href="usp_style.css"/>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/calendar/jquery-ui.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/dbconf?p=serverchan&v=<% uptime(); %>"></script>
<script>
var $j = jQuery.noConflict();
var $G = function(id) {
    return document.getElementById(id);
};
var Base64;
if(typeof btoa == "Function") {
   Base64 = {encode:function(e){ return btoa(e); }, decode:function(e){ return atob(e);}};
} else {
   Base64 ={_keyStr:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",encode:function(e){var t="";var n,r,i,s,o,u,a;var f=0;e=Base64._utf8_encode(e);while(f<e.length){n=e.charCodeAt(f++);r=e.charCodeAt(f++);i=e.charCodeAt(f++);s=n>>2;o=(n&3)<<4|r>>4;u=(r&15)<<2|i>>6;a=i&63;if(isNaN(r)){u=a=64}else if(isNaN(i)){a=64}t=t+this._keyStr.charAt(s)+this._keyStr.charAt(o)+this._keyStr.charAt(u)+this._keyStr.charAt(a)}return t},decode:function(e){var t="";var n,r,i;var s,o,u,a;var f=0;e=e.replace(/[^A-Za-z0-9\+\/\=]/g,"");while(f<e.length){s=this._keyStr.indexOf(e.charAt(f++));o=this._keyStr.indexOf(e.charAt(f++));u=this._keyStr.indexOf(e.charAt(f++));a=this._keyStr.indexOf(e.charAt(f++));n=s<<2|o>>4;r=(o&15)<<4|u>>2;i=(u&3)<<6|a;t=t+String.fromCharCode(n);if(u!=64){t=t+String.fromCharCode(r)}if(a!=64){t=t+String.fromCharCode(i)}}t=Base64._utf8_decode(t);return t},_utf8_encode:function(e){e=e.replace(/\r\n/g,"\n");var t="";for(var n=0;n<e.length;n++){var r=e.charCodeAt(n);if(r<128){t+=String.fromCharCode(r)}else if(r>127&&r<2048){t+=String.fromCharCode(r>>6|192);t+=String.fromCharCode(r&63|128)}else{t+=String.fromCharCode(r>>12|224);t+=String.fromCharCode(r>>6&63|128);t+=String.fromCharCode(r&63|128)}}return t},_utf8_decode:function(e){var t="";var n=0;var r=c1=c2=0;while(n<e.length){r=e.charCodeAt(n);if(r<128){t+=String.fromCharCode(r);n++}else if(r>191&&r<224){c2=e.charCodeAt(n+1);t+=String.fromCharCode((r&31)<<6|c2&63);n+=2}else{c2=e.charCodeAt(n+1);c3=e.charCodeAt(n+2);t+=String.fromCharCode((r&15)<<12|(c2&63)<<6|c3&63);n+=3}}return t}}
}
function initial(){
    show_menu(menu_hook);
    conf2obj();
    version_show();
    buildswitch();
    toggle_switch();
}

function toggle_switch(){ //根据serverchan_enable的值，打开或者关闭开关
    var rrt = document.getElementById("switch");
    if (document.form.serverchan_enable.value != "1") {
        rrt.checked = false;
    } else {
        rrt.checked = true;
    }
}

function buildswitch(){ //生成开关的功能，checked为开启，此时传递serverchan_enable=1
    $j("#switch").click(
    function(){
        if(document.getElementById('switch').checked){
            document.form.serverchan_enable.value = 1;
            
        }else{
            document.form.serverchan_enable.value = 0;
        }
    });
}
function qj2bj(str){
    var tmp = "";
    for(var i=0;i<str.length;i++){
        if(str.charCodeAt(i) >= 65281 && str.charCodeAt(i) <= 65374){
            tmp += String.fromCharCode(str.charCodeAt(i)-65248)
        }else if(str.charCodeAt(i) == 12288){
            tmp += ' ';
        }else{
            tmp += str[i];
        }
    }
    return tmp;
}
function conf2obj(){ //表单填写函数，将dbus数据填入到对应的表单中
    for(var field in db_serverchan) {
        var el = document.getElementById(field);
        if (el != null) {
            if (field == "serverchan_config_name") {
                el.value = Base64.decode(db_serverchan[field]);
            } else if(field == "serverchan_trigger_dhcp_white") {
                el.value = Base64.decode(db_serverchan[field]);
            } else if(field == "serverchan_check_custom") {
                el.value = Base64.decode(db_serverchan[field]);
            } else if(field == "serverchan_sckey") {
                el.value = Base64.decode(db_serverchan[field]);
            } else {
                if (el.getAttribute("type") == "checkbox") {
                    if (db_serverchan[field] == "1") {
                        el.checked = true;
                        $G("f_" + field).value = "1";
                    } else {
                        el.checked = false;
                        $G("f_" + field).value = "0";
                    }
                }
                el.value = db_serverchan[field];
            }
        }
    }
}

function pass_checked(obj){
    switchType(obj, document.form.show_pass.checked, true);
}
function onSubmitCtrl() { //提交操作，提交时运行serverchan_config，显示5秒的载入画面
    document.form.action_mode.value = ' Refresh ';
    document.form.action_script.value = "serverchan_config.sh";
    if (validForm()) {
        document.form.submit();
    }
    showLoading(5);
    refreshpage(2);
}
function manual_push() {
    $G('manual_push_Btn').disabled = "disabled";
    checkTime = 2001; //停止可能在进行的刷新
    document.form.action_script.value = "serverchan_config.sh";
    document.form.action_mode.value = ' Refresh ';
    alert("手动推送成功，请检查手机信息！");
    if (validForm()) {
        document.form.submit();
    }
    checkTime = 0;
    showLoading(2);
    refreshpage(2);
}
function validForm() {
    var temp_serverchan = ["serverchan_sckey"];
    var temp_str = qj2bj($G(temp_serverchan).value);
    $G(temp_serverchan).value = Base64.encode(temp_str);
    return true;
}
function reload_Soft_Center(){ //返回软件中心按钮
    location.href = "/Main_Soft_center.asp";
}
function menu_hook(title, tab) {
	tabtitle[tabtitle.length -1] = new Array("", "软件中心", "离线安装", "ServerChan微信通知");
	tablink[tablink.length -1] = new Array("", "Main_Soft_center.asp", "Main_Soft_setting.asp", "Module_serverchan.asp");
}

function oncheckclick(obj) {
    if (obj.checked) {
        document.form["f_" + obj.id].value = "1";
        if(obj.id=="serverchan_dhcp_white_en"){
            document.getElementById("serverchan_dhcp_black_en").checked = false;
            document.form["f_serverchan_dhcp_white_en"].value = "1";
            document.form["f_serverchan_dhcp_black_en"].value = "0";
        }
        if(obj.id=="serverchan_dhcp_black_en"){
            document.getElementById("serverchan_dhcp_white_en").checked = false;
            document.form["f_serverchan_dhcp_white_en"].value = "0";
            document.form["f_serverchan_dhcp_black_en"].value = "1";
        }
    } else {
        document.form["f_" + obj.id].value = "0";
        if(obj.id=="serverchan_dhcp_white_en"){
            document.getElementById("serverchan_dhcp_black_en").checked = true;
            document.form["f_serverchan_dhcp_white_en"].value = "0";
            document.form["f_serverchan_dhcp_black_en"].value = "1";
        }
        if(obj.id=="serverchan_dhcp_black_en"){
            document.getElementById("serverchan_dhcp_white_en").checked = true;
            document.form["f_serverchan_dhcp_white_en"].value = "1";
            document.form["f_serverchan_dhcp_black_en"].value = "0";
        }
    }
}
function version_show(){
    $j.ajax({
        url: 'http://sc.paldier.com/serverchan/config.json.js',
        type: 'GET',
        dataType: 'jsonp',
        success: function(res) {
            if(typeof(res["version"]) != "undefined" && res["version"].length > 0) {
                if(res["version"] == db_serverchan["serverchan_version"]){
                    $j("#serverchan_version_show").html("<i>插件版本：" + res["version"]);
                   }else if(res["version"] > db_serverchan["serverchan_version"]) {
                    $j("#serverchan_version_show").html("<font color=\"#66FF66\">有新版本：</font>" + res.version);
                }
            }
        }
    });
}
function done_validating() {
	return true;
}
</script>
</head>
<body onload="initial();">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
<form method="POST" name="form" action="/applydb.cgi?p=serverchan" target="hidden_frame"> 
<input type="hidden" name="current_page" value="Module_serverchan.asp"/>
<input type="hidden" name="next_page" value="Main_serverchan.asp"/>
<input type="hidden" name="group_id" value=""/>
<input type="hidden" name="modified" value="0"/>
<input type="hidden" name="action_mode" value=""/>
<input type="hidden" name="action_script" value=""/>
<input type="hidden" name="action_wait" value="5"/>
<input type="hidden" name="first_time" value=""/>
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>"/>
<input type="hidden" id="serverchan_enable" name="serverchan_enable" value='<% dbus_get_def("serverchan_enable", "0"); %>'/>

<table class="content" align="center" cellpadding="0" cellspacing="0">
    <tr>
        <td width="17">&nbsp;</td>
        <td valign="top" width="202">
            <div id="mainMenu"></div>
            <div id="subMenu"></div>
        </td>
        <td valign="top">
            <div id="tabMenu" class="submenuBlock"></div>
            <table width="98%" border="0" align="left" cellpadding="0" cellspacing="0">
                <tr>
                    <td align="left" valign="top">
                        <table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3"  class="FormTitle" id="FormTitle">
                            <tr>
                                <td bgcolor="#4D595D" colspan="3" valign="top">
                                    <div>&nbsp;</div>
                                    <div style="float:left;" class="formfonttitle">软件中心 - ServerChan</div>
                                    <div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
                                    <div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"/></div>

                                    <div class="formfontdesc" id="cmdDesc">
                                        * 「<a href="http://sc.ftqq.com" target=_blank><i>Server酱</i></a>」，英文名「ServerChan」，是一款「程序员」和「服务器」之间的通信软件。说人话？就是从服务器推报警和日志到手机的工具。<br><br>
                                        开通并使用上它，只需要一分钟：<br>
                                        <i>1. 登录：</i>用GitHub账号<a href="http://sc.ftqq.com/?c=github&a=login" target="_blank"><i>登入网站</i></a>，就能获得一个<a href="http://sc.ftqq.com/?c=code" target="_blank"><i>SCKEY</i></a>（在「<a href="http://sc.ftqq.com/?c=code" target="_blank"><i>发送消息</i></a>」页面）<br>
                                        <i>2. 绑定：</i>点击「<a href="http://sc.ftqq.com/?c=wechat&a=bind" target="_blank"><i>微信推送</i></a>」，扫码关注同时即可完成绑定<br>
                                        <i>3. 发消息：</i>将获得到的<a href="http://sc.ftqq.com/?c=code" target="_blank"><i>SCKEY</i></a>填入插件中并勾选相应选项提交即可。<br>
                                    </div>
                                    <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
                                        <tr id="switch_tr">
                                            <th>
                                                <label>开启ServerChan</label>
                                            </th>
                                            <td colspan="2">
                                                <div class="switch_field" style="display:table-cell;float: left;">
                                                    <label for="switch">
                                                        <input id="switch" class="switch" type="checkbox" style="display: none;">
                                                        <div class="switch_container" >
                                                            <div class="switch_bar"></div>
                                                            <div class="switch_circle transition_style">
                                                                <div></div>
                                                            </div>
                                                        </div>
                                                    </label>
                                                </div>
                                                <span style="margin-left:100px;"><input class="serverchan_btn" id="manual_push_Btn" onclick="manual_push();" type="button" value="手动推送"/></span>
                                            </td>
                                        </tr>
                                        <th style="width:20%;">版本信息</th>
                                        <td>
                                            <div id="serverchan_version_show" style="padding-top:5px;margin-left:0px;margin-top:0px;float: left;"><i>插件版本：<% dbus_get_def("serverchan_version", "未知"); %></i></div>
                                            <span style="padding-top:5px;margin-right: 15px;margin-left:0px;margin-top:0px;float: right;"><a href="http://koolshare.cn/thread-123937-1-1.html" target="_blank">[ 反馈地址 ]</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://raw.githubusercontent.com/paldier/softcenter/master/serverchan/Changelog.txt" target="_blank"><em><u>[ 更新日志 ]</u></em></a></span>
                                        </td>
                                        <tr>
                                            <th>SCKEY(最少需要一个接收人)</th>
                                            <td>
                                                <input type="input" name="serverchan_sckey" id="serverchan_sckey" class="input_ss_table" autocomplete="new-password" autocorrect="off" autocapitalize="off" maxlength="256" value="" style="width:430px;margin-top: 3px;" />
                                           </td>
                                        </tr>
                                        <tr>
                                            <th width="20%">消息免打扰时间</th>
                                            <td>
                                                <label><input type="checkbox" id="serverchan_silent_time" checked="checked" onclick="oncheckclick(this);"> 消息免打扰 
                                                <input type="hidden" id="f_serverchan_silent_time" name="serverchan_silent_time" value="1" /></label>
                                                <select id="serverchan_silent_time_start_hour" name="serverchan_silent_time_start_hour" style="margin:0px 0px 0px 2px;" class="input_option" >
                                                        <option value="17">17时</option>
                                                        <option value="18">18时</option>
                                                        <option value="19">19时</option>
                                                        <option value="20">20时</option>
                                                        <option value="21">21时</option>
                                                        <option value="22" selected="selected">22时</option>
                                                        <option value="23">23时</option>
                                                </select> 到 
                                                <select id="serverchan_silent_time_end_hour" name="serverchan_silent_time_end_hour" style="margin:0px 0px 0px 2px;" class="input_option" >
                                                        <option value="1">1时</option>
                                                        <option value="2">2时</option>
                                                        <option value="3">3时</option>
                                                        <option value="4">4时</option>
                                                        <option value="5">5时</option>
                                                        <option value="6">6时</option>
                                                        <option value="7">7时</option>
                                                        <option value="8" selected="selected">8时</option>
                                                        <option value="9">9时</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th width="20%">外网IP变化</th>
                                            <td>
                                                 <input type="checkbox" id="serverchan_notify_ip" checked="checked" onclick="oncheckclick(this);">
                                                 <input type="hidden" id="f_serverchan_notify_ip" name="serverchan_notify_ip" value="1" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <th width="20%">新设备加入</th>
                                            <td>
                                                 <input type="checkbox" id="serverchan_notify_new" checked="checked" onclick="oncheckclick(this);">
                                                 <input type="hidden" id="f_serverchan_notify_new" name="serverchan_notify_new" value="1" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <th width="20%">设备上下线</th>
                                            <td>
                                                 <input type="checkbox" id="serverchan_notify_up" checked="checked" onclick="oncheckclick(this);">
                                                 <input type="hidden" id="f_serverchan_notify_up" name="serverchan_notify_up" value="1" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <th width="20%">温度预警</th>
                                            <td>
                                                 <input type="checkbox" id="serverchan_notify_temp" checked="checked" onclick="oncheckclick(this);">
                                                 <input type="hidden" id="f_serverchan_notify_temp" name="serverchan_notify_temp" value="1" />预警温度
                                                 <select id="serverchan_temp" name="serverchan_temp" style="margin:0px 0px 0px 2px;" class="input_option" >
                                                         <option value="100">100℃</option>
                                                         <option value="95">95℃</option>
                                                         <option value="90">90℃</option>
                                                         <option value="85">85℃</option>
                                                         <option value="80">80℃</option>
                                                         <option value="75">75℃</option>
                                                         <option value="70">70℃</option>
                                                         <option value="65">65℃</option>
                                                         <option value="60">60℃</option>
                                                 </select>
                                            </td>
                                        </tr>
                                    </table>
                                    <div class="apply_gen">
                                        <input class="button_gen" onclick="onSubmitCtrl()" type="button" value="应用设置"/>
                                    </div>
                                </td>
                            </tr>
                        </table>

                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <!--===================================Ending of Main Content===========================================-->
        </td>
        <td width="10" align="center" valign="top"></td>
    </tr>
</table>
</form>

<div id="footer"></div>
</body>
</html>
