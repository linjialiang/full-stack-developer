# vscode 插件篇

vscode 插件非常丰富，大类分为：内置扩展和社区插件。

## 内置扩展

相较于 Atom 来讲，vscode 的内置扩展更加适用于实际编码，对于前端开发人员甚至可以不需要安装社区扩展。内置扩展如下：

| 内置扩展分类                           |
| -------------------------------------- |
| [语法基本扩展](./core/语法基本扩展.md) |
| [功能性扩展](./core/功能性扩展.md)     |
| [主题扩展](./core/主题扩展.md)         |

## 社区插件

内置扩展是集成在 vscode 内部的，我们无法看到具体的源码，但是社区插件是以源码的形式出现的，我们甚至可以直接修改它

### 社区插件根目录

社区插件根目录位于： `C:\Users\xxx\.vscode\extensions` ，下面是我常用的社区插件：

| 序号 | 社区插件                     | 描述                 |
| ---- | ---------------------------- | -------------------- |
| 01   | alignment                    | 符号对齐插件         |
| 02   | Auto Rename Tag              | 对 html 标签重命名   |
| 03   | Autoprefixer                 | 自动补全 css3 前缀   |
| 04   | Bookmarks                    | 书签统一管理         |
| 05   | Bracket Pair Colorizer 2     | 第二代括号着色       |
| 06   | vscode-language-pack-zh-hans | 中文菜单             |
| 07   | Debugger for Firefox         | firefox 浏览器调试   |
| 08   | Dracula Official             | 吸血鬼主题           |
| 09   | EditorConfig for VS Code     | 统一代码格式         |
| 10   | eslint                       | js 错误提示          |
| 11   | Git History                  | Git 文件历史版本     |
| 12   | Gitlens                      | Git 多功能插件       |
| 13   | highlight-words              | 选中高亮             |
| 14   | Markdown Preview Enhanced    | markdown 预览        |
| 15   | One Dark Pro                 | 一个暗系主题         |
| 16   | open in browser              | 默认程序打开当前文件 |
| 17   | php-docblocker               | php 注释             |
| 18   | PHP Intelephense             | php 高级特性支持     |
| 19   | Prettier - Code formatter    | 格式化多种类型的文件 |
| 20   | Project Manager              | 项目管理             |
| 21   | SCSS Everywhere              | html 与 css 双向提示 |
| 22   | Settings Sync                | vscode 配置同步助手  |
| 23   | SVG                          | svg 预览             |
| 24   | TODO Highlight               | 备忘录高亮           |
| 25   | Todo Tree                    | 备忘录管理           |
| 26   | Vim                          | 仿 vim 按键          |
| 27   | vscode-icons                 | 图标样式             |

### eslint 配置

1. 首先全局安装 eslint

    ```sh
    $ npm install eslint -g
    ```

2. 使用 `npm init` 指令创建 package.json 文件

    ```sh
    $ C:\wamp\web\www\qyadmin\admin>npm init
    This utility will walk you through creating a package.json file.
    It only covers the most common items, and tries to guess sensible defaults.

    See `npm help json` for definitive documentation on these fields
    and exactly what they do.

    Use `npm install <pkg>` afterwards to install a package and
    save it as a dependency in the package.json file.

    Press ^C at any time to quit.
    package name: (admin) qyadmin
    version: (1.0.0) 1.0.0
    description: qyadmin project
    entry point: (index.js)
    test command:
    git repository:
    keywords:
    author:
    license: (ISC)
    About to write to C:\wamp\web\www\qyadmin\admin\package.json:
    ```

3. 终端进入项目使用 js 的主目录，使用 `eslint --init` 指令配置

    ```sh
    $ C:\wamp\web\www\qyadmin\admin>eslint --init
    ? How would you like to use ESLint? To check syntax and find problems
    ? What type of modules does your project use? JavaScript modules (import/export)
    ? Which framework does your project use? Vue.js
    ? Does your project use TypeScript? No
    ? Where does your code run? Browser
    ? What format do you want your config file to be in? JSON
    The config that you've selected requires the following dependencies:

    eslint-plugin-vue@latest
    ? Would you like to install them now with npm? (Y/n)
    # 选择 yes
    # 在主目录下生成一个 node_modules 目录，并生成 `.eslintrc.js` 配置文件
    ```
