import std/[asyncdispatch, httpclient]
import std/json
import std/os
import std/strformat

const fastgit_release = "MovingBlocks/Terasology/releases/download/"
const github_release = "https://github.com/MovingBlocks/Terasology/releases/download/"
var download_version = ""
var proxy_fastgithub = "https://hub.fastgit.xyz/"
var proxy_ghproxy* = "https://ghproxy.com/"
const lanzou_api1 = "https://www.youwk.cn/api/lanzou"
var select_proxy = proxy_ghproxy #用户选择的代理 默认为ghproxy

type
  DownloadInfo* = object # 存储下载信息
    content_type*, download_url*: string
    size*: int
  ReleaseData* = object # 存储发布的数据
    tag_name*, name*, published_at*: string
    downloadInfos*: seq[DownloadInfo]

proc onProgressChanged(total, progress, speed: BiggestInt) = 
  echo("Downloaded ", progress, " of ", total)
  echo("Current rate: ", speed div 1000, "kb/s")

proc download_jre*(version:string) = 
  # 此处直接使用官方启动器的jre11版本
  if version == "11":
    var client = newHttpClient()
    echo "开始下载jre11 请稍等..."
    client.onProgressChanged = onProgressChanged
    var content = client.getContent("https://download.bell-sw.com/java/11.0.16.1+1/bellsoft-jre11.0.16.1+1-windows-amd64.zip")
    writefile("download/jre11.zip", content)
    echo "下载完成"
  if version == "8": 
    var url = "https://objects.githubusercontent.com/github-production-release-asset-2e65be/372924428/5c3e51b9-d2fb-4baf-9cf4-c6de7698a210?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20220827%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20220827T042433Z&X-Amz-Expires=300&X-Amz-Signature=d61468e10cd20d0b452f4f2b33f40ae533b849ec9b4b5b2a2e9344a59050b284&X-Amz-SignedHeaders=host&actor_id=29478722&key_id=0&repo_id=372924428&response-content-disposition=attachment%3B%20filename%3DOpenJDK8U-jre_x64_windows_hotspot_8u345b01.zip&response-content-type=application%2Foctet-stream"
    var url2 = "https://download.bell-sw.com/java/8u345+1/bellsoft-jre8u345+1-windows-amd64.zip"
    var oracle_java8 = "https://sdlc-esd.oracle.com/ESD6/JSCDL/jdk/8u341-b10/424b9da4b48848379167015dcc250d8d/jre-8u341-windows-x64.exe?GroupName=JSC&FilePath=/ESD6/JSCDL/jdk/8u341-b10/424b9da4b48848379167015dcc250d8d/jre-8u341-windows-x64.exe&BHost=javadl.sun.com&File=jre-8u341-windows-x64.exe"
    const origin_lanzou = "https://wwp.lanzouy.com/i2Tl90ar0d5g"
    if fileExists("download/jre8.exe"): echo "文件已存在"
    else:
      echo "下载网站: " & oracle_java8 
      echo "开始下载jre8 请稍等..."
      var client = newHttpClient()
      client.onProgressChanged = onProgressChanged
      try:
        var content = client.getContent(oracle_java8)
        writefile("download/jre8.exe", content)
        echo "下载完成"
      except HttpRequestError:
        echo "尝试从oracle下载jre失败！"
        echo "你可以前往oracle手动下载"
        echo "https://www.java.com/zh-CN/"
        echo "切换到nya盘 下载中 请稍等..."
        var c = newHttpClient()
        var u = "https://pan.nyaku.moe/api/v3/file/source/5616/jre-8u341-windows-x64.exe?sign=a7oXRML6TZ_H7jAjoC81pUJN-dFASWW633Sq9F-kVQU%3D%3A0"
        var uu = "https://things.nyapan.mouup.top/personal/schuyi_iamswlx_onmicrosoft_com/_layouts/15/download.aspx?UniqueId=f57195ca-603d-4267-b40a-91532584bd72&Translate=false&tempauth=eyJ0eXAiOiJKV1QiLCJhbGciOiJub25lIn0.eyJhdWQiOiIwMDAwMDAwMy0wMDAwLTBmZjEtY2UwMC0wMDAwMDAwMDAwMDAvaWFtc3dseC1teS5zaGFyZXBvaW50LmNvbUAyYmE5YzYwOC1mMzEwLTRjOTItODNmOC1kMjY2MzZmMDY2MmYiLCJpc3MiOiIwMDAwMDAwMy0wMDAwLTBmZjEtY2UwMC0wMDAwMDAwMDAwMDAiLCJuYmYiOiIxNjYxOTk1NDY2IiwiZXhwIjoiMTY2MTk5OTA2NiIsImVuZHBvaW50dXJsIjoiNzFudzhITS9PZDIwRloxdlRwY0RRVnNnOUVJUTNsdCtXMTdQRStQSUtybz0iLCJlbmRwb2ludHVybExlbmd0aCI6IjE2MSIsImlzbG9vcGJhY2siOiJUcnVlIiwiY2lkIjoiTXpKbU56a3dZekV0TURBMlpTMDBaVE00TFdJNU5HVXRPREkwTm1ZeFlUTXhaVGs0IiwidmVyIjoiaGFzaGVkcHJvb2Z0b2tlbiIsInNpdGVpZCI6Ik9UaG1aalV3T1dRdE9USTNaQzAwWm1JM0xUZzRNR0l0WXpZeVkyVmlOVGs0TkRsbSIsImFwcF9kaXNwbGF5bmFtZSI6Im55YXBhbiIsImdpdmVuX25hbWUiOiLpm6rkuIAiLCJmYW1pbHlfbmFtZSI6IuS4gOS5i-a_kSIsImFwcGlkIjoiYWU1NzQyNTMtY2I3ZC00OTAxLWIxZGItMDc1NmQyOGE1ZTVjIiwidGlkIjoiMmJhOWM2MDgtZjMxMC00YzkyLTgzZjgtZDI2NjM2ZjA2NjJmIiwidXBuIjoic2NodXlpQGlhbXN3bHgub25taWNyb3NvZnQuY29tIiwicHVpZCI6IjEwMDMyMDAxQzdFNTE3NjUiLCJjYWNoZWtleSI6IjBoLmZ8bWVtYmVyc2hpcHwxMDAzMjAwMWM3ZTUxNzY1QGxpdmUuY29tIiwic2NwIjoiYWxsZmlsZXMud3JpdGUiLCJ0dCI6IjIiLCJ1c2VQZXJzaXN0ZW50Q29va2llIjpudWxsLCJpcGFkZHIiOiIyMC4xOTAuMTQ0LjE3MSJ9.RlEvdjI5Z1lXQmtxR1ZYQUg3M3V4eGorY0NHdEtscHhyeTYrRjR6VzNFZz0&ApiVersion=2.0"
        var d = c.getContent(uu)
        c.onProgressChanged = onProgressChanged
        writefile("download/jre8.exe",d)
        echo "下载完成"
        # 需要签名校验
        # echo "切换到蓝奏云解析"
        # var lanzou_java8 = lanzou_api1 & "?key=leJlQOEoNCkIgKbSOU8UUTfDg1xjFD&url=https://wwp.lanzouy.com/i2Tl90ar0d5g"
        # var content = client.getContent(lanzou_java8)
        # var parsed_json = parseJson(content)
        # if parsed_json["msg"].getStr() == "请求成功":
        #   var d_url = parsed_json["data"]["dom"].getStr()
        #   echo "下载地址"
        #   echo d_url
        #   var client_lanzou = newHttpClient()
        #   client_lanzou.onProgressChanged = onProgressChanged
        #   var content_jre = client_lanzou.getContent(d_url)
        #   writefile("download/jre.exe",content_jre)
        #   echo "下载完成"
        # else:
        #   echo "蓝奏云解析失败 请手动下载"
        #   echo origin_lanzou

