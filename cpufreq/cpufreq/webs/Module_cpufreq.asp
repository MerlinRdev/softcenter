<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>CPU频率设置</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/>
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="usp_style.css"/>
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="ParentalControl.css">
<link rel="stylesheet" type="text/css" href="css/icon.css">
<link rel="stylesheet" type="text/css" href="/device-map/device-map.css">
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/dbconf?p=cpufreq&v=<% uptime(); %>"></script>
<script type="text/javascript" src="/client_function.js"></script>
<style>
	.show-btn1, .show-btn2, .show-btn3 {
		border: 1px solid #222;
		background: linear-gradient(to bottom, #919fa4  0%, #67767d 100%); /* W3C */
		/*background: linear-gradient(to bottom, #91071f  0%, #700618 100%);*/ /* W3C */
		font-size:10pt;
		color: #fff;
		padding: 10px 3.75px;
		border-radius: 5px 5px 0px 0px;
		width:8.45601%;
		/*border: 1px solid #91071f;*/
		/*background: none;*/
	}
	.active {
		background: #2f3a3e;
		background: linear-gradient(to bottom, #61b5de  0%, #279fd9 100%); /* W3C */
		/*background: linear-gradient(to bottom, #cf0a2c  0%, #91071f 100%);*/ /* W3C */
		/*border: 1px solid #91071f;*/
	}
	.popup_bar_bg_ks{
		position:fixed;	
		margin: auto;
		top: 0;
		left: 0;
		width:100%;
		height:100%;
		z-index:99;
		filter:alpha(opacity=90);  /*IE5、IE5.5、IE6、IE7*/
		background-repeat: repeat;
		visibility:hidden;
		overflow:hidden;
		background-color: #444F53;*/
		background:rgba(68, 79, 83, 0.9) none repeat scroll 0 0 !important;
		/*background: url(/images/New_ui/login_bg.png);
		background-position: 0 0;
		background-size: cover;
		opacity: .94;*/
	}
	.ss_btn {
		border: 1px solid #222;
		background: linear-gradient(to bottom, #003333  0%, #000000 100%); /* W3C */
		/*background: linear-gradient(to bottom, #91071f  0%, #700618 100%);*/ /* W3C */
		font-size:10pt;
		color: #fff;
		padding: 5px 5px;
		border-radius: 5px 5px 5px 5px;
		width:14%;
	}
	.ss_btn:hover {
		border: 1px solid #222;
		background: linear-gradient(to bottom, #27c9c9  0%, #279fd9 100%); /* W3C */
		/*background: linear-gradient(to bottom, #cf0a2c  0%, #91071f 100%);*/ /* W3C */
		font-size:10pt;
		color: #fff;
		padding: 5px 5px;
		border-radius: 5px 5px 5px 5px;
		width:14%;
	}
	textarea{
		width:99%;
		font-family:'Lucida Console';
		font-size:12px;
		color:#FFFFFF;
		background:#475A5F;
		/*background:transparent;*/
		/*border:1px solid #91071f;*/
	}
	input[type=button]:focus {
		outline: none;
	}
</style>
<script>
var cpumax;
var _responseLen;
function E(e) {
	return (typeof(e) == 'string') ? document.getElementById(e) : e;
}
function init() {
	show_menu(menu_hook);
	check_status();
	get_log();
	buildswitch();
	var rrt = document.getElementById("switch");
				if (document.form.cpufreq_enable.value != "1") {
					rrt.checked = false;
				} else {
					rrt.checked = true;
				}
	$('#switch_tr').after(verifyFields());
	document.form.cpufreq_set.value=<% dbus_get_def("cpufreq_set", "0"); %>;
}
function buildswitch(){
	$("#switch").click(
	function(){
		if(document.getElementById('switch').checked){
			document.form.cpufreq_enable.value = 1;
		}else{
			document.form.cpufreq_enable.value = 0;
		}
	});
}
function verifyFields() {
	check_status();
	cpumax=<% dbus_get_def("cpufreq_max", "0"); %>;
	var code = '';
		code = code + '<tr id="cpufreq_tr">';
		code = code + '<th>可用频率</th>';
		code = code + '<td id="cpufreq_set_tr">';
		code = code + '<select id="cpufreq_set" name="cpufreq_set" class="input_option">';
	if ( cpumax == 1200 ) {
		code = code + '<option value="1200" <% dbus_match( "cpufreq_set", "1200","selected"); %>>1200MHz</option>';
		code = code + '<option value="800" <% dbus_match( "cpufreq_set", "800","selected"); %>>800MHz</option>';
		code = code + '<option value="600" <% dbus_match( "cpufreq_set", "600","selected"); %>>600MHz</option>';
		code = code + '<option value="150" <% dbus_match( "cpufreq_set", "150","selected"); %>>150MHz</option>';
	} else if ( cpumax == 1000 ) {
		code = code + '<option value="1000" <% dbus_match( "cpufreq_set", "1000","selected"); %>>1000MHz</option>';
		code = code + '<option value="667" <% dbus_match( "cpufreq_set", "667","selected"); %>>667MHz</option>';
		code = code + '<option value="333" <% dbus_match( "cpufreq_set", "333","selected"); %>>333MHz</option>';
		code = code + '<option value="167" <% dbus_match( "cpufreq_set", "167","selected"); %>>167MHz</option>';
	} else if ( cpumax == 800 ) {
		code = code + '<option value="800" <% dbus_match( "cpufreq_set", "800","selected"); %>>800MHz</option>';
		code = code + '<option value="600" <% dbus_match( "cpufreq_set", "600","selected"); %>>600MHz</option>';
		code = code + '<option value="150" <% dbus_match( "cpufreq_set", "150","selected"); %>>150MHz</option>';
	}
	code = code + '</select>';
	code = code + '</td>';
	code = code + '</tr>';
	return code;
}
function save() {
	if ( cpumax == 1200 )
	// 提交数据
	document.form.action_mode.value = 'toolscript';
	document.form.action_script.value = "cpufreq_config.sh";
	showLoading(1);
	refreshpage(5);
	document.form.submit();
}
function check_status(){

	$.ajax({
        url: '/applydb.cgi?p=cpufreq&current_page=Module_cpufreq.asp.asp&next_page=Module_cpufreq.asp.asp&group_id=&modified=0&action_mode=+Refresh+&action_script=cpufreq_status.sh&action_wait=&first_time=&preferred_lang=CN&firmver=3.0.0.4',
  		dataType: 'html',
		success: function (response) {
			return true;
		}
	});
}
function get_log() {
	$.ajax({
		url: '/res/cpufreq_log.htm',
		dataType: 'html',
		success: function(response) {
			var retArea = E("log_content1");
			if (_responseLen == response.length) {
				noChange++;
			} else {
				noChange = 0;
			}
			if (noChange > 6000) {
				//retArea.value = "当前日志文件为空";
				return false;
			} else {
				setTimeout("get_log();",2000);
			}
			retArea.value = response;
			_responseLen = response.length;
		},
		error: function(xhr) {
			//setTimeout("get_log();", 1000);
			E("log_content1").value = "暂无日志信息！";
		}
	});
}

function menu_hook(title, tab) {
	tabtitle[tabtitle.length -1] = new Array("", "软件中心", "离线安装", "CPU频率设置");
	tablink[tablink.length -1] = new Array("", "Main_Soft_center.asp", "Main_Soft_setting.asp", "Module_cpufreq.asp");
}
function reload_Soft_Center(){
	location.href = "/Main_Soft_center.asp";
}
function done_validating(action) {
	return true;
}
</script>
</head>
<body onload="init();">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
<form method="POST" name="form" action="/applydb.cgi?p=cpufreq" target="hidden_frame">
<input type="hidden" name="current_page" value="Module_cpufreq.asp"/>
<input type="hidden" name="next_page" value="Module_cpufreq.asp"/>
<input type="hidden" name="group_id" value=""/>
<input type="hidden" name="modified" value="0"/>
<input type="hidden" name="action_mode" value=" Refresh "/>
<input type="hidden" name="action_script" value="cpufreq_config.sh"/>
<input type="hidden" name="action_wait" value="5"/>
<input type="hidden" name="first_time" value=""/>
<input type="hidden" name="cpufreq_enable" value="<% dbus_get_def("cpufreq_enable", "0"); %>"/>
<input type="hidden" name="cpufreq_cur" value="<% dbus_get_def("cpufreq_cur", "0"); %>"/>
<input type="hidden" name="cpufreq_set" value="<% dbus_get_def("cpufreq_set", "0"); %>"/>
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
                						<div id="cpufreq_title" style="float:left;" class="formfonttitle" style="padding-top: 12px">CPU频率设置</div>
										<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
										<div style="margin:30px 0 10px 5px;" class="splitLine"></div>
										<div class="SimpleNote" id="head_illustrate"><i></i><em>Intel CPU频率设置<br>请合理设置频率，过低会导致运行异常缓慢，频率越低温度越低</em></div>
										<div id="cpufreq_switch" style="margin:0px 0px 0px 0px;">
                							<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<thead>
												<tr>
													<td colspan="2">设置</td>
												</tr>
												</thead>
													<tr>
													<th>系统当前频率</th>
													<td>
														<i><% dbus_get_def("cpufreq_cur", "未知"); %>MHz</i>
													</td>
												</tr>
												<tr id="switch_tr">
													<th>
														<label>开启频率设置</label>
													</th>
													<td colspan="2">
														<div class="switch_field" style="display:table-cell">
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
													</td>
												</tr>
											</table>
										</div>
										<div id="cpufreq_log" style="margin:-1px 0px 0px 0px;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<thead>
													<tr>
														<td colspan="2">运行信息</td>
													</tr>
												</thead>
												<tr>
													<td colspan="2">
														<div id="log_content" style="margin-top:-1px;display:block;overflow:hidden;">
															<textarea cols="63" rows="36" wrap="on" readonly="readonly" id="log_content1" style="width:99%;font-family:Courier New, Courier, mono; font-size:11px;background:#475A5F;color:#FFFFFF;" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
														</div>
													</td>
												</tr>
											</table>
										</div>											
										<div class="apply_gen">
											<button id="cmdBtn" class="button_gen" onclick="save()">提交</button>
										</div>
										<div class="KoolshareBottom">
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
