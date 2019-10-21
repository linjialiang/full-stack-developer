# atom 基本设置

这小节主要讲解 Atom 的基本设置以及文件的作用

## 常用文件说明

安装完 Atom 后会在当前用户的目录下面创建一个 `.atom` 目录，所有的配置都在这里进行

## 目录结构

Atom 配置目录的结构如下：

```shell
├─ .atom                                    Atom配置根目录
|   ├─.apm                                  忽略的目录
|   |
|   ├─.node-gyp                             安装插件基础
|   |
|   ├─blob-store                            忽略的目录
|   |
|   ├─compile-cache                         忽略的目录
|   |
|   ├─other                                 自定义目录
|   |   ├─php-cs-fixer.phar                 php代码格式化基础包
|   |   ├─file-header                       头文件插件（插件未下载）
|   |   |   ├─lang-mapping.json             自定义配置文件
|   |   |   ├─templates                     自定义模板目录
|   |   |   └─...
|   |
|   ├─packages                              插件存放目录
|   |
|   ├─recovery                              忽略的目录
|   |
|   ├─storage                               忽略的目录
|   |
|   ├─.apmrc                                代理配置文件
|   |
|   ├─.gitignore                            git忽略文件
|   |
|   ├─config.cson                           配置信息文件
|   |
|   ├─github.cson                           忽略的文件
|   |
|   ├─init.coffee                           忽略的文件
|   |
|   ├─keymap.cson                           自定义快捷键文件
|   |
|   ├─projects.cson                         Project Manager插件的配置文件
|   |
|   ├─snippets.cson                         自定义代码片段
|   |
|   └─styles.less                           自定义界面样式文件
|
├─github                                    忽略的目录
|
└─emmet                                     忽略的目录
```

## 基本设置

通过快捷键 `Ctrl-,` 可以打开基本设置界面，具体如何设置看个人喜好，大家也可以参考我的配置文件：

| 配置文件                                  | 文件说明           |
| ----------------------------------------- | ------------------ |
| [`.apmrc`](./source/.apmrc)               | 配置代理文件       |
| [`config.cson`](./source/config.cson)     | 界面与插件配置信息 |
| [`keymap.cson`](./source/keymap.cson)     | 自定义快捷键信息   |
| [`styles.less`](./source/styles.less)     | 自定义样式信息     |
| [`projects.cson`](./source/projects.cson) | 保存的项目信息     |

### 开启 `Settings`

| 序号                      | 打开 settings 方式    |
| ------------------------- | --------------------- |
| 快捷键开启方式            | `ctrl-,`              |
| `ctrl-shift-p` 开启方式： | `settings view: open` |

### 字体推荐

建议字体大小为 `14px` ，字体如下：

```text
'Fira Code', '思源黑体 CN'
```

> 提示：`Fira Code` 对一些符号组合可以实现连字显示！

### Atom 代理设置

通过 `~\.atom\.apmrc` 文件，可以让 `atom` 支持代理网络

1.  本地代理

    ```shell
    strict-ssl = false
    http-proxy = http://127.0.0.1:1080
    https-proxy = http://127.0.0.1:1080
    ```

2.  淘宝镜像代理（无效）

    ```shell
    ;strict-ssl = false
    ;http-proxy = http://registry.npm.taobao.org/
    ;https-proxy = https://registry.npm.taobao.org/
    ```

---

## 快捷键说明

下面快捷键是比较实用，但容易被我们忽略的：

| 全局快捷键          | 功能                                 |
| ------------------- | ------------------------------------ |
| `ctrl-k ctrl-b`     | 显示或隐藏目录树                     |
| `ctrl-斜杠`         | 显示或隐藏目录树                     |
| `alt-斜杠`          | 显示目录树，光标在页面和目录树将切换 |
| `ctrl-shift-斜杠`   | 显示目录树，并定位到当前页面所在位置 |
| `ctrl-k ctrl-left`  | 向左切换窗口                         |
| `ctrl-k ctrl-right` | 向右切换窗口                         |
| `ctrl-k ctrl-up`    | 向上切换窗口                         |
| `ctrl-k ctrl-down`  | 向下切换窗口                         |

| 目录树的快捷键  | 功能                                               |
| --------------- | -------------------------------------------------- |
| `a`             | 新建文件                                           |
| `shift-A`       | 新建目录                                           |
| `d`             | 拷贝文件或目录（支持指定位置）                     |
| `m`             | 移动文件或目录（支持重命名）                       |
| `i`             | 显示或隐藏版本控制控制忽略的文件（如：.gitignore） |
| `h j k l`       | 上下移动、收起目录、打开目录                       |
| `g g`           | 跳到项目根目录                                     |
| `shift-G`       | 跳到最后一个文件                                   |
| `ctrl-k ctrl-p` | 向上打开文件                                       |
| `ctrl-k ctrl-n` | 向下打开文件                                       |
| `ctrl-k ctrl-l` | 向右打开文件                                       |
| `ctrl-k ctrl-h` | 向左打开文件                                       |

