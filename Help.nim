
proc show_help*() = 
  echo "欢迎使用本启动器 下面是使用说明"
  echo "可以使用的参数列表 \n"

  echo "help: 获取帮助"
  echo "例子: help \n"

  echo "init: 初始化启动器"
  echo "例子: init \n"

  echo "change_proxy: 更改在线代理"
  echo "例子: change_proxy fastgithub \n"

  echo "download_jre: 下载java"
  echo "例子: download_jre 8 \n"

  echo "install_jre: 安装java"
  echo "例子: install_jre 8 \n"

  echo "download_game: 下载游戏" 
  echo "例子: download_game v3.0.0 \n"

  echo "install_game: 安装游戏"
  echo "例子: install_game v3.0.0 \n"

  echo "install_offical: 安装游戏到官方目录 你需要先设置offical.json中的内容"
  echo "例子: install_offical v3.0.0 \n"
  
  echo "list_installed: 列出已安装的所有游戏"