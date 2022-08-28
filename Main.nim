import std/os
#import wNim
import std/asyncdispatch
import DownloadManager
import GameManager

var params = commandLineParams()
if len(params) == 0:
  echo "错误，未输入参数！请输入help获取帮助！"

if params[0] == "help":
  echo "欢迎使用本启动器 下面是使用说明"
  echo "可以使用的参数列表 \n"

  echo "init: 初始化启动器"
  echo "例子: init \n"

  echo "change_proxy: 更改在线代理"
  echo "例子: change_proxy fastgithub \n"
  
  echo "download_jre: 下载java"
  echo "例子: download_jre 8 \n"

  echo "install_jre: 安装java"
  echo "例子: install_jre 8 \n"

  echo "download_game: 下载游戏" 
  echo "例子: download_game v3.0.0 \n"

  echo "install_game: 安装游戏"
  echo "例子: install_game v3.0.0 \n"

  echo "help: 获取帮助"
  echo "例子: help"

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

proc cant_run() = 
  echo "此版本无法启动！"

# 在这里启动游戏
proc run(p_version:string) = 
  setCurrentDir("games/" & p_version & "/libs")
  discard execShellCmd("Terasology.jar")

if params[0] == "run":
  var use_javaw = false
  var version = params[1]

  if version == "v5.2.0": cant_run()
  if version == "v4.3.0": cant_run()
  if version == "v4.2.0": cant_run()
  if version == "v3.2.0": run(version)
  if version == "v3.0.0": run(version)
  if version == "v2.0.0": run(version)
  if version == "v1.6.0": run(version)
  if version == "v1.3.0": run(version)

if params[0] == "list_installed":
  list_installed()

if params[0] == "uninstall_game":
  var version = params[1]
  uninstall_game(version)

if params[0] == "remove_download":
  var p_type = params[1]
  var p_version = params[2]
  remove_download(p_type, p_version)