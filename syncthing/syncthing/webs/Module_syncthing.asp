<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache" />
<meta HTTP-EQUIV="Expires" CONTENT="-1" />
<link rel="shortcut icon" href="images/favicon.png" />
<link rel="icon" href="images/favicon.png" />
<title>软件中心 - syncthing</title>
<link rel="stylesheet" type="text/css" href="index_style.css" />
<link rel="stylesheet" type="text/css" href="form_style.css" />
<link rel="stylesheet" type="text/css" href="usp_style.css" />
<link rel="stylesheet" type="text/css" href="ParentalControl.css">
<link rel="stylesheet" type="text/css" href="css/icon.css">
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="res/softcenter.css">
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script language="JavaScript" type="text/javascript" src="/client_function.js"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<script>
var db_syncthing = {}

function init() {
	show_menu(menu_hook);
	get_dbus_data();
}
function get_dbus_data() {
	$.ajax({
		type: "GET",
		url: "/dbconf?p=syncthing_",
		dataType: "script",
		async: false,
		success: function(data) {
			db_syncthing = db_syncthing_;
			E("syncthing_enable").checked = db_syncthing["syncthing_enable"] == "1";
			E("syncthing_wan_port").value = db_syncthing["syncthing_wan_port"] || "0";
			E("syncthing_port").value = db_syncthing["syncthing_port"] || "8384";
			get_run_status();
		}
	});
}
function save() {
	showLoading(3);
	refreshpage(3);
	if(E("syncthing_port").value == 80 || E("syncthing_port").value == 8443)
		E("syncthing_port").value = 8384;
	db_syncthing["syncthing_enable"] = E("syncthing_enable").checked ? '1' : '0';
	db_syncthing["syncthing_wan_port"] = E("syncthing_wan_port").value;
	db_syncthing["syncthing_port"] = E("syncthing_port").value;
	db_syncthing["action_script"]="syncthing_config.sh";
	db_syncthing["action_mode"] = "restart";
	$.ajax({
		url: "/applydb.cgi?p=syncthing",
		cache: false,
		type: "POST",
		dataType: "text",
		data: $.param(db_syncthing)
	});
}

function menu_hook(title, tab) {
	tabtitle[tabtitle.length -1] = new Array("", "软件中心", "离线安装", "syncthing");
	tablink[tablink.length -1] = new Array("", "Main_Soft_center.asp", "Main_Soft_setting.asp", "Module_syncthing.asp");
}
function get_run_status(){

	$.ajax({
		type: "POST",
		cache:false,
		url: "/logreaddb.cgi?p=syncthing_status.log&script=syncthing_status.sh",
		//data: JSON.stringify(postData),
		dataType: "html",
		success: function(response){
			//console.log(response)
			E("status").innerHTML = response;
			setTimeout("get_run_status();", 10000);
		},
		error: function(){
			setTimeout("get_run_status();", 5000);
		}
	});
}
function open_syncthing(){
	window.open("http://"+window.location.hostname+":"+E("syncthing_port").value);
}
</script>
</head>
<body onload="init();">
	<div id="TopBanner"></div>
	<div id="Loading" class="popup_bg"></div>
	<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
		<input type="hidden" name="current_page" value="Module_syncthing.asp" />
		<input type="hidden" name="next_page" value="Module_syncthing.asp" />
		<input type="hidden" name="group_id" value="" />
		<input type="hidden" name="modified" value="0" />
		<input type="hidden" name="action_mode" value="" />
		<input type="hidden" name="action_script" value="" />
		<input type="hidden" name="action_wait" value="5" />
		<input type="hidden" name="first_time" value="" />
		<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get(" preferred_lang "); %>"/>
		<input type="hidden" name="firmver" value="<% nvram_get(" firmver "); %>"/>
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
								<table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
									<tr>
										<td bgcolor="#4D595D" colspan="3" valign="top">
											<div>&nbsp;</div>
											<div style="float:left;" class="formfonttitle">数据同步工具 - syncthing</div>
											<div style="float:right; width:15px; height:25px;margin-top:10px">
												<img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img>
											</div>
											<div style="margin:30px 0 10px 5px;" class="splitLine"></div>
											<div class="formfontdesc" id="cmdDesc">该工具用于同步数据。</div>
											<div class="formfontdesc" id="cmdDesc"></div>
											<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="syncthing_table">
												<thead>
													<tr>
														<td colspan="2">syncthing 选项</td>
													</tr>
												</thead>
												<tr>
													<th>开启 syncthing</th>
													<td colspan="2">
														<div class="switch_field" style="display:table-cell;float: left;">
															<label for="syncthing_enable">
																<input id="syncthing_enable" class="switch" type="checkbox" style="display: none;">
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
												<tr id="port_tr">
													<th width="35%">运行端口</th>
													<td>
														<div style="float:left; width:165px; height:25px">
															<input id="syncthing_port" name="syncthing_port" class="input_32_table" value="">
														</div>
													</td>
												</tr>
												<tr id="wan_port_tr">
													<th width="35%">外网开关</th>
													<td>
														<div style="float:left; width:165px; height:25px">
															<select id="syncthing_wan_port" name="syncthing_wan_port" style="width:164px;margin:0px 0px 0px 2px;" class="input_option">
																<option value="0">关闭</option>
																<option value="1">开启</option>
															</select>
														</div>
													</td>
												</tr>
											</table>
																					<!--beginning of syncthing install table-->
											<div id="syncthing_install_table" style="margin:10px 0px 0px 0px;">
												<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
													<thead>
														<tr>
															<td colspan="2">syncthing相关信息</td>
														</tr>
													</thead>
													<tr id="syncthing_status">
														<th style="width:25%;">运行状态</th>
														<td><span id="status">获取中...</span>
														</td>
													</tr>

													<tr id="syncthing_tr">
														<th style="width:25%;">Syncthing控制台</th>
														<td>
															<div style="padding-top:5px;">
																<span><input class="button_gen" id="cmdBtn" onclick="open_syncthing();" type="button" value="控制台"/></span>
															</div>
														</td>
													</tr>
												</table>
											</div>
											<div class="apply_gen">
												<span><input class="button_gen" id="cmdBtn" onclick="save();" type="button" value="提交"/></span>
											</div> 

											<div id="NoteBox">
													<h2>使用说明：</h2>
													<h3>首次安装控制台没有账号密码，为了您的安全请手动设置</h3>
													<h3>同步目录最好在U盘内(/mnt/file/)创建文件夹 比如 /mnt/file/syncthing/dir1</h3>
													<h3>无必要不要打开外网访问</h3>
													<h2>作者@沐心 QQ:285169134 Email:a@ph233.cn</h2>
													<h2>申明：本工具由Git开源项目封装 <a href="https://github.com/syncthing/syncthing" target="_blank">点我跳转</a></h2>
											</div>
										</td>
									</tr>
								</table>
							</td>
							<td width="10" align="center" valign="top"></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</td>
	<div id="footer"></div>
</body>
</html>

