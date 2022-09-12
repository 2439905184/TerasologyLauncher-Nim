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
	switch_show($Panel/OssDep)

func _on_Help_pressed():
	switch_show($Panel/Help)

func _on_Download_pressed():
	switch_show($Panel/Mirror)
	pass
	
# 用于重构的切换显示函数，一次只能切换显示一个节点
func switch_show(p_node):
	var all_node = [$Panel/Help,$Panel/Mirror,$Panel/OssDep,]
	for node in all_node:
		p_node.show()
		if node != p_node:
			node.hide()
	pass

func _on_Back_pressed():
	self.hide()
