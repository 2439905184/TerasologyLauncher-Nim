import std/os
#import wNim
#import download
import zippy/ziparchives

proc setup_version(version:string) = 
  var path = "games/" & version

proc run() = 
  discard execShellCmd("java.exe -jar D:/work/myTerasologyLauncher/dist/games/libs/Terasology.jar")

var params = commandLineParams()

if params[0] == "download":
  var version = params[1]
  setup_version(version)
  #download_game(version)

if params[0] == "install_jre":
  var version = params[1]
  #download_jre(version)
  #resolve_jre(version)
  echo "解压中..."
  extractAll("download/jre.zip", "jre/11")
  echo "安装完成"