# vscode 通用设置

1. 编辑器自带的功能

    ```json
    {
        // 编辑器自带的功能配置
        "workbench.startupEditor": "none",
        "editor.fontFamily": "'Fira Code', '思源黑体 CN'",
        "editor.fontLigatures": true,
        "editor.inlineHints.fontFamily": "'Fira Code', '思源黑体 CN'",
        "editor.lineNumbers": "relative",
        "editor.linkedEditing": true,
        "editor.tabSize": 4,
        "editor.wordWrap": "bounded",
        "files.autoGuessEncoding": true,
        "files.autoSave": "onFocusChange",
        "files.eol": "\n",
        "files.exclude": {
            "**/.git": true,
            "**/.svn": true,
            "**/.hg": true,
            "**/CVS": true,
            "**/.DS_Store": true
        },
        "files.trimFinalNewlines": true,
        "files.insertFinalNewline": true,
        "files.trimTrailingWhitespace": true,
        "files.watcherExclude": {
            "**/.git/objects/**": true,
            "**/.git/subtree-cache/**": true,
            "**/node_modules/*/**": true,
            "**/.hg/store/**": true
        },
        "search.exclude": {
            "**/node_modules": true,
            "**/bower_components": true,
            "**/*.code-search": true
        },
        "update.mode": "manual",
        "html.format.enable": false,
        "json.format.enable": false,
        "javascript.format.enable": false,
        "terminal.integrated.shell.windows": "C:\\Program Files\\Git\\bin\\bash.exe",
        "terminal.external.windowsExec": "C:\\cmder_mini\\cmder.exe"
    }
    ```
