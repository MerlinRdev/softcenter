<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <meta HTTP-EQUIV="Expires" CONTENT="-1"/>
        <link rel="shortcut icon" href="images/favicon.png"/>
        <link rel="icon" href="images/favicon.png"/>
        <title>软件中心 - Fcn一键接入</title>
        <link rel="stylesheet" type="text/css" href="index_style.css">
        <link rel="stylesheet" type="text/css" href="form_style.css">
        <link rel="stylesheet" type="text/css" href="usp_style.css">
        <link rel="stylesheet" type="text/css" href="ParentalControl.css">
        <link rel="stylesheet" type="text/css" href="css/icon.css">
        <link rel="stylesheet" type="text/css" href="css/element.css">
	<link rel="stylesheet" type="text/css" href="res/softcenter.css">
        <script type="text/javascript" src="/state.js"></script>
        <script type="text/javascript" src="/popup.js"></script>
        <script type="text/javascript" src="/help.js"></script>
        <script type="text/javascript" src="/general.js"></script>
        <script type="text/javascript" src="/js/jquery.js"></script>
        <script type="text/javascript" src="/client_function.js"></script>
        <script type="text/javascript" src="/calendar/jquery-ui.js"></script>
        <script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
        <script type="text/javascript" src="/form.js"></script>
	<script type="text/javascript" src="/res/softcenter.js"></script>
        <script type="text/javascript" src="/dbconf?p=fcn_&v=<% uptime(); %>"></script>
        <script type="text/javascript">
            function E(e) {
                return (typeof (e) == 'string') ? document.getElementById(e) : e;
            }

            function init() {
                show_menu();
                conf2obj();
                buildswitch();
                //update_fcn_status();
                var rrt = E("switch");
                if (document.form.fcn_enable.value != "1") {
                    rrt.checked = false;
                    E('fcn_detail_table').style.display = "none";
                } else {
                    rrt.checked = true;
                    E('fcn_detail_table').style.display = "";
                }

                if (document.form.fcn_vip.value != "1") {
                    E('fcn_uid').readOnly = true;
                    E('show_uic').style.display = "none";
                    document.form.show_vip.checked = false;                    
                } else {
                    E('fcn_uid').readOnly = false;
                    E('show_uic').style.display = "";
                    document.form.show_vip.checked = true;
                }

                $("#fcn_version_status").html("<i>当前版本：" + db_fcn_['fcn_version']);
                check_selected("fcn_udp", db_fcn_.fcn_udp);
            }
            
            function menu_hook() {
                //browser_compatibility1();
                tabtitle[tabtitle.length - 1] = new Array("", "软件中心", "离线安装", "Fcn一键接入");
                tablink[tablink.length - 1] = new Array("", "Main_Soft_center.asp", "Main_Soft_setting.asp", "Module_fcn.asp");
            } 

            /* function update_fcn_status() {
                var dbus = {};
                dbus["SystemCmd"] = "fcn_status.sh";
                dbus["action_mode"] = " Refresh ";
                dbus["current_page"] = "Module_fcn.asp";
                $.ajax({
                    type: "POST",
                    url: '/applydb.cgi?p=fcn',
                    contentType: "application/x-www-form-urlencoded",
                    dataType: 'text',
                    data: $.param(dbus),
                    error: function (xhr) {
                        setTimeout("update_fcn_status();", 1000);
                    },
                    success: function (response) {
                        $.ajax({
                            url: '/cmdRet_check.htm',
                            dataType: 'html', 
                            success: function (response) {
                                E('fcn_run_state').innerHTML = response;
                            }
                        });
                        setTimeout("update_fcn_status();", 1000); 
                    }
                });
            } */ 

            function get_fcn_status() {
                $.ajax({
                    url: 'applydb.cgi?p=fcn&current_page=Module_fcn.asp&next_page=Module_fcn.asp&group_id=&modified=0&action_mode=+Refresh+&action_script=fcn_status.sh&action_wait=&first_time=&preferred_lang=CN&firmver=3.0.0.4',
                    dataType: 'html',
                    success: function (response) {
                        setTimeout("write_fcn_status();", 1000);
                        return true;
                    }
                });
            }

            function write_fcn_status() {
	            E("fcn_run_state").value = "获取中......"
                $.ajax({
                    url: '/res/fcn_status.htm',
                    dataType: 'html',
                    error: function (xhr) {
                        setTimeout("write_fcn_status();", 500);
                    },
                    success: function (response) {
                        E("fcn_run_state").innerHTML = response.replace("XU6J03M6", " ");
                    }
                });
            }

            function conf2obj() {
                get_fcn_status();
                $.ajax({
                    type: "get",
                    url: "dbconf?p=fcn_",
                    dataType: "script",
                    success: function (xhr) {
                        if (typeof db_fcn_ != "undefined") {
                            for (var field in db_fcn_) {
                                var el = E(field);
                                if (el != null) {
                                    if (el.getAttribute("type") == "checkbox") {
                                        if (db_fcn_[field] == "1") {
                                            el.checked = true;
                                        } else {
                                            el.checked = false;
                                        }
                                    } else {
                                        el.value = db_fcn_[field];
                                    }
                                }
                            }
                        }

                        if (document.form.fcn_vip.value != "1") {
                            E('fcn_uid').readOnly = true;
                            E('show_uic').style.display = "none";
                            document.form.show_vip.checked = false;
                        } else {
                            E('fcn_uid').readOnly = false;
                            E('show_uic').style.display = "";
                            document.form.show_vip.checked = true;
                        }
                        //$("#fcn_run_state").html(db_fcn_['fcn_run_status']);
                        check_selected("fcn_udp", db_fcn_.fcn_udp);
                    }
                });
            }

            function onSubmitCtrl(o, s) {
                document.form.action_mode.value = s;                
                document.form.submit();
                setTimeout("conf2obj()", 4000);
                showLoading(5);
            }

            function check_selected(obj, m) {
		        var o = E(obj);
		        for (var c = 0; c < o.length; c++) {
		            if (o.options[c].value == m) {
		                o.options[c].selected = true;
		                break;
		            }
		        }
            }
            
            function buildswitch(){
                $("#switch").click(
                    function () {
                        if (E('switch').checked) {
                            document.form.fcn_enable.value = 1;
                            E('fcn_detail_table').style.display = "";
                        } else {
                            document.form.fcn_enable.value = 0;
                            E('fcn_detail_table').style.display = "none";
                        }
                    });
            }
            
            function pass_checked(obj){
		    	switchType(obj, document.form.show_pass.checked, true);
            }

            function vip_checked(obj){
		    	if (obj.checked) {
                    E('fcn_uid').readOnly = false;
                    E('show_uic').style.display = "";
                    E('fcn_host').value = "vip.xfconnect.com";
                    E('fcn_vip').value = "1";
                } else {
                    //document.form.fcn_uic.value = "";
                    E('fcn_uid').readOnly = true;
                    E('show_uic').style.display = "none";
                    E('fcn_host').value = "free.xfconnect.com";
                    E('fcn_vip').value = "0";
                }
            }
            
            function done_validating(action) {
                return true;
            }

            function reload_Soft_Center() {
                location.href = "/Main_Soft_center.asp";
            }
        </script>
    </head>
    <body onload="init();">
        <div id="TopBanner"></div>
        <div id="Loading" class="popup_bg"></div>
        <iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
        <form method="post" name="form" action="/applydb.cgi?p=fcn_" target="hidden_frame">
            <input type="hidden" name="current_page" value="Module_fcn.asp"/>
            <input type="hidden" name="next_page" value="Module_fcn.asp"/>
            <input type="hidden" name="group_id" value=""/>
            <input type="hidden" name="modified" value="0"/>
            <input type="hidden" name="action_mode" value=" Refresh "/>
            <input type="hidden" name="action_script" value="fcn_config.sh"/>
            <input type="hidden" name="action_wait" value="5"/>
            <input type="hidden" name="first_time" value=""/>
            <input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
            <input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>"/>
            <input type="hidden" id="fcn_enable" name="fcn_enable" value='<% dbus_get_def("fcn_enable", "0"); %>' />
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
									<table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FrmTitle">
										<tr>
											<td bgcolor="#4D595D" colspan="3" valign="top">
												<div>&nbsp;</div>
												<div style="float:left;" class="formfonttitle">Fcn一键接入</div>
												<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
                                                <div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
                                                <div class="SimpleNote" id="head_illustrate">通过互联网分享本机局域网给好友。<a href="https://github.com/boywhp/fcn" target="_blank"><em><u>点击访问项目主页</u></em></a></div>
                                                <table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0"
                                                    bordercolor="#6b8fa3" class="FormTable">
                                                    <thead>
                                                        <tr>
                                                            <td colspan="2">开关设置</td>
                                                        </tr>
                                                    </thead>
                                                    <tr>
                                                        <th>开启Fcn服务</th>
                                                        <td colspan="2">
                                                            <div class="switch_field" style="display:table-cell;float: left;">
                                                                <label for="switch">
                                                                    <input id="switch" class="switch" type="checkbox" style="display: none;">
                                                                    <div class="switch_container">
                                                                        <div class="switch_bar"></div>
                                                                        <div class="switch_circle transition_style">
                                                                            <div></div>
                                                                        </div>
                                                                    </div>
                                                                </label>
                                                            </div>
                                                            <div id="fcn_version_status" style="padding-top:5px;margin-left:230px;margin-top:0px;float:left;">
                                                                <i>当前版本：
                                                                    <% dbus_get_def("fcn_version", "未知"); %></i>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
												<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="fcn_detail_table">
                                                        <thead>
                                                        <tr>
                                                            <td colspan="2">连接设置</td>
                                                        </tr>
                                                        </thead>
                                                        <tr>
                                                            <th width="35%">连接ID</th>
                                                            <td>
                                                                <input type="text" class="input_ss_table" style="width:auto;" size="20" id="fcn_uid" name="fcn_uid" maxlength="16" placeholder="FCN账户" value='<% dbus_get_def("fcn_uid", ""); %>'>
                                                                <div style="margin-left:170px;margin-top:-20px;margin-bottom:0px">
                                                                    <input type="checkbox" name="show_vip" onclick="vip_checked(this);">
                                                                    <input id="fcn_vip" name="fcn_vip" type="hidden" value="0">付费账户</div>                                                                
                                                            </td>
                                                        </tr>
                                                        <tr id="show_uic">
                                                            <th width="35%">识别码</th>
                                                            <td>
                                                                <input  type="password" class="input_ss_table" style="width:auto;" size="20"  id="fcn_uic" name="fcn_uic" maxlength="16" placeholder="8位识别码" value='<% dbus_get_def("fcn_uic", ""); %>'>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <th width="35%">服务名称</th>
                                                            <td>
                                                                <input type="text" class="input_ss_table" style="width:auto;" size="20" id="fcn_name" name="fcn_name"
                                                                    maxlength="16" placeholder="服务端名称" value='<% dbus_get_def("fcn_name", ""); %>'>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <th width="35%">连接密码</th>
                                                            <td>
                                                                <input  type="password" class="input_ss_table" style="width:auto;" size="20"  id="fcn_psk" name="fcn_psk" maxlength="16" placeholder="连接密码" value='<% dbus_get_def("fcn_psk", ""); %>'>
                                                                <div style="margin-left:170px;margin-top:-20px;margin-bottom:0px"><input type="checkbox" name="show_pass" onclick="pass_checked(document.form.fcn_psk);">显示密码</div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <th width="35%">通信协议</th>
                                                            <td>
                                                                <select id="fcn_udp" name="fcn_udp" class="input_option">
                                                                    <option value="1">UDP</option>
                                                                    <option value="0">TCP</option>
                                                                </select>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <th width="35%">服务器</th>
                                                            <td>
                                                                <input type="text" class="input_ss_table" style="width:auto;" size="30" id="fcn_host" name="fcn_host" maxlength="40" placeholder="填写完整域名" value='<% dbus_get_def("fcn_host", "free.xfconnect.com"); %>'>
                                                            </td>
                                                        </tr>
                                                        <thead>
                                                        <tr>
                                                            <td colspan="3">运行状态</td>
                                                        </tr>
                                                        </thead>
                                                        <tr>
                                                            <th width="35%">状态</th>
                                                            <td>
                                                                <a>
                                                                    <span id="fcn_run_state"></span>
                                                                </a>
                                                            </td>
                                                        </tr>
                                                     </table>
                                                     <div id="warn" style="display: none;margin-top: 20px;text-align: center;font-size: 20px;margin-bottom: 20px;"class="formfontdesc" ></div>
                                                     <div class="apply_gen">
                                                         <button id="cmdBtn" class="button_gen" onclick="onSubmitCtrl(this, 'restart')">提交</button>
                                                     </div>
                                                     <div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
                                                     <div class="SimpleNote">
                                                        <li>FCN属于正规网络接入软件，请合理，合法的使用本软件产品。</li>
                                                        <li>FCN公网服务器不会收集和保存用户的任何敏感数据。</li>
                                                        <li>FCN用户网络数据全程高强度加密，60分钟左右自动更新会话密钥。</li>
                                                        <li>分享局域网可能会导致安全问题，请务必妥善保管好连接凭证。</li>
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
        </form>
        <div id="footer"></div>
    </body>
</html>
