import std/[asyncdispatch, httpclient]
import std/os
#import wNim
import zippy/ziparchives

proc download_jre*(version:string) = 
  
  discard

proc resolve_jre*(version:string) = 
  var zip = "download/jre.zip"
  echo "解压中..."
  extractAll(zip, "jre/" & version)
  echo "安装完成"

# 此处使用github加速代理服务 如果下载失败，请打开浏览器手动下载, https://ghproxy.com/
proc download_game*(version:string) = 
  var url_first = "https://ghproxy.com/"
  var url = url_first & "https://github.com/MovingBlocks/Terasology/releases/download/" & version & "/TerasologyOmega.zip"
  echo "正在下载请稍后..."
  echo url
  var client = newHttpClient()
  var content = client.getContent(url)
  writefile("games/" & version & "/TerasologyOmega.zip", content)