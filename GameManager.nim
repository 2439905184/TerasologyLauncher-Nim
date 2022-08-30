import os
import Utils

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

proc unpack*(version: string): int = 
  var zip = downloadPath & version & "/" & gameName
  var exitCode = execShellCmd("Unpacker.exe " & zip & " " & "cache/" & version)
  return exitCode

# path是官方启动器根目录
proc install_offical*(version: string, path: string) = 
  echo "开始安装"
  var zip = downloadPath & version & "/" & gameName
  # 这么做是因为aardio unicode编码问题
  var srcDir = "cache/" & version
  var outDir = path
  if dirExists("cache/" & version):
    echo "缓存完毕，开始复制"
    copyDir(srcDir,outDir & "/test")
    echo "复制完毕"