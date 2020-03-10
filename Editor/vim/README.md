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
