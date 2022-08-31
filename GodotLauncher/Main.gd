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
	#if exit_code != OK: print_debug("出错了")
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



func _on_ListGame_pressed():
	var output = []
	var exit_code = OS.execute("Main.exe",["list_installed"],true,output)
	if exit_code != OK: OS.alert("出错了")
	OS.shell_open("games")
#	elif exit_code == OK:
#		for v in output:
#			if v == "v3.2.0": $InstalledPanel/VersionList/v1/Label.text = "已安装"
#			if v == "v2.0.0": 
#				print_debug(v,"已安装")
#				$InstalledPanel/VersionList/v2/Label.text = "已安装"
#			if v == "v1.6.0": $InstalledPanel/VersionList/v3/Label.text = "已安装"
#			if v == "v1.3.0": $InstalledPanel/VersionList/v4/Label.text = "已安装"
#			print_debug(v)
#		$InstalledPanel.show()
#
#	print_debug(output)
	
	pass

func _on_GameList_pressed():
	var GameList = $GameList
	var path = OS.get_executable_path().get_base_dir() + "/games"
	print_debug(path)
	var dir = Directory.new()
	var dirs = []
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print_debug("发现目录：" + file_name)
				file_name = dir.get_next()
				dirs.append(file_name)
	else:
		print_debug("尝试访问路径时出错。")
	GameList.clear()
	for i in dirs:
		GameList.add_item(i)
	pass

func _on_GameList_item_selected(index):
	select_version = $GameList.get_item_text(index)
	pass
