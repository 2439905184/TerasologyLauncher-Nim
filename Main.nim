import std/os
#import wNim
import download

# let app = App()
# let frame = Frame(title="Launcher", size=(800,600))
# let panel = Panel(frame)

# proc on_run_pressed() = 
#   MessageDialog(frame, "Hello World", "MessageDialog").display()

# proc on_download_pressed() = 
#   #download_jre(frame)
#   #let ReleaseCheckBox = CheckBox(frame, label="正式版")
#   #let TestCheckBox = CheckBox(frame, lable="测试版")
#   #style=wLcSingleSel
#   let FilterHBox = ListCtrl(frame, pos=(50,0))
#   FilterHBox.init(frame)
#   FilterHBox.appendItem("正式版")
#   FilterHBox.appendItem("测试版")
#   #ReleaseCheckBox.position = ()
#   #TestCheckBox.position = ()

# proc layout() = 
#   let ButtonGame = Button(panel, label="下载")
#   let ButtonRun = Button(panel, label="启动游戏")
#   ButtonRun.position = (0, 100)
#   ButtonGame.connect(wEvent_LeftDown, on_download_pressed)
#   ButtonRun.connect(wEvent_LeftDown, on_run_pressed)
# layout()


# frame.center()
# frame.show()
# app.mainLoop()

proc setup_version(version:string) = 
  var path = "games/" & version

proc unzip() = 

  discard

proc run() = 

  discard execShellCmd("java.exe -jar D:/work/myTerasologyLauncher/dist/games/libs/Terasology.jar")

var params = commandLineParams()

if params[0] == "download":
  var version = params[1]
  setup_version(version)
  download_game(version)
  discard