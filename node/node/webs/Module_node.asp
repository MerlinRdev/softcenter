<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title sclang>node</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/>
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="usp_style.css"/>
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="ParentalControl.css">
<link rel="stylesheet" type="text/css" href="css/icon.css">
<link rel="stylesheet" type="text/css" href="/res/softcenter.css">
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/client_function.js"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<script type="text/javascript" src="/js/i18n.js"></script>
<style>
</style>
<script>
var params_check = ["node_enable", "node_jd_enable"];
var jd_check = ["node_jd_auto_run", "node_jd_auto_run", "node_jd_auto_update", "node_jd_failed"];
var jd_input = ["node_jd_cookie", "node_jd_cookie2", "node_jd_stop", "node_jd_auto_run_time", "node_jd_auto_update_time", "node_jd_remote_url", "node_jd_serverurl", "node_jd_serverchan"];
function E(e) {
	return (typeof(e) == 'string') ? document.getElementById(e) : e;
}
function init() {
	show_menu(menu_hook);
	get_dbus_data();
}

function get_dbus_data() {
	$.ajax({
		type: "GET",
		url: "/dbconf?p=node_",
		dataType: "script",
		async: false,
		success: function(data) {
			db_node = db_node_;
			conf2obj();
			buildswitch();
			check_status();
		}
	});
}

function conf2obj() {
	// check for 0 and 1
	for (var i = 0; i < params_check.length; i++) {
		if(db_node_[params_check[i]]){
			E(params_check[i]).checked = db_node_[params_check[i]] == 1 ? true : false
		}
	}
	//input
	for (var i = 0; i < jd_input.length; i++) {
		if(db_node_[jd_input[i]]){
			E(jd_input[i]).value = db_node_[jd_input[i]];
		}
	}
	// check for true and false
	for (var i = 0; i < jd_check.length; i++) {
		if(db_node_[jd_check[i]]){
			E(jd_check[i]).checked = db_node_[jd_check[i]] == "true" ? true : false
		}
	}
}

function buildswitch() {
	$("#node_jd_enable").click(
		function() {
			if (E('node_jd_enable').checked) {
				E('node_jd_table').style.display = "";
			}else{
				E('node_jd_table').style.display = "none";
			}
	});
}
function save() {
	showLoading(3);
	refreshpage(3);
	// check for 0 and 1
	for (var i = 0; i < params_check.length; i++) {
		db_node[params_check[i]] = E(params_check[i]).checked ? '1' : '0';
	}
	//input
	for (var i = 0; i < jd_input.length; i++) {
		if (E(jd_input[i]).value) {
			db_node[jd_input[i]] = E(jd_input[i]).value;
		}
	}
	// check for true and false
	for (var i = 0; i < jd_check.length; i++) {
		db_node[jd_check[i]] = E(jd_check[i]).checked ? 'true' : 'false';
	}
	db_node["action_script"]="node_config.sh";
	db_node["action_mode"] = "restart";
	$.ajax({
		url: "/applydb.cgi?p=node",
		cache: false,
		type: "POST",
		dataType: "text",
		data: $.param(db_node)
	});
}
function check_status(){

	$.ajax({
		url: '/logreaddb.cgi?p=node_status.log&script=node_status.sh',
		dataType: 'html',
		success: function (response) {
			//console.log(response)
			E("node_status").innerHTML = response;
			setTimeout("check_status();", 5000);
		},
		error: function(){
			setTimeout("check_status();", 5000);
		}
	});
}

