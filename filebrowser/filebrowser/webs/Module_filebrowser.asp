<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="-1" />
    <link rel="shortcut icon" href="/res/icon-filebrowser.png" />
    <link rel="icon" href="/res/icon-filebrowser.png" />
    <title>软件中心 - FileBrowser</title>
    <link rel="stylesheet" type="text/css" href="index_style.css" />
    <link rel="stylesheet" type="text/css" href="form_style.css" />
    <link rel="stylesheet" type="text/css" href="css/element.css">
    <link rel="stylesheet" type="text/css" href="res/softcenter.css">
    <script language="JavaScript" type="text/javascript" src="/state.js"></script>
    <script language="JavaScript" type="text/javascript" src="/help.js"></script>
    <script language="JavaScript" type="text/javascript" src="/general.js"></script>
    <script language="JavaScript" type="text/javascript" src="/popup.js"></script>
    <script language="JavaScript" type="text/javascript" src="/client_function.js"></script>
    <script language="JavaScript" type="text/javascript" src="/validator.js"></script>
    <script type="text/javascript" src="/js/jquery.js"></script>
    <script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
    <script type="text/javascript" src="/res/softcenter.js"></script>
    <script type="text/javascript">
        var db_filebrowser = {}
		function E(e) {
			return (typeof(e) == 'string') ? document.getElementById(e) : e;
		}
		function check_status(){
			var id = parseInt(Math.random() * 100000000);
			var postData = {"id": id, "method": "filebrowser_status.sh", "params":[], "fields": ""};
			$.ajax({
				type: "POST",
				url: "/_api/",
				async: true,
				data: JSON.stringify(postData),
				dataType: "json",
				success: function (response) {
					//console.log(response)
					var arr = response.result.split("@");
					E("filebrowser_status").innerHTML = arr[0];
					$("#fileb").html("<a type='button' href='http://"+ location.hostname + ":"+arr[2]+"' target='_blank' >访问 FileBrowser</a>");
				
					setTimeout("check_status();", 10000);
				},
				error: function(){
					E("filebrowser_status").innerHTML = "获取运行状态失败";
					setTimeout("check_status();", 5000);
				}
			});
		}
        function start() {
            showLoading(2);
            refreshpage(2);
            var id = parseInt(Math.random() * 100000000);
			db_filebrowser["filebrowser_watchdog"] = E("filebrowser_watchdog").checked ? '1' : '0';
            db_filebrowser["filebrowser_publicswitch"] = E("filebrowser_publicswitch").checked ? '1' : '0';
			db_filebrowser["filebrowser_delay_time"] = E("filebrowser_delay_time").value;
            db_filebrowser["filebrowser_port"] = E("filebrowser_port").value;
            
            var postData = { "id": id, "method": "filebrowser_config.sh", "params": ["start"], "fields": db_filebrowser };
            $.ajax({
                url: "/_api/",
                cache: false,
                type: "POST",
                dataType: "json",
                data: JSON.stringify(postData)
            });
        }

        function close() {
            if (confirm('确定马上关闭吗.?')) {
				showLoading(2);
           		refreshpage(2);
                var id = parseInt(Math.random() * 100000000);
                var postData = { "id": id, "method": "filebrowser_config.sh", "params": ["stop"], "fields": "" };
                $.ajax({
                    url: "/_api/",
                    cache: false,
                    type: "POST",
                    dataType: "json",
                    data: JSON.stringify(postData)
                });
            }
        }
        //导出数据库以及还原
        function down_database() {
            var id = parseInt(Math.random() * 100000000);
            var postData = {"id": id, "method": "filebrowser_downdata.sh", "params":[], "fields": "" };
            $.ajax({
                type: "POST",
                url: "/_api/",
                async: true,
                cache:false,
                data: JSON.stringify(postData),
                dataType: "json",
                success: function(response){
                    if(response.result == id){
                       
                            var downloadA = document.createElement('a');
                            var josnData = {};
                            var a = "http://"+window.location.hostname+"/_temp/"+"filebrowser.db"
                            var blob = new Blob([JSON.stringify(josnData)],{type : 'application/json'});
                            downloadA.href = a;
                            downloadA.download = "filebrowser.db";
                            downloadA.click();
                            window.URL.revokeObjectURL(downloadA.href);
                        
                    }
                }
            });	
        }
        function upload_database() {
            var filename = $("#database").val();
            filename = filename.split('\\');
            filename = filename[filename.length - 1];
            var filelast = filename.split('.');
            filelast = filelast[filelast.length - 1];
            //alert(filename);
            if (filelast != "db") {
                alert('上传文件格式非法！只支持上传db后缀的数据库文件');
                return false;
            }
            E('database_info').style.display = "none";
            var formData = new FormData();
            var dbname = "filebrowser.db";
            formData.append(dbname, document.getElementById('database').files[0]);

            $.ajax({
                url: '/_upload',
                type: 'POST',
                cache: false,
                data: formData,
                processData: false,
                contentType: false,
                complete: function(res) {
                    if (res.status == 200) {
                        upload_data(dbname);
                    }
                }
            });
        }

        //数据库处理
        function upload_data(dbname) {
            var id = parseInt(Math.random() * 100000000);
            db_filebrowser["filebrowser_uploaddatabase"] = dbname;
            var postData = { "id": id, "method": "filebrowser_config.sh", "params": ["upload"], "fields": db_filebrowser };
            $.ajax({
                url: "/_api/",
                cache: false,
                type: "POST",
                dataType: "json",
                data: JSON.stringify(postData),
                success: function(response){
                    if(response.result == id){
                        E('database_info').style.display = "block";   
                        showLoading(2);
                        refreshpage(2);
                    }
                }
            });    
        }
        function init() {
            show_menu(menu_hook);
			get_dbus_data();
			check_status();
        }

        function menu_hook(title, tab) {
            tabtitle[tabtitle.length - 1] = new Array("", "FileBrowser");
            tablink[tablink.length - 1] = new Array("", "Module_filebrowser.asp");
        }

        function get_dbus_data() {
            $.ajax({
                type: "GET",
                url: "/_api/filebrowser",
                dataType: "json",
                async: false,
                success: function (data) {
					db_filebrowser = data.result[0];
					E("filebrowser_watchdog").checked = db_filebrowser["filebrowser_watchdog"] == "1";
                    E("filebrowser_publicswitch").checked = db_filebrowser["filebrowser_publicswitch"] == "1";
					if(db_filebrowser["filebrowser_delay_time"]){					
						E("filebrowser_delay_time").value = db_filebrowser["filebrowser_delay_time"];
					}
                    if(db_filebrowser["filebrowser_port"]){					
						E("filebrowser_port").value = db_filebrowser["filebrowser_port"];
					}
                    	
                }
            });
        }

        $(function () {
            $('#btn_Start').click(start);
            $("#btn_Close").click(close);
            //get_dbus_data();
        });
    </script>
