import std/[asyncdispatch, httpclient]
import std/json
import std/os
import std/strformat

const fastgit_release = "MovingBlocks/Terasology/releases/download/"
const github_release = "https://github.com/MovingBlocks/Terasology/releases/download/"
var download_version = ""
var proxy_fastgithub = "https://hub.fastgit.xyz/"
var proxy_ghproxy* = "https://ghproxy.com/"
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

proc install_jre*(version:string) = 
  var zip = "download/jre" & version & ".zip"
  var outDir = "jre/" & version
  echo "解压中..."
  discard execShellCmd("Unpacker.exe " & zip & " " & outDir)
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
  echo "正在下载: " & url

  var client = newHttpClient()
  client.onProgressChanged = onProgressChanged
  var content = client.getContent(url)
  var file = "download/" & version & "/TerasologyOmega.zip"
  writefile(file, content)

proc install_game*(version:string) = 
  echo "开始安装游戏: " & version
  echo "调用aardio的外部解压器！"
  var zip = "download/" & version & "/TerasologyOmega.zip"
  var outDir = "games/" & version
  var result = execShellCmd("Unpacker.exe " & zip & " " & outDir)
  echo "游戏安装完成: " & version

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