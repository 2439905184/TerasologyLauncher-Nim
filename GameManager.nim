import os

const downloadPath = "download/"
const gamePath = "games/"
const gameName = "TerasologyOmega.zip"

proc install_game*(version: string) = 
  echo "开始安装游戏: " & version
  echo "调用aardio的外部解压器！"
  var zip = downloadPath & version & "/" & gameName
  var outDir = gamePath & version
  var exitCode = execShellCmd("Unpacker.exe " & zip & " " & outDir)
  if exitCode == 0: echo "游戏安装完成: " & version
  else: echo "安装错误！代码: " & $exitCode

proc uninstall_game*(version: string) = 
  echo "开始卸载游戏:" & version
  var dir = gamePath & version
  removeDir(dir)
  echo "游戏卸载完成"

proc list_installed*() = 
  echo "已安装的游戏:"
  for game in walkDir("games"):
    echo game.path
# todo
proc install_offical*(version: string, path: string) = 
  echo "将游戏安装到官方启动器目录 用于解决疑难杂症"

  echo ""