import std/[asyncdispatch, httpclient]
import std/os
import zippy/ziparchives

proc download_jre*(version:string) = 
  # 此处直接使用官方启动器的jre11版本
  if version == "11":
    var client = newHttpClient()
    echo "开始下载jre11 请稍等..."
    var content = client.getContent("https://download.bell-sw.com/java/11.0.16.1+1/bellsoft-jre11.0.16.1+1-windows-amd64.zip")
    writefile("download/jre11.zip", content)
    echo "下载完成"

proc resolve_jre*(version:string) = 
  var zip = "download/jre" & version & ".zip"
  var outDir = "jre/" & version
  echo "解压中..."
  extractAll(zip, outDir)
  echo "安装完成"

# 此处使用github加速代理服务 如果下载失败，请打开浏览器手动下载, https://ghproxy.com/
proc download_game*(version:string) = 
  var url_first = "https://ghproxy.com/"
  var url = url_first & "https://github.com/MovingBlocks/Terasology/releases/download/" & version & "/TerasologyOmega.zip"
  echo "正在下载请稍后..."
  echo url
  var client = newHttpClient()
  var content = client.getContent(url)
  var file = "download/" & version & "/TerasologyOmega.zip"
  writefile(file, content)

proc install_game*(version:string) = 
  echo "开始安装游戏: " & version
  var zip = "download/" & version & "/TerasologyOmega.zip"
  var outDir = "games/" & version
  extractAll(zip, outDir)
  echo "游戏安装完成: " & version