# vscode 设置篇

通过自定义的设置，可以让 vscode 对我们更加友好，并且一些社区扩展也需要通过自己设置。

## 快捷键

vscode 快捷键是本篇章的重点，合理的快捷键可以让工作效力更加高效，具体如下：

### 基本编辑快捷键

| 按键组合         | 描述                       | 指令                                              |
| ---------------- | -------------------------- | ------------------------------------------------- |
| ctrl+x           | 剪切                       | editor.action.clipboardCutAction                  |
| ctrl+c           | 复制                       | editor.action.clipboardCopyAction                 |
| Ctrl+Shift+K     | 删除选中行                 | editor.action.deleteLines                         |
| Ctrl+Enter       | 向下插入一行               | editor.action.insertLineAfter                     |
| Ctrl+Shift+Enter | 向上插入一行               | editor.action.insertLineBefore                    |
| Alt+Down         | 向下移动选中行             | editor.action.moveLinesDownAction                 |
| Alt+Up           | 向上移动选中行             | editor.action.moveLinesUpAction                   |
| Shift+Alt+Down   | 向下复制选中行             | editor.action.copyLinesDownAction                 |
| Shift+Alt+Up     | 向上复制选中行             | editor.action.copyLinesUpAction                   |
| Ctrl+D           | 选中下一个匹配内容         | editor.action.addSelectionToNextFindMatch         |
| Ctrl+K Ctrl+D    | 移动到下一个匹配内容       | editor.action.moveSelectionToNextFindMatch        |
| Ctrl+U           | 撤销上一个光标操作         | cursorUndo                                        |
| Shift+Alt+I      | 将光标插入选中行的末尾     | editor.action.insertCursorAtEndOfEachLineSelected |
| Ctrl+Shift+L     | 选中页面中所有匹配的内容   | editor.action.selectHighlights                    |
| Ctrl+F2          | 选中页面中所有匹配的单词   | editor.action.changeAll                           |
| Ctrl+L           | 选中当前行                 | expandLineSelection                               |
| Ctrl+Alt+Down    | 向下选择多个光标           | editor.action.insertCursorBelow                   |
| Ctrl+Alt+Up      | 向上选中多个光标           | editor.action.insertCursorAbove                   |
| Ctrl+Shift+\     | 跳转到匹配的括号           | editor.action.jumpToBracket                       |
| Ctrl+]           | 增加缩进                   | editor.action.indentLines                         |
| Ctrl+[           | 减少缩进                   | editor.action.outdentLines                        |
| Home             | 光标回到行手               | cursorHome                                        |
| End              | 光标回到行尾               | cursorEnd                                         |
| Ctrl+End         | 光标跳到页面末尾           | cursorBottom                                      |
| Ctrl+Home        | 光标跳到页面顶部           | cursorTop                                         |
| Ctrl+Down        | 页面向下移动               | scrollLineDown                                    |
| Ctrl+Up          | 页面向上移动               | scrollLineUp                                      |
| Alt+PageDown     | 页面向下翻页               | scrollPageDown                                    |
| Alt+PageUp       | 页面向上翻页               | scrollPageUp                                      |
| Ctrl+Shift+[     | 折叠当前区域(子区域不操作) | editor.fold                                       |
| Ctrl+Shift+]     | 展开当前区域(子区域不操作) | editor.unfold                                     |
| Ctrl+K Ctrl+[    | 折叠当前区域               | editor.foldRecursively                            |
| Ctrl+K Ctrl+]    | 展开当前区域               | editor.unfoldRecursively                          |
| Ctrl+K Ctrl+0    | 折叠页面所有区域           | editor.foldAll                                    |
| Ctrl+K Ctrl+J    | 展开页面所有区域           | editor.unfoldAll                                  |
| Ctrl+K Ctrl+C    | 增加行注释                 | editor.action.addCommentLine                      |
| Ctrl+K Ctrl+U    | 减少行注释                 | editor.action.removeCommentLine                   |
| Ctrl+/           | 切换行注释                 | editor.action.commentLine                         |
| Shift+Alt+A      | 切换快注释                 | editor.action.blockComment                        |

### 单页搜索界面快捷键

| 按键组合     | 描述                    | 指令                                  |
| ------------ | ----------------------- | ------------------------------------- |
| Ctrl+F       | 搜索界面                | actions.find                          |
| Ctrl+H       | 替换界面                | editor.action.startFindReplaceAction  |
| Enter        | 选中下一个匹配项        | editor.action.nextMatchFindAction     |
| Shift+Enter  | 选中上一个匹配项        | editor.action.previousMatchFindAction |
| Alt+Enter    | 选中所有匹配项          | editor.action.selectAllMatches        |
| Alt+C        | 切换区分大小写选项      | toggleFindCaseSensitive               |
| Alt+R        | 切换正则匹配选项        | toggleFindRegex                       |
| Alt+W        | 切换搜索整个单词选项    | toggleFindWholeWord                   |
| Ctrl+M       | 切换使用 Tab 键设置焦点 | editor.action.toggleTabFocusMode      |
| 未设置快捷键 | 切换显示空白            | toggleRenderWhitespace                |
| Alt+Z        | 切换允许换行选项        | editor.action.toggleWordWrap          |

### 语言界面快捷键

| 按键组合         | 描述                        | 指令                                       |
| ---------------- | --------------------------- | ------------------------------------------ |
| ~~Ctrl+Space~~   | 展开补全列表（冲突）        | editor.action.triggerSuggest               |
| Ctrl+Shift+Space | 触发器参数提示              | editor.action.triggerParameterHints        |
| Shift+Alt+F      | 格式化文档                  | editor.action.formatDocument               |
| Ctrl+K Ctrl+F    | 格式化选定区域              | editor.action.formatSelection              |
| F12              | 方法跳转到定义处            | editor.action.revealDefinition             |
| Ctrl+K Ctrl+I    | Show Hover                  | editor.action.showHover                    |
| Alt+F12          | Peek Definition             | editor.action.peekDefinition               |
| Ctrl+K F12       | Open Definition to the Side | editor.action.revealDefinitionAside        |
| Ctrl+.           | Quick Fix                   | editor.action.quickFix                     |
| Shift+F12        | Peek References             | editor.action.referenceSearch.trigger      |
| F2               | 文件重命名                  | editor.action.rename                       |
| Ctrl+Shift+.     | Replace with Next Value     | editor.action.inPlaceReplace.down          |
| Ctrl+Shift+,     | Replace with Previous Value | editor.action.inPlaceReplace.up            |
| Shift+Alt+Right  | Expand AST Selection        | editor.action.smartSelect.expand           |
| Shift+Alt+Left   | Shrink AST Selection        | editor.action.smartSelect.shrink           |
| Ctrl+K Ctrl+X    | 去掉行尾空格                | editor.action.trimTrailingWhitespace       |
| Ctrl+K M         | 更换语言                    | workbench.action.editor.changeLanguageMode |

### 导航快捷键

| 按键组合           | 描述                 | 指令                                                   |
| ------------------ | -------------------- | ------------------------------------------------------ |
| Ctrl+T             | 显示所有符号         | workbench.action.showAllSymbols                        |
| Ctrl+G             | 跳转到指定行         | workbench.action.gotoLine                              |
| Ctrl+P             | 快速打开文件         | workbench.action.quickOpen                             |
| Ctrl+Shift+O       | 当前页面符号         | workbench.action.gotoSymbol                            |
| Ctrl+Shift+M       | 显示问题控制台       | workbench.actions.view.problems                        |
| F8                 | 转到下一个错误或警告 | editor.action.marker.nextInFiles                       |
| Shift+F8           | 转到上一个错误或警告 | editor.action.marker.prevInFiles                       |
| Ctrl+Shift+P or F1 | 显示所有命令         | workbench.action.showCommands                          |
| Ctrl+Shift+Tab     | 导航编辑器组历史记录 | workbench.action.openPreviousRecentlyUsedEditorInGroup |
| Alt+Left           | 上一级               | workbench.action.navigateBack                          |
| Alt+Left           | 返回快速输入         | workbench.action.quickInputBack                        |
| Alt+Right          | 下一集               | workbench.action.navigateForward                       |

### 编辑器/窗口管理快捷键

| 按键组合            | 描述                       | 指令                                        |
| ------------------- | -------------------------- | ------------------------------------------- |
| Ctrl+Shift+N        | 新窗口                     | workbench.action.newWindow                  |
| Ctrl+W              | 关闭窗口                   | workbench.action.closeWindow                |
| Ctrl+F4             | 关闭编辑器                 | workbench.action.closeActiveEditor          |
| Ctrl+K F            | 关闭目录                   | workbench.action.closeFolder                |
| 未设置快捷键        | 编辑器组之间的循环         | workbench.action.navigateEditorGroups       |
| Ctrl+\              | 拆分编辑器                 | workbench.action.splitEditor                |
| Ctrl+1              | 关注第 1 编辑器组          | workbench.action.focusFirstEditorGroup      |
| Ctrl+2              | 关注第 2 编辑器组          | workbench.action.focusSecondEditorGroup     |
| Ctrl+3              | 关注第 3 编辑器组          | workbench.action.focusThirdEditorGroup      |
| 未设置快捷键        | 将焦点放在左侧的编辑器组中 | workbench.action.focusPreviousGroup         |
| 未设置快捷键        | 将焦点放在右边的编辑器组中 | workbench.action.focusNextGroup             |
| Ctrl+Shift+PageUp   | 当前编辑器向左移动         | workbench.action.moveEditorLeftInGroup      |
| Ctrl+Shift+PageDown | 当前编辑器向右移动         | workbench.action.moveEditorRightInGroup     |
| Ctrl+K Left         | 将活动编辑器组向左移动     | workbench.action.moveActiveEditorGroupLeft  |
| Ctrl+K Right        | 将活动编辑器组向右移动     | workbench.action.moveActiveEditorGroupRight |
| Ctrl+Alt+Right      | 将编辑器移到下一组         | workbench.action.moveEditorToNextGroup      |
| Ctrl+Alt+Left       | 将编辑器移到前面的组中     | workbench.action.moveEditorToPreviousGroup  |

### 文件管理快捷键

| 按键组合       | 描述                             | 指令                                                   |
| -------------- | -------------------------------- | ------------------------------------------------------ |
| Ctrl+N         | 新建文件                         | workbench.action.files.newUntitledFile                 |
| Ctrl+O         | 打开文件                         | workbench.action.files.openFile                        |
| Ctrl+S         | 保存                             | workbench.action.files.save                            |
| Ctrl+K S       | 保存全部打开文件                 | workbench.action.files.saveAll                         |
| Ctrl+Shift+S   | 文件另存为                       | workbench.action.files.saveAs                          |
| Ctrl+F4        | 关闭当前文件                     | workbench.action.closeActiveEditor                     |
| 未定义快捷键   | 关闭其他文件                     | workbench.action.closeOtherEditors                     |
| Ctrl+K W       | 关闭当前编辑器组                 | workbench.action.closeEditorsInGroup                   |
| 未定义快捷键   | 关闭其它编辑器组                 | workbench.action.closeEditorsInOtherGroups             |
| 未定义快捷键   | 关闭左侧编辑器组                 | workbench.action.closeEditorsToTheLeft                 |
| 未定义快捷键   | 关闭右侧编辑器组                 | workbench.action.closeEditorsToTheRight                |
| Ctrl+K Ctrl+W  | 关闭全部打开文件                 | workbench.action.closeAllEditors                       |
| Ctrl+Shift+T   | 重新打开关闭的文件               | workbench.action.reopenClosedEditor                    |
| Ctrl+K Enter   | 保持打开（不会被其它文件替换）   | workbench.action.keepEditor                            |
| Ctrl+Tab       | 切换到下一个打开文件             | workbench.action.openNextRecentlyUsedEditorInGroup     |
| Ctrl+Shift+Tab | 切换到上一个打开文件             | workbench.action.openPreviousRecentlyUsedEditorInGroup |
| Ctrl+K P       | 复制当前文件路径                 | workbench.action.files.copyPathOfActiveFile            |
| Ctrl+K R       | 资源管理器中打开当前文件所在目录 | workbench.action.files.revealActiveFileInWindows       |
| Ctrl+K O       | 在新的 vscode 窗口中打开当前文件 | workbench.action.files.showOpenedFileInNewWindow       |
| 未定义快捷键   | Compare Opened File With         | workbench.files.action.compareFileWith                 |

### 界面显示快捷键

| 按键组合         | 描述                           | 指令                                            |
| ---------------- | ------------------------------ | ----------------------------------------------- |
| F11              | 切换全屏                       | workbench.action.toggleFullScreen               |
| Ctrl+K Z         | 禅模式开关                     | workbench.action.toggleZenMode                  |
| Escape Escape    | 离开禅模式                     | workbench.action.exitZenMode                    |
| Ctrl+=           | 放大显示                       | workbench.action.zoomIn                         |
| Ctrl+-           | 缩小显示                       | workbench.action.zoomOut                        |
| Ctrl+Numpad0     | 重置缩放                       | workbench.action.zoomReset                      |
| Ctrl+B           | 切换侧栏可见性                 | workbench.action.toggleSidebarVisibility        |
| Ctrl+Shift+E     | 资源管理界面                   | Explorer / Toggle Focus workbench.view.explorer |
| Ctrl+Shift+F     | 全局搜索界面                   | workbench.view.search                           |
| ~~Ctrl+Shift+G~~ | 显示版本控制界面（被插件覆盖） | workbench.view.scm                              |
| Ctrl+Shift+D     | 显示调试界面                   | workbench.view.debug                            |
| Ctrl+Shift+X     | 显示扩展界面                   | workbench.view.extensions                       |
| Ctrl+Shift+U     | 显示输出                       | workbench.action.output.toggleOutput            |
| Ctrl+Q           | 快速打开视图                   | workbench.action.quickOpenView                  |
| Ctrl+Shift+C     | 打开系统控制台                 | workbench.action.terminal.openNativeConsole     |
| Ctrl+Shift+V     | 切换 markdown 预览             | markdown.showPreview                            |
| Ctrl+K V         | 打开 makrdow 预览到一边        | markdown.showPreviewToSide                      |
| Ctrl+\`          | 集成终端开关                   | workbench.action.terminal.toggleTerminal        |

### 全局搜索快捷键

| 按键组合     | 描述                   | 指令                                       |
| ------------ | ---------------------- | ------------------------------------------ |
| Ctrl+Shift+F | 切换到全局搜索界面     | workbench.view.search                      |
| Ctrl+Shift+H | 切换到批量文件替换界面 | workbench.action.replaceInFiles            |
| Alt+C        | 切换区分大小写         | toggleSearchCaseSensitive                  |
| Alt+W        | 切换匹配整个单词       | toggleSearchWholeWord                      |
| Alt+R        | 切换使用正则表达式     | toggleSearchRegex                          |
| Ctrl+Shift+J | 切换搜索详细信息       | workbench.action.search.toggleQueryDetails |
| F4           | 关注下一个搜索结果     | search.action.focusNextSearchResult        |
| Shift+F4     | 关注上一个搜索结果     | search.action.focusPreviousSearchResult    |
| Down         | 显示下一个搜索项       | history.showNext                           |
| Up           | 显示上一个搜索项       | history.showPrevious                       |

### 设置界面快捷键

| 按键组合      | 描述             | 指令                                   |
| ------------- | ---------------- | -------------------------------------- |
| Ctrl+,        | 打开设置界面     | workbench.action.openSettings          |
| 未定义快捷键  | 开放式工作区设置 | workbench.action.openWorkspaceSettings |
| Ctrl+K Ctrl+S | 打开键盘快捷键   | workbench.action.openGlobalKeybindings |
| 未定义快捷键  | 打开用户代码片段 | workbench.action.openSnippets          |
| Ctrl+K Ctrl+T | 选择颜色主题     | workbench.action.selectTheme           |
| 未定义快捷键  | 配置显示语言     | workbench.action.configureLocale       |

### Debug

| 按键组合      | 描述           | 指令                                 |
| ------------- | -------------- | ------------------------------------ |
| F9            | 切换设置断点   | editor.debug.action.toggleBreakpoint |
| F5            | 开始调试       | workbench.action.debug.start         |
| F5            | 继续循环       | workbench.action.debug.continue      |
| Ctrl+F5       | 开始(没有调试) | workbench.action.debug.run           |
| F6            | 暂停           | workbench.action.debug.pause         |
| F11           | 单步执行       | workbench.action.debug.stepInto      |
| Shift+F11     | 跳出           | workbench.action.debug.stepOut       |
| F10           | 跨过           | workbench.action.debug.stepOver      |
| Shift+F5      | 停止           | workbench.action.debug.stop          |
| Ctrl+K Ctrl+I | 显示悬停       | editor.debug.action.showDebugHover   |

### 任务快捷键

| 按键组合     | 描述           | 指令                                                  |
| ------------ | -------------- | ----------------------------------------------------- |
| 未定义快捷键 | 安装扩展       | workbench.extensions.action.installExtension          |
| 未定义快捷键 | 显示安装的扩展 | workbench.extensions.action.showInstalledExtensions   |
| 未定义快捷键 | 展示过时的扩展 | workbench.extensions.action.listOutdatedExtensions    |
| 未定义快捷键 | 显示推荐的扩展 | workbench.extensions.action.showRecommendedExtensions |
| 未定义快捷键 | 受欢迎的扩展   | workbench.extensions.action.showPopularExtensions     |
| 未定义快捷键 | 更新所有的扩展 | workbench.extensions.action.updateAllExtensions       |

### 扩展及自定义快捷键

| 按键组合       | 描述               | 指令                           |
| -------------- | ------------------ | ------------------------------ |
| ctrl+k ctrl+b  | 以默认方式打开文件 | extension.openInDefaultBrowser |
| ctrl+k ctrl+o  | 展开补全列表       | editor.action.triggerSuggest   |
| Ctrl+Shift+G G | 显示版本控制界面   | workbench.view.scm             |

## 快捷键绑定语法

vscode 的快捷键绑定语法很简洁，有任何基础的都可以学会，具体语法如下：

```sjon
[
    {
        "key": "ctrl+k ctrl+b",
        "command": "extension.openInDefaultBrowser",
        "when": "editorLangId == html"
    },
    {
        "key": "ctrl+k ctrl+o",
        "command": "editor.action.triggerSuggest",
        "when": "editorHasCompletionItemProvider && textInputFocus && !editorReadonly"
    }
]

```

语法分析：

| 键      | 描述                     |
| ------- | ------------------------ |
| key     | 触发语法的快捷键按键组合 |
| command | 语法                     |
| when    | 按键触发语法的必要条件   |

### 条件运算符

when 支持以下几种运算条件的符号：

| 符号 | 运算条件 | 案例                                  |
| ---- | -------- | ------------------------------------- |
| `==` | 等于     | `"editorLangId == html"`              |
| `!=` | 不等于   | `"resourceExtname != .js"`            |
| `||` | 或       | `"isLinux || isWindows"`              |
| `&&` | 与       | `"textInputFocus && !editorReadonly"` |
| ·!·  | 取反     | `"!editorReadonly"`                   |

### when 语境

下面是`when`子句的上下文，它们的值为`真`或`假`

> 编辑上下文语境“

| `when`上下文                | 描述                                                                  |
| --------------------------- | --------------------------------------------------------------------- |
| editorFocus                 | 编辑器具有焦点，无论是文本还是小部件。                                |
| editorTextFocus             | 编辑器中的文本有焦点(光标闪烁)。                                      |
| textInputFocus              | 任何编辑器都有焦点(常规编辑器、调试 REPL 等)。                        |
| inputFocus                  | 任何文本输入区域都有焦点(编辑器或文本框)。                            |
| editorHasSelection          | 在编辑器中选择文本。                                                  |
| editorHasMultipleSelections | 选择多个文本区域(多个游标)。                                          |
| editorReadonly              | 编辑器是只读的。                                                      |
| editorLangId                | 当编辑器的关联语言 Id 匹配时为真。例如:“editorLangId == typescript”。 |
| isInDiffEditor              | 活动编辑器是一个差异编辑器。                                          |
| isInEmbeddedEditor          | 当焦点位于嵌入式编辑器中时，为真                                      |

> 操作系统环境：

| `when`上下文 | 描述                      |
| ------------ | ------------------------- |
| isLinux      | Linux 系统为真            |
| isMac        | macOS 系统为真            |
| isWindows    | 微软系统为真              |
| isWeb        | 当从 Web 访问编辑器时为真 |

> 上下文列表:

| `when`上下文            | 描述                   |
| ----------------------- | ---------------------- |
| listFocus               | 列表有重点             |
| listSupportsMultiselect | 列表支持多选择         |
| listHasSelectionOrFocus | 列表有选择或焦点       |
| listDoubleSelection     | 列表有两个选择元素     |
| listMultiSelection      | 列表有多个元素的选择。 |

> 模式情况下：

| `when`上下文  | 描述                                               |
| ------------- | -------------------------------------------------- |
| inDebugMode   | 正在运行调试会话                                   |
| debugType     | 当调试类型匹配时为真。例如: "debugType == 'node'". |
| inSnippetMode | 编辑器处于代码片段模式                             |
| inQuickOpen   | 快速打开下拉菜单有焦点                             |

> 资源环境：

| `when`上下文                             | 描述                                                                          |
| ---------------------------------------- | ----------------------------------------------------------------------------- |
| resourceScheme                           | 当资源 Uri 方案匹配时为真。示例:“resourceScheme == file”                      |
| resourceFilename                         | 当资源管理器或编辑器文件名匹配时为真。例如:“resourceFilename == gulpfile.js”  |
| resourceExtname                          | 当资源管理器或编辑器的扩展名匹配时，为真。示例:“resourceExtname == .js”       |
| resourceLangId                           | 当资源管理器或编辑器标题语言 Id 匹配时为真。示例:“resourceLangId == markdown” |
| isFileSystemResourceisFileSystemResource | 当资源管理器或编辑器文件是可以从文件系统提供程序处理的文件系统资源时，为真    |
| resourceSet                              | 设置资源管理器或编辑器文件时为真                                              |
| resource                                 | 资源管理器或编辑器文件的完整 Uri                                              |

> Explorer contexts：

| `when`上下文             | 描述                                     |
| ------------------------ | ---------------------------------------- |
| explorerViewletVisible   | 如果资源管理器视图可见，则为真           |
| explorerViewletFocus     | 如果资源管理器视图有键盘焦点，则为真     |
| filesExplorerFocus       | 如果文件资源管理器部分有键盘焦点，则为真 |
| openEditorsFocus         | 如果打开编辑器部分有键盘焦点，则为真     |
| explorerResourceIsFolder | 如果在资源管理器中选择了文件夹，则为     |

> 编辑器部件上下文：

| `when`上下文                     | 描述                                                       |
| -------------------------------- | ---------------------------------------------------------- |
| findWidgetVisible                | 编辑器查找小部件是可见的                                   |
| suggestWidgetVisible             | 建议小部件(智能感知)是可见的                               |
| suggestWidgetMultipleSuggestions | 显示多个建议                                               |
| renameInputVisible               | 可以看到重命名输入文本框                                   |
| referenceSearchVisible           | Peek 参考资料 Peek 窗口打开                                |
| inReferenceSearchEditor          | Peek 引用 Peek 窗口编辑器有焦点                            |
| config.editor.stablePeek         | 保持 peek 编辑器打开(由编辑器控制)。stablePeek 设置)       |
| quickFixWidgetVisible            | Quick Fix 小部件是可见的                                   |
| parameterHintsVisible            | 参数提示是可见的(由 editor. parameterhint 控制)。启用设置) |
| parameterHintsMultipleSignatures | 将显示多个参数提示                                         |

> 集成终端上下文：

| `when`上下文   | 描述             |
| -------------- | ---------------- |
| terminalFocus  | 集成终端具有焦点 |
| terminalIsOpen | 打开一个集成终端 |

> 公告界面上下文：

| `when`上下文                  | 描述                                                              |
| ----------------------------- | ----------------------------------------------------------------- |
| notificationFocus             | 通知有键盘焦点                                                    |
| notificationCenterVisible     | 通知中心位于 VS 代码的右下角                                      |
| notificationToastsVisible     | 通知 toast 在 VS 代码的右下角可见                                 |
| searchViewletVisible          | 搜索视图打开                                                      |
| sideBarVisible                | 侧栏显示                                                          |
| sideBarFocus                  | 侧边栏有焦点                                                      |
| panelFocus                    | 小组的焦点                                                        |
| inZenMode                     | 窗口处于 Zen 模式                                                 |
| isCenteredLayout              | 编辑器处于居中布局模式                                            |
| inDebugRepl                   | 焦点在调试控制台 REPL 中                                          |
| workspaceFolderCount          | 工作空间文件夹的计数                                              |
| replaceActive                 | 搜索视图替换文本框打开                                            |
| view                          | 当视图标识符匹配时为真。 例如: "view == myViewsExplorerID"        |
| viewItem                      | 当 viewItem 上下文匹配时为真。示例:“viewItem == someContextValue” |
| isFullscreen                  | 当窗口在全屏时为真                                                |
| focusedView                   | 当前焦点视图的标识符                                              |
| canNavigateBack               | 如果可以返回，则为真                                              |
| canNavigateForward            | 如果可以向前导航，则为真                                          |
| canNavigateToLastEditLocation | 如果可以导航到最后的编辑位置，则为真                              |

> 全局编辑器 UI 上下文：

| `when`上下文             | 描述                                                |
| ------------------------ | --------------------------------------------------- |
| textCompareEditorVisible | 至少有一个 diff(比较)编辑器是可见的                 |
| textCompareEditorActive  | diff(比较)编辑器是活动的                            |
| editorIsOpen             | 如果打开一个编辑器，则为真                          |
| groupActiveEditorDirty   | 如果组中的活动编辑器是脏的，则为真                  |
| groupEditorsCount        | 组中的编辑数                                        |
| activeEditorGroupEmpty   | 如果活动编辑器组没有编辑器，则为真                  |
| activeEditorGroupIndex   | 组中活动编辑器的索引(从 1 开始)                     |
| activeEditorGroupLast    | 当组中的活动编辑器是最后一个编辑器时，为真          |
| multipleEditorGroups     | 当存在多个编辑器组时为真                            |
| editorPinned             | 当组中的活动编辑器被固定(不在预览模式下)时，为 True |
| activeEditor             | 组中活动编辑器的标识符                              |

> 配置设置上下文：

| `when`上下文                  | 描述                                       |
| ----------------------------- | ------------------------------------------ |
| config.editor.minimap.enabled | 当设置了 `editor.minimap.enabled` 时，为真 |
