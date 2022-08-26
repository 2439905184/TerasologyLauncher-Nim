import std/os
#import wNim
import download
import zippy/ziparchives

proc setup_version(version:string) = 
  var path = "games/" & version

var params = commandLineParams()

if params[0] == "download":
  var version = params[1]
  setup_version(version)
  #download_game(version)

if params[0] == "install_jre":
  var version = params[1]
  download_jre(version)
  resolve_jre(version)
  
if params[0] == "install_game":
  var version = params[1]
  install_game(version)

if params[0] == "run":
  var version = params[1]
  
  var java = absolutePath("jre/11/jre-11.0.16.1/bin/java.exe")
  #echo java
  setCurrentDir("jre/11/jre-11.0.16.1/bin")
  var success = execShellCmd("java.exe -jar D:/work/myTerasologyLauncher/dist/games/" & version & "/libs/Terasology.jar")
  if success == 0:
    echo "游戏启动失败或者进程已结束！"