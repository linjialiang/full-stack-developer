# vscode 通用快捷键

vscode 官网有一个常用快捷键手册，我这里直接将其翻译成中文供大家参考： [`vscode通用快捷键-中文版.pdf`](./source/vscode快捷键-windows中文版.pdf)

## project-manager 相关快捷键

快速打开项目经常用到，快捷键如下（更多快捷键自行`Ctrl+k Ctrl+s`查看）：

| 快捷键           | 描述                         |
| ---------------- | ---------------------------- |
| shift+alt+p      | 快速打开新项目，替换当前项目 |
| ctrl+shift+alt+p | 在新窗口中，快速打开新项目   |

- 自定义的快捷键信息

  ```json
  [
    // 针对 project-manager 扩展的快捷键设置
    {
      "key": "ctrl+shift+alt+p",
      "command": "projectManager.listProjectsNewWindow"
    }
  ]
  ```

## hexdump for VSCode 相关快捷键

常用快捷键如下（更多快捷键自行`Ctrl+k Ctrl+s`查看）：

| 快捷键        | 描述                     |
| ------------- | ------------------------ |
| ctrl+k ctrl+h | 文件以 16 进制方式打开   |
| shift+enter   | 编辑光标位置内容         |
| ctrl+g        | 跳转至 16 进制地址所在行 |

- 自定义的快捷键信息

  ```json
  [
    // 针对 hexdump for VSCode 扩展的快捷键设置
    {
      "key": "ctrl+k ctrl+h",
      "command": "hexdump.hexdumpFile"
    }
  ]
  ```

## Bookmarks 相关快捷键

书签常用快捷键如下：

| 快捷键             | 描述               |
| ------------------ | ------------------ |
| ctrl+alt+k         | 书签开关           |
| ctrl+alt+j         | 跳转至上一个书签   |
| ctrl+alt+l         | 跳转至下一个书签   |
| ctrl+k shift+alt+l | 当前文件的书签列表 |
| ctrl+k alt+l       | 整个项目的书签列表 |
| ctrl+k shift+alt+b | 清空当前文件的书签 |
| ctrl+k alt+b       | 清空整个项目的书签 |

- 自定义的快捷键信息

  ```json
  [
    // 针对 Bookmarks 扩展的快捷键设置
    {
      "key": "ctrl+k shift+alt+l",
      "command": "bookmarks.list"
    },
    {
      "key": "ctrl+k shift+alt+b",
      "command": "bookmarks.clear"
    },
    {
      "key": "ctrl+k alt+b",
      "command": "bookmarks.clearFromAllFiles"
    },
    {
      "key": "ctrl+k alt+l",
      "command": "bookmarks.listFromAllFiles"
    }
  ]
  ```

## Better Align 相关快捷键

| 快捷键        | 描述     |
| ------------- | -------- |
| ctrl+k ctrl+= | 符号对齐 |

- 自定义的快捷键信息

  ```json
  [
    // 针对 Better Align 扩展的快捷键设置
    {
      "key": "ctrl+k ctrl+oem_plus",
      "command": "wwm.aligncode"
    }
  ]
  ```

## highlight-words 相关快捷键

| 快捷键         | 描述             |
| -------------- | ---------------- |
| ctrl+k g       | 选中文本高亮开关 |
| ctrl+k shift+g | 移除指定文本高亮 |
| ctrl+k space   | 移除全部文本高亮 |

- 自定义的快捷键信息

  ```json
  [
    // 针对 highlight-words 扩展相关快捷键设置
    {
      "key": "ctrl+k space",
      "command": "highlightwords.removeAllHighlights"
    },
    {
      "key": "ctrl+k g",
      "command": "highlightwords.addHighlight"
    },
    {
      "key": "ctrl+k shift+g",
      "command": "highlightwords.removeHighlight"
    }
  ]
  ```

## Partial Diff 相关快捷键

| 快捷键             | 描述                               |
| ------------------ | ---------------------------------- |
| ctrl+k shift+d     | 比较对象：选中内容（未选中为文件） |
| ctrl+k shift+alt+d | 当前对象：选中内容（未选中为文件） |

- 自定义的快捷键信息

  ```json
  [
    // 针对 Partial Diff 扩展相关快捷键设置
    {
      "key": "ctrl+k shift+d",
      "command": "extension.partialDiff.markSection1"
    },
    {
      "key": "ctrl+k shift+alt+d",
      "command": "extension.partialDiff.markSection2AndTakeDiff"
    }
  ]
  ```