| 大小写快捷键    | 功能           |
| --------------- | -------------- |
| `ctrl-k ctrl-u` | 使当前字符大写 |
| `ctrl-k ctrl-l` | 使当前字符小写 |

| 文本编辑快捷键            | 功能                           |
| ------------------------- | ------------------------------ |
| `ctrl-j`                  | 合并下一行                     |
| `ctrl-up`                 | 当前行向上                     |
| `ctrl-down`               | 当前行向下移动                 |
| `ctrl-shift-d`            | 复制当前行到下一行             |
| `ctrl-d`                  | 选中单词或下个相同单词         |
| `ctrl-shift-u`            | 切换编码                       |
| `ctrl-f`                  | 在文件中查找                   |
| `ctrl-l`                  | 选取当前行                     |
| `ctrl-x`                  | 剪切当前行，或剪切选中内容     |
| `ctrl-shift-k`            | 删除当前行                     |
| `ctrl-shift-f`            | 在项目中查找（请在目录树使用） |
| `ctrl-shift-l`            | 选择文本类型（高亮和补全）     |
| `ctrl-Backspace`          | 删除当前单词左侧的字符及空格   |
| `ctrl-Delete`             | 删除当前单词右侧的字符空格     |
| `ctrl-left`               | 将光标移动至单词最左端         |
| `ctrl-right`              | 将光标移动至单词最右端         |
| `ctrl-鼠标左键`           | 添加光标                       |
| `ctrl-shift-鼠标左键`     | 添加光标                       |
| `ctrl-shift-alt-鼠标左键` | 添加光标                       |
| `ctrl-shift-down`         | 向下添加光标                   |
| `ctrl-shift-up`           | 向上添加光标                   |

| git 快捷键     | 功能            |
| -------------- | --------------- |
| `ctrl-shift-9` | git 操作界面    |
| `ctrl-shift-8` | github 操作界面 |

| 书签快捷键      | 功能                           |
| --------------- | ------------------------------ |
| `ctrl-alt-F2`   | 添加或移除书签（当前行）       |
| `ctrl-shift-F2` | 移除所有书签（当前页面）       |
| `F2`            | 下一个书签（当前页面）         |
| `shift-F2`      | 上一个书签（当前页面）         |
| `ctrl-F2`       | 调出书签列表（所有文件的书签） |

| 代码补全        | 功能          |
| --------------- | ------------- |
| `ctrl-k ctrl-o` | 展示补全列表  |
| `ctrl-p`        | 向上移动 1 行 |
| `ctrl-n`        | 向下移动 1 行 |
| `home`          | 移动至顶部    |
| `end`           | 移动至底部    |
| `pageup`        | 向上移动 1 页 |
| `pagedown`      | 向下移动 1 页 |

| 指令列表 | 功能          |
| -------- | ------------- |
| `ctrl-p` | 向上移动 1 行 |
| `ctrl-n` | 向下移动 1 行 |
| `home`   | 移动至顶部    |
| `end`    | 移动至底部    |

| 插件快捷键          | 功能                         |
| ------------------- | ---------------------------- |
| `ctrl-~`            | 打开 atom 终端               |
| `ctrl-alt-k`        | 选取颜色                     |
| `ctrl-alt-b`        | 代码格式化                   |
| `ctrl-alt-t`        | 文件对比                     |
| `ctrl-k ctrl-t`     | git 版本库时间列表           |
| `ctrl-k ctrl-b`     | 默认软件打开当前文件         |
| `ctrl-k ctrl-h`     | 文件添加头标记（插件为下载） |
| `ctrl-k ctrl-M`     | markdown 预览                |
| `ctrl-k ctrl-enter` | 跳转到定义页面               |
| `ctrl-k ctrl-r`     | 跳转到定义页面               |

| quick-highlight 快捷键 | 功能                  | 描述              |
| ---------------------- | --------------------- | ----------------- |
| `ctrl-k m`             | 普通模式-快速高亮     | 选择+单词快速高亮 |
| `ctrl-k M`             | 普通模式-取消全部高亮 | 取消快速高亮      |
| `g m`                  | vim 模式-快速高亮     | 选择+单词快速高亮 |
| `g M`                  | vim 模式-取消全部高亮 | 取消快速高亮      |

| remote-ftp 快捷键 | 功能              |
| ----------------- | ----------------- |
| `ctrl-k t`        | 展示/取消远程界面 |
| `ctrl-k c`        | 连接远程          |
| `ctrl-k d`        | 断开远程          |
| `ctrl-k u`        | 更新远程文件      |

| atom-ternjs 快捷键    | 功能               |
| --------------------- | ------------------ |
| `ctrl-k ctrl-shift-D` | 属性的定义位置     |
| `ctrl-k ctrl-shift-R` | 重构属性名         |
| `ctrl-k ctrl-shift-E` | 属性出现的位置列表 |
| `ctrl-k ctrl-shift-O` | 展示当前属性的描述 |
