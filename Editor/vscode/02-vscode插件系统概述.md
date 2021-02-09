# vscode 插件系统概述

扩展是为了帮助我们更好的工作，扩展的原则如下：

-   扩展越少，编辑器越流畅
-   编辑器已经自带的，就不要重复安装
-   扩展部分功能与编辑器重复，应该禁用掉编辑器自带功能
-   对编辑器负荷很大的插件，尽量少安装，平时不用，可以先禁用掉

主题扩展列表

| 主题         | 描述     |
| ------------ | -------- |
| One Dark Pro | 暗系主题 |
| vscode-icons | 图标高亮 |

通用扩展列表

| 通用插件                     | 描述                   |
| ---------------------------- | ---------------------- |
| vscode-language-pack-zh-hans | 中文语言包             |
| EditorConfig                 | 编码格式管理           |
| Perttier                     | 格式化工具             |
| path-intellisense            | 路径补全               |
| gitlens                      | git 管理插件           |
| Bracket Pair Colorizer 2     | 括号高亮               |
| todo-tree                    | Todo 树                |
| Neo Vim                      | nvim 集成              |
| project-manager              | 项目管理               |
| hexdump for VSCode           | 十六进制文件预览与编辑 |
| Bookmarks                    | 书签                   |
| Better Align                 | 符号对齐               |
| highlight-words              | 词组高亮               |
| Partial Diff                 | 选中对比               |
| Settings Sync                | 设置同步               |

PHP 插件

| PHP 插件         | 描述    |
| ---------------- | ------- |
| PHP Intelephense | php ide |

## vscode-neovim

vscode-neovim 扩展相对复杂，具体操作如下：

1. 安装 vscode 扩展：Neo Vim
2. 桌面系统安装：NeoVim 编辑器
3. vscode 绑定 NeoVim 编辑器，settings.json 具体设置如下：

    ```json
    [
        {
            // windows系统下vscode-neovim扩展绑定neovim编辑器路径
            "vscode-neovim.neovimExecutablePaths.win32": "C:\\Neovim\\bin\\nvim.exe"
        }
    ]
    ```

## Perttier

Perttier 是下载量最高的格式化工具，支持格式化 html、js、css 及其衍生语言、markdown

-   默认 `tab=2空格`，通常我们需要修改成 `tab=4空格`

    ```json
    [
        {
            // prettier 的tab对应空格数与vscode的tab空格数保持一致
            "prettier.tabWidth": 4
        }
    ]
    ```
