import std/[asyncdispatch, httpclient]
import std/json
import std/os
#import wNim
import zippy/ziparchives

type
  DownloadInfo* = object # 存储下载信息
    content_type*, download_url*: string
    size*: int
  ReleaseData* = object # 存储发布的数据
    tag_name*, name*, published_at*: string
    downloadInfos*: seq[DownloadInfo]

proc download_jre*(version:string) = 
  
  discard

proc resolve_jre*(version:string) = 
  var zip = "download/jre.zip"
  echo "解压中..."
  extractAll(zip, "jre/" & version)
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
  
# 此处使用github加速代理服务 如果下载失败，请打开浏览器手动下载, https://ghproxy.com/

proc download_game*(version:string) = 
  var url_first = "https://ghproxy.com/"
  var url = url_first & "https://github.com/MovingBlocks/Terasology/releases/download/" & version & "/TerasologyOmega.zip"
  echo "正在下载请稍后..."
  echo url
  var client = newHttpClient()
  var content = client.getContent(url)
  writefile("games/" & version & "/TerasologyOmega.zip", content)
