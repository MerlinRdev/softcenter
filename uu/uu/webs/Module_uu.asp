<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <meta HTTP-EQUIV="Expires" CONTENT="-1"/>
        <link rel="shortcut icon" href="images/favicon.png"/>
        <link rel="icon" href="images/favicon.png"/>
        <title>软件中心 - 网易uu</title>
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
        <script type="text/javascript" src="/dbconf?p=uu_&v=<% uptime(); %>"></script>
        <script type="text/javascript">
            function E(e) {
                return (typeof (e) == 'string') ? document.getElementById(e) : e;
            }

            function init() {
                show_menu();
                conf2obj();
                buildswitch();
                var rrt = E("switch");
                if (document.form.uu_enable.value != "1") {
                    rrt.checked = false;
                } else {
                    rrt.checked = true;
                }
                $("#uu_version_status").html("<i>当前版本：" + db_uu_['uu_version']);
            }
            
            function menu_hook() {
                tabtitle[tabtitle.length - 1] = new Array("", "软件中心", "离线安装", "网易uu");
                tablink[tablink.length - 1] = new Array("", "Main_Soft_center.asp", "Main_Soft_setting.asp", "Module_uu.asp");
            } 
            function get_uu_status() {
		E("uu_run_state").value = "获取中......"
                $.ajax({
                    url: 'logreaddb.cgi?p=uu_log.log&script=uu_status.sh',
                    dataType: 'html',
                    success: function (response) {
			E("uu_run_state").innerHTML = response.replace("XU6J03M6", " ");
                        setTimeout("get_uu_status();", 10000);
                        return true;
                    }
                });
            }

            function conf2obj() {
                get_uu_status();
                $.ajax({
                    type: "get",
                    url: "dbconf?p=uu_",
                    dataType: "script",
                    success: function (xhr) {
                        if (typeof db_uu_ != "undefined") {
                            for (var field in db_uu_) {
                                var el = E(field);
                                if (el != null) {
                                    if (el.getAttribute("type") == "checkbox") {
                                        if (db_uu_[field] == "1") {
                                            el.checked = true;
                                        } else {
                                            el.checked = false;
                                        }
                                    } else {
                                        el.value = db_uu_[field];
                                    }
                                }
                            }
                        }
                    }
                });
            }

            function onSubmitCtrl(o, s) {
                document.form.action_mode.value = s;                
                document.form.submit();
                setTimeout("conf2obj()", 4000);
                showLoading(5);
            }
            function buildswitch(){
                $("#switch").click(
                    function () {
                        if (E('switch').checked) {
                            document.form.uu_enable.value = 1;
                        } else {
                            document.form.uu_enable.value = 0;
                        }
                    });
            }
        </script>
    </head>
    <body onload="init();">
        <div id="TopBanner"></div>
        <div id="Loading" class="popup_bg"></div>
        <iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
        <form method="post" name="form" action="/applydb.cgi?p=uu_" target="hidden_frame">
            <input type="hidden" name="current_page" value="Module_uu.asp"/>
            <input type="hidden" name="next_page" value="Module_uu.asp"/>
            <input type="hidden" name="group_id" value=""/>
            <input type="hidden" name="modified" value="0"/>
            <input type="hidden" name="action_mode" value=" Refresh "/>
            <input type="hidden" name="action_script" value="uu_config.sh"/>
            <input type="hidden" name="action_wait" value="5"/>
            <input type="hidden" name="first_time" value=""/>
            <input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
            <input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>"/>
            <input type="hidden" id="uu_enable" name="uu_enable" value='<% dbus_get_def("uu_enable", "0"); %>' />
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
												<div style="float:left;" class="formfonttitle">网易uu</div>
												<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
                                                <div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
                                                <div class="SimpleNote" id="head_illustrate">极速畅玩全球电脑/主机/掌机/手机游戏.</div>
                                                <div class="SimpleNote" id="head_illustrate">安装完插件后用uu app检测是否需要重新安装即可正常使用.</div>
                                                <table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0"
                                                    bordercolor="#6b8fa3" class="FormTable">
                                                    <thead>
                                                        <tr>
                                                            <td colspan="2">开关设置</td>
                                                        </tr>
                                                    </thead>
                                                    <tr>
                                                        <th>开启uu</th>
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
                                                            <div id="uu_version_status" style="padding-top:5px;margin-left:230px;margin-top:0px;float:left;">
                                                                <i>当前版本：
                                                                    <% dbus_get_def("uu_version", "未知"); %></i>
                                                            </div>
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
                                                                    <span id="uu_run_state"></span>
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
                                                        <img src="/res/code_8c75219.png">
                                                        <li>扫描安装手机app，仅支持安卓。</li>
                                                        <li>需要在插件里开启后才能开机自动启动，app仅实现绑定路由。</li>
                                                        <li>一般情况下插件会自动更新版本。</li>
                                                        <li>开启uu后应关掉其他去广告或代理软件。</li>
                                                        <li>这个插件仅用来在华硕官方没有更新uu支持前使用（未来几个月内大部分路由会更新）。</li>
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
