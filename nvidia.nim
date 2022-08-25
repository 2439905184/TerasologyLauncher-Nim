import std/os

const nv1 = "C:/ProgramData/NVIDIA Corporation/Drs/nvdrsdb0.bin"
const nv2 = "C:/ProgramData/NVIDIA Corporation/Drs/nvdrsdb1.bin"

# 修复nvidia控制面板闪退问题 https://www.bilibili.com/video/av933054473
proc backup() = 
  copyFile(nv1,"backup/nvdrsdb0.bin.bak")
  copyFile(nv2,"backup/nvdrsdb1.bin.bak")

proc recovery() = 
  
  discard

proc fix_crash() = 
  backup()
  removeFile(nv1)
  removeFile(nv2)
  