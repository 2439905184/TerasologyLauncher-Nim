import std/strutils

proc myToUnixPath*(path: string): string = 
  return path.replace("\\", "/")