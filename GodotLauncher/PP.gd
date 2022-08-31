extends Panel

func _ready():
	$Panel/OssDep/Godot/View.connect("pressed",self,"go_godot")
	$Panel/OssDep/TerasologyNim/View.connect("pressed",self,"go_TerasologyLauncherNim")
	pass

func go_godot():
	OS.shell_open("https://godotengine.org")
	pass
	
func go_TerasologyLauncherNim():
	OS.shell_open("https://github.com/2439905184/TerasologyLauncher-Nim")
	pass

func _on_About_pressed():
	$Panel/OssDep.show()
	$Panel/Help.hide()
	$Panel/Mirror.hide()
	pass

func _on_Help_pressed():
	$Panel/Help.show()
	$Panel/OssDep.hide()
	$Panel/Mirror.hide()
	pass

func _on_Download_pressed():
	$Panel/Mirror.show()
	$Panel/OssDep.hide()
	$Panel/Help.hide()
	pass
	
# 用于重构的切换显示函数，一次只能切换显示一个节点
func switch_show(node):
	var all_node = [$Panel/Help,$Panel/Mirror,$Panel/OssDep]
	for iter in node:
		
		pass
	pass

func _on_Back_pressed():
	self.hide()
	pass
