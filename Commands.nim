var commands* = ["help","download_game","install_game","uninstall_game","run","download_jre","install_jre","remove_download","change_proxy"]

# todo 把指定的命令绑定到指定的函数上面去
proc register_command*(p_command: string, p_proc: string) =
  
  discard