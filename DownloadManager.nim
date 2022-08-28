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
  if version == "8":
    var url = "https://objects.githubusercontent.com/github-production-release-asset-2e65be/372924428/5c3e51b9-d2fb-4baf-9cf4-c6de7698a210?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20220827%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20220827T042433Z&X-Amz-Expires=300&X-Amz-Signature=d61468e10cd20d0b452f4f2b33f40ae533b849ec9b4b5b2a2e9344a59050b284&X-Amz-SignedHeaders=host&actor_id=29478722&key_id=0&repo_id=372924428&response-content-disposition=attachment%3B%20filename%3DOpenJDK8U-jre_x64_windows_hotspot_8u345b01.zip&response-content-type=application%2Foctet-stream"
    var url2 = "https://download.bell-sw.com/java/8u345+1/bellsoft-jre8u345+1-windows-amd64.zip"
    var oracle_java8 = "https://sdlc-esd.oracle.com/ESD6/JSCDL/jdk/8u341-b10/424b9da4b48848379167015dcc250d8d/jre-8u341-windows-x64.exe?GroupName=JSC&FilePath=/ESD6/JSCDL/jdk/8u341-b10/424b9da4b48848379167015dcc250d8d/jre-8u341-windows-x64.exe&BHost=javadl.sun.com&File=jre-8u341-windows-x64.exe&AuthParam=1661583920_cebb5021fd2bf5b680b3a02b9111e114&ext=.exe"
    echo "下载网站: " & oracle_java8 
    echo "开始下载jre8 请稍等..."
    var client = newHttpClient()
    client.onProgressChanged = onProgressChanged
    # 此版本jre无法运行游戏
    var content = client.getContent(oracle_java8)
    writefile("download/jre8.exe", content)
    echo "下载完成"

proc install_jre*(version:string) = 
  var zip = "download/jre" & version & ".zip"
  var outDir = "jre/" & version
  # echo "解压中..."
  # discard execShellCmd("Unpacker.exe " & zip & " " & outDir)
  # echo "安装完成"
  setCurrentDir("download")
  discard execShellCmd("jre8.exe")

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
