# gvim 使用指南

vim 是跨平台的编辑器，非常古老，却又是程序员必不可少的一款编辑器，而 gvim 是 vim 的 GUI 版。

## 一、安装 gvim

1. Debian 下安装 vim

   通常 Debian 是以服务器的形式出现，所以我们一般只安装 vim 即可：

   ```sh
   $ apt install vim vim-scripts
   ```

2. Windows 下安装 gvim

   Windows 下主要使用的是 gvim：

   | 安装步骤 | 具体操作                                                                                         |
   | -------- | ------------------------------------------------------------------------------------------------ |
   | 01       | 去 [vim-win32](https://github.com/vim/vim-win32-installer/releases) 下载最新版的 gvim.exe 安装包 |
   | 02       | 双击 `gvim_8.2.0368_x64.exe` 选择完全安装，其它选项默认即可                                      |

## 二、安装中文帮助手册

中文帮助手册下载地址

| 系统    | 对应软件包                                                                      |
| ------- | ------------------------------------------------------------------------------- |
| Debian  | [`vimcdoc-*.tar.gz`](https://github.com/yianwillis/vimcdoc/releases)            |
| Windows | [`vimcdoc-*-setup-unicode.exe`](https://github.com/yianwillis/vimcdoc/releases) |

1. Debian 下安装中文帮助手册

   ```sh
   $ tar -xzvf vimcdoc-*.tar.gz
   $ cd vimcdoc-*
   $ chmod +x vimcdoc.sh
   # 英文手册不受影响
   $ ./vimcdoc.sh -i
   # 缺省安装，覆盖英文手册
   $ ./vimcdoc.sh -I
   ```

2. Windwos 下安装中文帮助手册

   Windwos 系统安装更加简单，双击 `vimcdoc-\*-setup-unicode.exe` 即可！

## 三、配置 gvim

vim/gvim 的配置直接使用 [大神的配置](https://github.com/linjialiang/vimrc.git) 即可！

1. Debian 下配置 vim

   通常 Debian 是以服务器的形式出现，所以我们一般只 vim 基础配置，不需要配置插件：

   ```sh
   $ git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
   $ ~/.vim_runtime/install_basic_vimrc.sh
   ```

2. Windows 下配置 gvim

   Windows 下推荐使用 git 的 `sh工具(git-bash.exe)`，具体操作如下：

   ```sh
   $ git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
   $ ~/.vim_runtime/install_awesome_vimrc.sh
   ```

3. 安装 `IBM-Plex-Mono` 字体

   该配置推荐使用 IBM-Plex-Mono 字体，具体操作：

   | 系统     | 具体操作                                                                   |
   | -------- | -------------------------------------------------------------------------- |
   | Windows  | 直接安装 `otf/ttf` 字体即可                                                |
   | 远程 vim | 本地安装 `otf/ttf` 字体后，在 xshell 等终端工具中设置字体为`IBM-Plex-Mono` |

## 四、更新 `vim/gvim` 配置

不同的配置更新方式也有所区别：

| 配置     | 更新方式                                                       |
| -------- | -------------------------------------------------------------- |
| 基础配置 | 没有插件，只需要通过 git 指令来更新源代码即可                  |
| 推荐配置 | 通过 git 指令更新源代码，通过 `update_plugins.py` 文件更新插件 |

1. 基础配置版：

   ```sh
   $ cd ~/.vim_runtime
   $ git pull --rebase
   ```

2. 推荐配置版：

   ```sh
   $ cd ~/.vim_runtime
   $ git pull --rebase
   # 单个 python 版本
   $ python ./update_plugins.py
   # 多个 python 版本
   $ python3 ./update_plugins.py
   ```

3. 为 python 导入 requests 库

   使用 `update_plugins.py` 更新插件时，会报错：

   ```sh
   $ python ./update_plugins.py
   Traceback (most recent call last):
     File "./update_plugins.py", line 12, in <module>
       import requests
   ModuleNotFoundError: No module named 'requests'
   ```

   这是由于 requests 库未导入，使用 pip 将其导入即可：

   ```sh
   $ pip install requests
   # 多个 python 时，python3 通常与 pip3 绑定 
   $ pip3 install requests
   ```
