import std/[asyncdispatch, httpclient]
import std/json
import std/os
#import wNim
import zippy/ziparchives

type
  DownloadInfo* = object # 存储下载信息
    content_type*, download_url*: string
    size: int
  ReleaseData* = object # 存储发布的数据
    tag_name*, name*, published_at*: string
    downloadInfos: seq[DownloadInfo]

proc download_jre*(version:string) = 
  
  discard

proc resolve_jre*(version:string) = 
  var zip = "download/jre.zip"
  echo "解压中..."
  extractAll(zip, "jre/" & version)
  echo "安装完成"

proc asyncGet(url: string): Future[string] {.async.} =
  var client = newAsyncHttpClient()
  return await client.getContent(url)

proc getReleaseDatas(): seq[ReleaseData] =
  var jsonRaw: string = waitFor asyncGet("https://api.github.com/repos/MovingBlocks/Terasology/releases")
  var parsedJson = parseJson(jsonRaw)
  var releaseDatas: seq[ReleaseData]
  for releaseItem in parsedJson:
    var 
      assetsNode: JsonNode
      downloadInfos: seq[DownloadInfo]
    assetsNode = releaseItem["assets"]
    for assetItem in assetsNode:
      downloadInfos.add(DownloadInfo(content_type : assetItem["content_type"].getStr(), 
                                    download_url : assetItem["browser_download_url"].getStr(), 
                                    size : assetItem["size"].getInt()))
    releaseDatas.add(ReleaseData(tag_name : releaseItem["tag_name"].getStr(), 
                                name : releaseItem["name"].getStr(), 
                                published_at : releaseItem["published_at"].getStr(),
                                downloadInfos : downloadInfos))
  return releaseDatas
  
# 此处使用github加速代理服务 如果下载失败，请打开浏览器手动下载, https://ghproxy.com/

proc download_game*(version:string) = 
  var url_first = "https://ghproxy.com/"
  var url = url_first & "https://github.com/MovingBlocks/Terasology/releases/download/" & version & "/TerasologyOmega.zip"
  echo "正在下载请稍后..."
  echo url
  var client = newHttpClient()
  var content = client.getContent(url)
  writefile("games/" & version & "/TerasologyOmega.zip", content)
