import std/os
#import wNim
import std/asyncdispatch
import download

var params = commandLineParams()
if len(params) == 0:
  echo "错误，未输入参数！请输入help获取帮助！"

if params[0] == "help":
  echo "欢迎使用本启动器 下面是使用说明"
  echo "可以使用的参数列表 \n"
  echo "init: 初始化启动器，创建文件夹 \n"
  echo "download_game: 下载游戏"
  echo "例子: download_game v5.2.0 \n"
  echo "install_game: 安装游戏"
  echo "例子: install_game v5.2.0 \n"
  echo "download_jre: 下载java"
  echo "例子: download_jre 8 \n"
  echo "install_jre: 安装jre"
  echo "例子: install_jre 8"

if params[0] == "init":
  createDir("download")
  createDir("games")
  createDir("jre")
  write_proxy(proxy_ghproxy)

if params[0] == "change_proxy":
  var proxy = params[1]
  var result = change_proxy(proxy)
  if not result: echo "不存在此在线代理！"

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
  if version == "v5.2.0":
    # setCurrentDir("jre/11/offical-java11/jre/bin")
    discard execShellCmd("cd run &java.cmd")
    #discard execShellCmd("java.exe -jar " & "../../../..games/" & version & "/Terasology.jar")
  # setCurrentDir("jre/11/jre-11.0.16.1/bin")
  # var success = execShellCmd("java.exe -jar D:/work/myTerasologyLauncher/dist/games/" & version & "/libs/Terasology.jar")
  # var success = execShellCmd("java.exe -jar " & "../../../../games/" & version & "/libs/Terasology.jar")
  # if success == 0:
  #   echo "游戏启动失败或者进程已结束！"