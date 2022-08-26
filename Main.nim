import std/os
#import wNim
import std/asyncdispatch
import download

var params = commandLineParams()

if params[0] == "init":
  createDir("download")
  createDir("games")
  createDir("jre")

if params[0] == "download_game":
  var version = params[1]
  createDir("download/" & version)
  download_game(version)

if params[0] == "install_game":
  var version = params[1]
  install_game(version)

if params[0] == "download_jre":
  var version = params[1]
  download_jre(version)

if params[0] == "install_jre":
  var version = params[1]
  install_jre(version)

if params[0] == "run":
  var version = params[1]
  setCurrentDir("jre/11/jre-11.0.16.1/bin")
  # var success = execShellCmd("java.exe -jar D:/work/myTerasologyLauncher/dist/games/" & version & "/libs/Terasology.jar")
  var success = execShellCmd("java.exe -jar " & "../../../../games/" & version & "/libs/Terasology.jar")
  if success == 0:
    echo "游戏启动失败或者进程已结束！"