proc install_jre*(version:string) = 
  # 用于安装其他版本的保留代码
  #var zip = "download/jre" & version & ".zip"
  #var outDir = "jre/" & version
  setCurrentDir("download")
  discard execShellCmd("jre8.exe")
  echo "安装完成"

proc async_get(url: string): Future[string] {.async.} =
  var client = newAsyncHttpClient()
  return await client.getContent(url)

proc get_release_datas*(): seq[ReleaseData] =
  var json_raw: string = waitFor async_get("https://api.github.com/repos/MovingBlocks/Terasology/releases")
  var parsed_json = parseJson(json_raw)
  var release_datas: seq[ReleaseData]
  for release_item in parsed_json:
    var 
      assets_node: JsonNode
      download_infos: seq[DownloadInfo]
    assets_node = release_item["assets"]
    for asset_item in assets_node:
      download_infos.add(DownloadInfo(content_type : asset_item["content_type"].getStr(), 
                                    download_url : asset_item["browser_download_url"].getStr(), 
                                    size : asset_item["size"].getInt()))
    release_datas.add(ReleaseData(tag_name : release_item["tag_name"].getStr(), 
                                name : release_item["name"].getStr(), 
                                published_at : release_item["published_at"].getStr(),
                                downloadInfos : download_infos))
  return release_datas
  
# 下载游戏
proc download_game*(version:string) = 
  var url = ""
  echo "开始下载游戏"
  select_proxy = readfile("proxy.txt")
  echo "你选择的代理为: " & select_proxy
  if select_proxy == proxy_fastgithub:
    url = select_proxy & fastgit_release & version & "/TerasologyOmega.zip"
  if select_proxy == proxy_ghproxy:
    url = select_proxy & github_release & version & "/TerasologyOmega.zip"
  if fileExists("download/" & version & "/TerasologyOmega.zip"): echo "文件已存在 跳过下载"
  else:
    echo "正在下载: " & url
    var client = newHttpClient()
    client.onProgressChanged = onProgressChanged
    var content = client.getContent(url)
    var file = "download/" & version & "/TerasologyOmega.zip"
    writefile(file, content)
    echo "下载完成"

proc write_proxy*(p_proxy:string) = 
  writefile("proxy.txt", p_proxy)

proc change_proxy*(proxy:string):bool = 
  if proxy == "fastgithub":
    select_proxy = proxy_fastgithub
    echo "切换代理为:" & select_proxy
    write_proxy(select_proxy)
    return true
  if proxy == "ghproxy":
    select_proxy = proxy_ghproxy
    echo "切换代理为:" & select_proxy
    write_proxy(select_proxy)
    return true
  else:
    return false

proc remove_download*(p_type: string, version: string) = 
  if p_type == "game":
    removeDir("download/" & version)
    echo "游戏: " & version & "移除完成"
  if p_type == "jre":
    if version == "8":
      removeFile("download/" & "jre" & version & ".exe")
      echo "java: " & version & "移除完成"