</head>
<body onload="init();">
    <div id="TopBanner"></div>
    <div id="Loading" class="popup_bg"></div>
    <div id="LoadingBar" class="popup_bar_bg">
        <table cellpadding="5" cellspacing="0" id="loadingBarBlock" class="loadingBarBlock" align="center">
            <tr>
                <td height="100">
                    <div id="loading_block3" style="margin: 10px auto; margin-left: 10px; width: 85%; font-size: 12pt;"></div>
                    <div id="loading_block2" style="margin: 10px auto; width: 95%;"></div>
                    <div id="log_content2" style="margin-left: 15px; margin-right: 15px; margin-top: 10px; overflow: hidden">
                        <textarea cols="63" rows="21" wrap="on" readonly="readonly" id="log_content3" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" style="border: 1px solid #000; width: 99%; font-family: 'Courier New', Courier, mono; font-size: 11px; background: #000; color: #FFFFFF;"></textarea>
                    </div>
                    <div id="ok_button" class="apply_gen" style="background: #000; display: none;">
                        <input id="ok_button1" class="button_gen" type="button" onclick="hideKPLoadingBar()" value="确定">
                    </div>
                </td>
            </tr>
        </table>
    </div>
    <iframe name="hidden_frame" id="hidden_frame" width="0" height="0" frameborder="0"></iframe>
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
                                        <div class="formfonttitle">软件中心 - FileBrowser</div>
                                        <div style="float: right; width: 15px; height: 25px; margin-top: -20px">
                                            <img id="return_btn" alt="" onclick="reload_Soft_Center();" align="right" style="cursor: pointer; position: absolute; margin-left: -30px; margin-top: -25px;" title="返回软件中心" src="/images/backprev.png" onmouseover="this.src='/images/backprevclick.png'" onmouseout="this.src='/images/backprev.png'" />
                                        </div>
                                        <div style="margin: 10px 0 10px 5px;" class="splitLine"></div>
                                        <div class="SimpleNote">
                                            <a href="https://github.com/filebrowser/filebrowser" target="_blank"><em><u>FileBrowser</u></em></a>&nbsp;可以在指定目录内提供文件管理界面，可用于上载，删除，预览，重命名和编辑文件。它允许创建多个用户，每个用户可以拥有自己的目录。
                                        </div>
                                        <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
                                            <thead>
                                                <tr>
                                                    <td colspan="2">FileBrowser - 设置</td>
                                                </tr>
                                            </thead>               
                                            <tr id="filebrowser_tr">
                                                <th>开关</th>
                                                <td>
													<button id="btn_Start" class="ks_btn" style="width: 110px; cursor: pointer; float: left; ">开启</button>

                                                    <button id="btn_Close" class="ks_btn" style="width: 110px; cursor: pointer; float: left; margin-left: 5px;">关闭</button>
                                                    
                                                </td>
                                            </tr>
                                            <tr id="filebrowser_port_tr">
                                                <th>端口</th>
                                                <td>
                                                    <input type="text" id="filebrowser_port" style="width: 50px;" maxlength="5" class="input_3_table" name="filebrowser_port" autocorrect="off" autocapitalize="off" style="background-color: rgb(89, 110, 116);" value="26789">
                                                </td>
                                            </tr>
											<tr>
												<th >状态</th>
												<td colspan="2"  id="filebrowser_status">
												</td>
											</tr>
											<tr>
												<th >访问</th>
												<td colspan="2"  id="filebrowser_access">
													<a type="button" style="vertical-align: middle; cursor:pointer;" id="fileb" class="ks_btn" target="_blank" >访问 FileBrowser</a>					
												</td>
											</tr>
										</table>
										<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="filebrowser_switch_table">
											<thead>
											<tr>
												<td colspan="2">FileBrowser 看门狗</td>
											</tr>
											</thead>
											<tr>
											<th>看门狗开关</th>
												<td colspan="2">
													<div class="switch_field" style="display:table-cell;float: left;">
														<label for="filebrowser_watchdog">
															<input id="filebrowser_watchdog" class="switch" type="checkbox" style="display: none;">
															<div class="switch_container" >
																<div class="switch_bar"></div>
																<div class="switch_circle transition_style">
																	<div></div>
																</div>
															</div>
														</label>
													</div>
													<div class="SimpleNote" id="head_illustrate">
														<p>进程守护工具，根据设定的时间，周期性检查 filebrowser 进程是否存在，如果 filebrowser 进程丢失则会自动重新拉起。</p>														
													</div>
												</td>
											</tr>
													<!--看门狗检查间隔-->
											<tr>
													<th>自定义检查时间</th>
														<td colspan="2">
															<div class="SimpleNote" id="head_illustrate">
																<input onkeyup="this.value=this.value.replace(/[^1-9]+/,'2')" id="filebrowser_delay_time" maxlength="1" style="color: #FFFFFF; width: 30px; height: 20px; background-color:rgba(87,109,115,0.5); font-family: Arial, Helvetica, sans-serif; font-weight:normal; font-size:12px;" value="2" ><span>&nbsp;分钟</span>															
															</div>
														</td>		
												</tr>
                                        </table>
                                        <table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
                                            <thead>
                                            <tr>
                                                <td colspan="2">公网访问设定 -- <em style="color: gold;">【请先设置相对应的<a href="./Advanced_VirtualServer_Content.asp" target="_blank"><em>端口转发</em></a>，再开启此按钮，重启插件后生效】</td>
                                            </tr>
                                            </thead>
                                            <tr id="dashboard">	
                                            <th>开启公网访问</th>
                                            <td colspan="2">
                                                <div class="switch_field" style="display:table-cell;float: left;">
                                                <label for="filebrowser_publicswitch">
                                                    <input id="filebrowser_publicswitch" type="checkbox" name="dashboard" class="switch" style="display: none;">
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
                                        <table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="merlinclash_switch_table">
                                            <thead>
                                            <tr>
                                                <td colspan="2">备份/恢复数据库</td>
                                            </tr>
                                            </thead>
                                            <tr>
                                                <th id="btn-open-clash-dashboard" class="btn btn-primary">备份数据库</th>
                                                <td colspan="2">
                                                    <a type="button" style="vertical-align: middle; cursor:pointer;" id="database-btn-download" class="ks_btn" onclick="down_database()" >导出数据库</a>
                                                </td>
                                            </tr>
                                            <tr>
                                            <th id="btn-open-clash-dashboard" class="btn btn-primary">恢复数据库</th>
                                            <td colspan="2">
                                                <div class="SimpleNote" style="display:table-cell;float: left; height: 110px; line-height: 110px; margin:-40px 0;">
                                                    <input type="file" style="width: 200px;margin: 0,0,0,0px;" id="database" size="50" name="file"/>
                                                    <span id="database_info" style="display:none;">完成</span>															
                                                    <a type="button" style="vertical-align: middle; cursor:pointer;" id="database-btn-upload" class="ks_btn" onclick="upload_database()" >恢复数据库</a>
                                                </div>
                                            </td>
                                            </tr>														
                                        </table>
                                        <div id="warning" style="font-size: 14px; margin: 20px auto;"></div>
                                        <div style="margin: 10px 0 10px 5px;" class="splitLine"></div>
                                        <div id="DEVICE_note" style="margin:10px 0 0 5px">
                                            <div><i>&nbsp;&nbsp;说明：<br>
                                            &nbsp;&nbsp;1.FileBRowser的初始用户名和密码均为<em>admin</em>；<br>
                                            &nbsp;&nbsp;2.登陆后可在【Setting】-【Profile Settings】中修改语言为中文；<br>
											&nbsp;&nbsp;3.如若开启公网访问，切记在<em>【设置】</em>-<em>【用户管理】</em>中修改掉默认的用户名和密码<em>(大小写字母数字组合，8位以上)</em>；<br>
                                            &nbsp;&nbsp;4.长期开启公网访问有风险，请酌情使用。<br></i></div>
                                            <div><i>&nbsp;</i></div>
                                        </div>
                                      </td>
                                </tr>
                                
                            </table>
                           
                        </td>
                    </tr>
                </table>
            </td>
            <td width="10" align="center" valign="top"></td>
        </tr>
    </table>
    <div id="footer"></div>
</body>
</html>