function menu_hook(title, tab) {
	tabtitle[tabtitle.length -1] = new Array("", "软件中心", "离线下载", "node");
	tablink[tablink.length -1] = new Array("", "Main_Soft_center.asp", "Main_Soft_setting.asp", "Module_node.asp");
}
</script>
</head>
<body onload="init();">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
<input type="hidden" name="current_page" value="Module_node.asp"/>
<input type="hidden" name="next_page" value="Module_node.asp"/>
<input type="hidden" name="group_id" value=""/>
<input type="hidden" name="modified" value="0"/>
<input type="hidden" name="action_mode" value="restart"/>
<input type="hidden" name="action_script" value="node_config.sh"/>
<input type="hidden" name="action_wait" value="5"/>
<input type="hidden" name="first_time" value=""/>
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>"/>
<table class="content" align="center" cellpadding="0" cellspacing="0">
    <tr>
        <td width="17">&nbsp;</td>
        <td valign="top" width="202">
            <div id="mainMenu"></div>
            <div id="subMenu"></div>
        </td>
        <td valign="top">
            <div id="tabMenu" class="submenuBlock"></div>
            <table width="98%" border="0" align="left" cellpadding="0" cellspacing="0" style="display: block;">
				<tr>
					<td align="left" valign="top">
						<div>
							<table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
								<tr>
									<td bgcolor="#4D595D" colspan="3" valign="top">
										<div>&nbsp;</div>
                						<div id="node_title" style="float:left;" class="formfonttitle" style="padding-top: 12px">node</div>
										<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
										<div style="margin:30px 0 10px 5px;" class="splitLine"></div>
										<div id="node_switch" style="margin:0px 0px 0px 0px;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<thead>
												<tr>
													<td colspan="2">全局设置</td>
												</tr>
												</thead>
												<tr>
													<th>启用node</th>
													<td colspan="2">
														<div class="switch_field" style="display:table-cell;float: left;">
															<label for="node_enable">
																<input id="node_enable" class="switch" type="checkbox" style="display: none;">
																<div class="switch_container">
																	<div class="switch_bar"></div>
																	<div class="switch_circle transition_style">
																		<div></div>
																	</div>
																</div>
															</label>
														</div>
													</td>
												</tr>
												<tr>
													<th>运行状态</th>
													<td colspan="2"  id="node_status">
													</td>
												</tr>
												<tr>
													<th>启用京东签到</th>
													<td>
														<div class="switch_field" style="display:table-cell;float: left;">
															<label for="node_jd_enable">
																<input id="node_jd_enable" class="switch" type="checkbox" style="display: none;">
																<div class="switch_container">
																	<div class="switch_bar"></div>
																	<div class="switch_circle transition_style">
																		<div></div>
																	</div>
																</div>
															</label>
														</div>
													</td>
												</tr>
											</table>
										</div>
										<div id="node_jd_table" style="margin:10px 0px 0px 0px; display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<thead>
												<tr>
													<td colspan="2">京东签到</td>
												</tr>
												</thead>
												<tr>
													<th>说明</th>
													<td colspan="2"  id="node_jd_note">
													<div><input type="button" class="button_gen" value="安装chrmoe Cookie插件" onclick="javascript:window.open('/_temp/JDCookie.crx','target');" /><input type="button" class="button_gen" value="下载JDCookie.zip" onclick="javascript:window.open('https://raw.githubusercontent.com/jerrykuku/luci-app-jd-dailybonus/master/root/www/jd-dailybonus/JDCookie.zip','target');" /></br>点击上面的安装Cookie工具，然后点击下面的<i>京东链接</i>。如果浏览器禁止安装crx扩展，请下载第二个 JDCookie.zip，解压后在[<i>chrome://extensions/</i>]中使用加载已解压的扩展程序进行安装。<i>仅支持chrome浏览器。</i></br><input type="button" class="button_gen" value="bean.m.jd.com" onclick="javascript:window.open('https://bean.m.jd.com','target');" /></br>登录后点击JDCookie 扩展工具复制cookie，然后粘贴到下面输入框中。</div>


													</td>
												</tr>
												<tr>
													<th>主帐号cookie</th>
													<td style="width:25%;">
													<input type="text" class="input_ss_table" style="width:auto;" name="node_jd_cookie" value="" maxlength="300" size="50" id="node_jd_cookie" />
													</td>
												</tr>
												<tr>
													<th>第二账号cookie</th>
													<td style="width:25%;">
													<input type="text" class="input_ss_table" style="width:auto;" name="node_jd_cookie2" value="" maxlength="300" size="50" id="node_jd_cookie2" />
													</td>
												</tr>
												<tr>
													<th>启用自动签到</th>
													<td>
														<div class="switch_field" style="display:table-cell;float: left;">
															<label for="node_jd_auto_run">
																<input id="node_jd_auto_run" class="switch" type="checkbox" style="display: none;">
																<div class="switch_container">
																	<div class="switch_bar"></div>
																	<div class="switch_circle transition_style">
																		<div></div>
																	</div>
																</div>
															</label>
														</div>
													</td>
												</tr>
												<tr>
													<th>延迟签到(单位毫秒)</th>
													<td style="width:25%;">
													<input type="text" class="input_ss_table" style="width:auto;" name="node_jd_stop" value="" maxlength="100" size="50" id="node_jd_stop" />
													</td>
												</tr>
												<tr>
													<th>自动签到时间段</th>
													<td>
														<select class="input_ss_table" style="width:100px;height:25px;" name="node_jd_auto_run_time" id="node_jd_auto_run_time">
															<option value="0" selected="">0:00</option>
															<option value="1">1:00</option>
															<option value="2">2:00</option>
															<option value="3">3:00</option>
															<option value="4">4:00</option>
															<option value="5">5:00</option>
															<option value="6">6:00</option>
															<option value="7">7:00</option>
															<option value="8">8:00</option>
															<option value="9">9:00</option>
															<option value="10">10:00</option>
															<option value="11">11:00</option>
															<option value="12">12:00</option>
															<option value="13">13:00</option>
															<option value="14">14:00</option>
															<option value="15">15:00</option>
															<option value="16">16:00</option>
															<option value="17">17:00</option>
															<option value="18">18:00</option>
															<option value="19">19:00</option>
															<option value="20">20:00</option>
															<option value="21">21:00</option>
															<option value="22">22:00</option>
															<option value="23">23:00</option>
														</select>
													</td>
												</tr>
												<tr>
													<th>启用自动更新</th>
													<td>
														<div class="switch_field" style="display:table-cell;float: left;">
															<label for="node_jd_auto_update">
																<input id="node_jd_auto_update" class="switch" type="checkbox" style="display: none;">
																<div class="switch_container">
																	<div class="switch_bar"></div>
																	<div class="switch_circle transition_style">
																		<div></div>
																	</div>
																</div>
															</label>
														</div>
													</td>
												</tr>
												<tr>
													<th>自动更新源</th>
													<td>
														<select class="input_ss_table" style="width:100px;height:25px;" name="node_jd_serverurl" id="node_jd_serverurl">
															<option value="https://cdn.jsdelivr.net/gh/NobyDa/Script/JD-DailyBonus/JD_DailyBonus.js" selected="">github</option>
															<option value="https://gitee.com/jerrykuku/staff/raw/master/JD_DailyBonus.js">gitee</option>
														</select>
													</td>
												</tr>
												<tr>
													<th>自动更新时间段</th>
													<td>
														<select class="input_ss_table" style="width:100px;height:25px;" name="node_jd_auto_update_time" id="node_jd_auto_update_time">
															<option value="0" selected="">0:00</option>
															<option value="1">1:00</option>
															<option value="2">2:00</option>
															<option value="3">3:00</option>
															<option value="4">4:00</option>
															<option value="5">5:00</option>
															<option value="6">6:00</option>
															<option value="7">7:00</option>
															<option value="8">8:00</option>
															<option value="9">9:00</option>
															<option value="10">10:00</option>
															<option value="11">11:00</option>
															<option value="12">12:00</option>
															<option value="13">13:00</option>
															<option value="14">14:00</option>
															<option value="15">15:00</option>
															<option value="16">16:00</option>
															<option value="17">17:00</option>
															<option value="18">18:00</option>
															<option value="19">19:00</option>
															<option value="20">20:00</option>
															<option value="21">21:00</option>
															<option value="22">22:00</option>
															<option value="23">23:00</option>
														</select>
													</td>
												</tr>
												<tr>
													<th>启用Server酱</th>
													<td>
														<div class="switch_field" style="display:table-cell;float: left;">
															<label for="node_jd_serverchan_enable">
																<input id="node_jd_serverchan_enable" class="switch" type="checkbox" style="display: none;">
																<div class="switch_container">
																	<div class="switch_bar"></div>
																	<div class="switch_circle transition_style">
																		<div></div>
																	</div>
																</div>
															</label>
														</div>
													</td>
												</tr>
												<tr>
													<th>Server酱推送接口</th>
													<td>
														<select class="input_ss_table" style="width:100px;height:25px;" name="node_jd_serverurl" id="node_jd_serverurl">
															<option value="scu" selected="">scu</option>
															<option value="sct">sct</option>
														</select>
													</td>
												</tr>
												<tr>
													<th>ServerChan SCKEY</th>
													<td style="width:25%;">
													<input type="text" class="input_ss_table" style="width:auto;" name="node_jd_serverchan" value="" maxlength="100" size="50" id="node_jd_serverchan" />
													</td>
												</tr>
												<tr>
													<th>仅当cookie失效时推送</th>
													<td>
														<div class="switch_field" style="display:table-cell;float: left;">
															<label for="node_jd_failed">
																<input id="node_jd_failed" class="switch" type="checkbox" style="display: none;">
																<div class="switch_container">
																	<div class="switch_bar"></div>
																	<div class="switch_circle transition_style">
																		<div></div>
																	</div>
																</div>
															</label>
														</div>
													</td>
												</tr>
											</table>
										</div>
										<div class="apply_gen">
											<input id="cmdBtn" type="button" class="button_gen" onclick="save()" value="应用"/>
										</div>
										<div class="KoolshareBottom" style="float:right; width:180px; height:70px">
											Shell&Web by： <i>paldier</i>
										</div>
									</td>
								</tr>
							</table>
						</div>
					</td>
				</tr>
			</table>
        </td>
    </tr>
</table>
<div id="footer"></div>
</body>
</html>

