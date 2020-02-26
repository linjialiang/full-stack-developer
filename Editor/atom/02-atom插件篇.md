# Atom 插件篇

Atom 有很多优秀的插件，我们这里只是讲解其中一部分插件，这些插件都是我经过长期使用得到的，并且可以很好的协作！

## atom 插件扩展

| 实用插件(10)            | 插件描述          |
| ----------------------- | ----------------- |
| atom-beautify           | 格式化源代码      |
| sync-settings           | atom 配置同步插件 |
| split-diff              | 文件对比插件      |
| project-manager         | 项目管理          |
| platformio-ide-terminal | atom 下出色的终端 |
| markdown-preview-plus   | markdown 预览     |
| language-markdown       | markdown 语法高亮 |
| file-icons              | 文件图标          |
| quick-highlight         | 文本快速高亮      |
| editorconfig            | 统一代码风格      |

| git 相关插件(3)      | 插件描述                                   |
| -------------------- | ------------------------------------------ |
| git-time-machine     | 近期提交的时间列表，并支持与当前内容做对比 |
| merge-conflicts      | 解决 Atom 中的 Git 合并冲突                |
| tree-view-git-status | 目录树里显示 Git 状态                      |

| minimap 相关插件(4)     | 插件描述                |
| ----------------------- | ----------------------- |
| minimap                 | 代码小窗口              |
| minimap-git-diff        | 代码小窗口-git 对比高亮 |
| minimap-split-diff      | 代码小窗口-对比高亮     |
| minimap-quick-highlight | 代码小窗口-快速高亮     |

| 语法相关插件(4) | 插件描述                |
| --------------- | ----------------------- |
| language-apache | apache 配置文件语法高亮 |
| language-nginx  | nginx 配置文件语法高亮  |
| language-ini    | ini 扩展文件语法高亮    |
| language-notenv | .env 扩展文件语法高亮   |

| vim 相关插件(3)  | 插件描述                   |
| ---------------- | -------------------------- |
| vim-mode-plus    | vim 插件基础包             |
| relative-numbers | vim 普通模式下显示先对行号 |
| ex-mode          | atom 下的 ex 单行编辑器    |

## 终端下对 `atom` 插件管理

| 说明     | 指令                                             |
| -------- | ------------------------------------------------ |
| 安装插件 | `apm install package1 [package2 package3 ...]`   |
| 卸载插件 | `apm uninstall package1 [package2 package3 ...]` |
| 移除插件 | `apm remove package1 [package2 package3 ...]`    |
| 禁用插件 | `apm disable package1 [package2 package3 ...]`   |
| 启用插件 | `apm enable package1 [package2 package3 ...]`    |

## 插件配置说明

### project-manager

`project-manager` 可以很好的管理我们的项目,更重要的是它可以让每个项目开启不同的插件组合

> 提示：事实上 project-manager 控制插件是不明智，因为 atom 首先会全部加载所有插件，然后再由 project-manager 开启 `devMode` 模式来禁用一些插件！

| 属性设置   | 属性值类型 | 描述              | 默认值                 |
| ---------- | ---------- | ----------------- | ---------------------- |
| `title`    | 字符串     | 项目标题          | `''`                   |
| `paths`    | 数组       | 视图中所有根目录  | `[]`                   |
| `settings` | 对象       | 特定项目的设置。  | `{}`                   |
| `icon`     | 字符串     | 项目列表中的图标  | `'icon-chevron-right'` |
| `devMode`  | 布尔值     | `true` 为开发模式 | `false`                |
| `group`    | 字符串     | 项目组            | `null`                 |
| `template` | 字符串     | 项目模板          | `null`                 |

> 常规案例：

```cson
[
    {
      title: 'Project Manager1'
      group: 'Atom'
      paths: [
        '/path/to/project-manager-1'
      ]
      icon: 'atom-icon'
      color: '#8892BF'
      devMode: ture
    }
    {
      title: 'Project Manager2'
      group: 'github'
      paths: [
        '/path/to/project-manager-2'
      ]
      icon: 'github-icon'
      color: 'green'
    }
]
```

> `icon` 的属性值，可以直接使用 `file-icons` 插件（700 多个图标）设置，如：

| 案例                  | 描述        |
| --------------------- | ----------- |
| `icon: 'atom-icon'`   | atom 图标   |
| `icon: 'git-icon'`    | git 图标    |
| `icon: 'github-icon'` | github 图标 |
| `icon: 'code-icon'`   | 代码图标    |
| `icon: 'psd-icon'`    | psd 图标    |
| `icon: 'php-icon'`    | php 图标    |
| `icon: 'book-icon'`   | 文档 图标   |

### autoprefixer

`autoprefixer` 唯一需要注意的是，想要获取最新的规则，就需要卸掉掉后，重新安装一遍！

| 几个概念                                                      | 描述           |
| ------------------------------------------------------------- | -------------- |
| [插件地址](https://github.com/sindresorhus/atom-autoprefixer) | 安装插件的源码 |
| [规则地址](https://github.com/postcss/autoprefixer)           | 规则下载地址   |
| [规则官网](https://twitter.com/autoprefixer)                  | 官网是推特     |

### remote-ftp

> 最简单的 ftp 配置，更全面的说明移步 [`官方说明`](https://github.com/icetee/remote-ftp)

```conf
{
    "protocol": "ftp",
    "host": "ip address",
    "port": 21,
    "user": "username",
    "promptForPass": true,
}
```

> SFTP 配置文件

```conf
{
    "protocol": "sftp",
    "host": "example.com", // ip地址，默认: 'localhost'
    "port": 22, // 对应SFTP服务器的端口号，默认: 22
    "user": "user", // 用户名，默认为空
    "pass": "pass", // 密码，默认为空
    "promptForPass": true, // 密码输入对话框，默认为: false
    "remote": "/", // 指定远程根目录
    "connTimeout": 10000, // 连接ssh时间，默认: 10000
    "keepalive": 10000, // 主动向ssh发送指令的间隔时间，0为不发送，默认: 10000
    "filePermissions":"0644" // 上传的远程权限，会修改原先设置（如果用户权限足够）
}
```

> FTP 配置文件

```conf
{
    "protocol": "ftp",
    "host": "example.com", // ip地址，默认: 'localhost'
    "port": 21, // 对应SFTP服务器的端口号，默认: 21
    "user": "user", // 用户名，默认为空
    "pass": "pass", // 密码，默认为空
    "promptForPass": true, // 密码输入对话框，默认为: false
    "remote": "/",
    "connTimeout": 10000, // 等待建立控制连接的时间(以毫秒为单位)， Default: 10000
    "pasvTimeout": 10000, // 等待PASV数据连接建立的时间(以毫秒为单位)， Default: 10000
    "keepalive": 10000,  // 主动向ssh发送指令的间隔时间，0为不发送，默认: 10000
}
```
