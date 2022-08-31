extends Node2D

var select_version = ""
enum proxy {ghproxy,fastgithub}

func _ready():
	for button in $VersionPanel/VersionList.get_children():
		button.connect("pressed",self,"_on_download_pressed",[button.text])
	$Panel/Panel/Mirror/OptionButton.connect("item_selected",self,"_on_change_proxy")
	pass
	
func _on_Run_pressed():
	var exit_code = OS.execute("Main.exe",["run",select_version],false)
	if exit_code != OK:
		print_debug("出错了")
	pass
	
# 执行下载
func _on_download_pressed(version):
	#print_debug(version)
	var conv_version = "v" + version
	var exit_code = OS.execute("Main.exe",["download_game",conv_version],true)
	if exit_code != OK: OS.alert("出错了")
	elif exit_code == OK: OS.alert("下载完成")
	exit_code = OS.execute("Main.exe",["install_game",conv_version],true)
	if exit_code != OK:
		print_debug("出错了")
	elif exit_code == OK:
		OS.alert("安装完成")
	pass
# 显示下载列表
func _on_Downlaod_pressed():
	$VersionPanel.show()
	pass

func _on_GlobalSet_pressed():
	$Panel.show()
	pass
func _on_change_proxy(p_proxy):
	#print_debug(p_proxy)
	var choosed_proxy = ""
	match p_proxy:
		proxy.ghproxy:
			choosed_proxy = "ghproxy"
		proxy.fastgithub:
			choosed_proxy = "fastgithub"
			
	var exit = OS.execute("Main.exe",["change_proxy",choosed_proxy],true)
	if exit != OK: print_debug("出错了")
	elif exit == OK: OS.alert("已切换代理")
	pass

