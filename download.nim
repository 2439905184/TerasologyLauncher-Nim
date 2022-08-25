import std/[asyncdispatch, httpclient]
import std/os
#import wNim


# var versions = ["v5.0.0","v5.2.0"]
# var sel_version = "0"
# #waitFor asyncProc()
# #asyncProc()
# echo "下载中: " & url
# echo "如果下载失败，请打开浏览器手动下载, https://ghproxy.com/"


# proc download_jre*(frame:wFrame) = 
#   #MessageDialog(frame, "Hello World", "MessageDialog").display()
#   discard

proc download_jre() = 

  discard
# 此处使用github加速代理服务
proc download_game*(version:string) = 
  var url_first = "https://ghproxy.com/"
  var url = url_first & "https://github.com/MovingBlocks/Terasology/releases/download/" & version & "/TerasologyOmega.zip"
  echo "正在下载请稍后..."
  echo url
  var client = newHttpClient()
  var content = client.getContent(url)
  writefile("games/" & version & "/TerasologyOmega.zip", content)