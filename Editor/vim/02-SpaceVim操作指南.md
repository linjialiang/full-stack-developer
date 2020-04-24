# SpaceVim 操作指南

本教程是在 SpaceVim 官方文档外，做一些细节的操作说明。

> 题外话：建议 SpaceVim 应用于 Linx 下，Windows 下的 SpaceVim 有各种问题

## 一、安装 NeoVim

Debian 系统安装 NeoVim 很简单，只需要如下指令：

```sh
$ apt install neovim
```

> 提示：NeoVim 使用上与 vim 基本相同

## 二、为终端开启 256 色彩

Debian 服务器默认终端为 8 色，为更好的使用 SpaceVim，我们需要为终端开启 256 真色

> 提示：Windows 上的终端工具通常不支持真色，如果只是通过 xshell 连接就不必开启了。但是像 gnome-terminal 等 Unix 上的终端工具，通常都能支持真色！

1. 安装 xterm-256color

    Linux 服务器通常都自带 `xterm-256color` 终端，如果不支持，就需要手动安装：

    ```sh
    $ apt install ncurses-base
    ```

2. 查看当前终端信息：

    | 信息     | 指令         |
    | -------- | ------------ |
    | 终端类型 | `echo $TERM` |
    | 终端色彩 | tput colors  |

3. 配置 .bashrc 文件

    配置 Linux 终端如果支持就调整为 256 色终端，添加到.bashrc 文件内：

    ```sh
    $ vim ~/.bashrc
    ```

    .bashrc 增加如下代码：

    ```sh
    if [ -e /lib/terminfo/x/xterm-256color ]; then
            export TERM='xterm-256color'
    else
            export TERM='xterm-color'
    fi
    ```

> 最后执行 `source ~/.bashrc` 使修改生效

## 三、安装 SpaceVim

Debian 上安装操作如下：

1. 安装前的准备工作

    安装 SpaceVim 前，需要先安装如下包，及其以来项目：

    ```sh
    $ apt curl git npm python python3
    ```

2. 安装指令

    ```sh
    $ curl -sLf https://spacevim.org/cn/install.sh | bash
    ```

    如果需要获取安装脚本的帮助信息，可以执行如下命令：

    ```sh
    $ curl -sLf https://spacevim.org/cn/install.sh | bash -s -- -h
    ```

## 四、配置 SpaceVim

    ```vim
    [options]
        colorscheme = "onedark"
        colorscheme_bg = "dark"
        enable_guicolors = false
        statusline_separator = "arrow"
        statusline_inactive_separator = "arrow"
        buffer_index_type = 4
        enable_tabline_filetype_icon = true
        enable_statusline_mode = false
    [[layers]]
    name = 'autocomplete'
    auto_completion_return_key_behavior = "complete"
    auto_completion_tab_key_behavior = "smart"
    [[layers]]
    name = 'shell'
    default_position = 'top'
    default_height = 30
    [[layers]]
    name = "VersionControl"
    [[layers]]
    name = "git"
    [[layers]]
    name = 'chinese'
    [[layers]]
    name = 'colorscheme'
    [[layers]]
    name = 'lang#html'
    [[layers]]
    name = 'lang#javascript'
    [[layers]]
    name = 'lang#php'
    [[layers]]
    name = 'lang#sh'
    [[layers]]
    name = 'lang#vim'
    [[layers]]
    name = 'lang#vue'
    ```

## 五、SpaceVim 常用快捷键

| 快捷键             | 描述                                 |
| ------------------ | ------------------------------------ |
| :SPUpdate SpaceVim | 通过插件管理器更新                   |
| :SPUpdate          | 更新所有插件，包括 SpaceVim 自身     |
| \ -                | 切换到前一个标签（其实是缓冲区）     |
| \ +                | 切换到后一个标签（其实是缓冲区）     |
| \ {1-9}            | 切换到指定数字的标签（其实是缓冲区） |
| SPC b d            | 删除当前标签（其实是缓冲区）         |
| SPC {1-9}          | 切换到指定数字的窗口                 |
