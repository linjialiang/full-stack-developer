# php 操作篇

这里我们对 php 只做一个简单的配置，供初学者使用，更多的内容我们会放在运维部分

## 关于 php 配置文件

php 根目录下有两个配置文件模板，我们复制其中 1 个并重命名为 `php.ini` 即可！

| 配置文件模板          | 描述             |
| --------------------- | ---------------- |
| `php.ini-development` | 开发环境示例模板 |
| `php.ini-production`  | 部署环境示例模板 |

> 既然是开发环境，理应选择复制 php.ini-development 并重命名为 php.ini！

## 为 php 绑定 httpd 服务

点击查看详情 [httpd 操作篇](./01-httpd操作篇.md)

## 关于 php 模块

php 的模块需要配置正确的路径，才能被 php 加载

### 为 php 模块默认目录配置正确路径

Windows 系统默认情况下 php 扩展的默认存放目录是 `c:\php\etc`，我们需要修改成正确的目录路径

| 所在行 | 修改前                    | 修后                                     |
| ------ | ------------------------- | ---------------------------------------- |
| 732 行 | `; extension_dir = "ext"` | `extension_dir = "c:\wamp\base\php\etc"` |

### 常用扩展及其说明：

| 常用扩展              | 说明                                                                            |
| --------------------- | ------------------------------------------------------------------------------- |
| `~~php_gd2.dll~~`     | php 对图像处理的扩展                                                            |
| `php_mbstring.dll`    | php 对多字节的支持（多国语言并存就意味着多字节）                                |
| `~~php_exif.dll~~`    | 让 php 可以操作图像元数据                                                       |
| `~~php_mysqli.dll~~`  | php 对 mysql 的 mysqli 语法支持                                                 |
| `~~php_openssl.dll~~` | php 开启对 openssl 支持                                                         |
| `php_pdo_mysql.dll`   | php 对 mysql 支持 pdo 语法支持                                                  |
| `~~php_tidy.dll~~`    | php 内置的 html 格式化/美化 tidy 函数                                           |
| `php_xdebug.dll`      | php 开发环境下的报错美化扩展，需去[xdebug 官网](https://xdebug.org)下载对应版本 |
| `php_imagick.dll`     | php 下完美的图形操作扩展，需要手动添加                                          |

> php 扩展写入 php.ini 格式：

| 扩展文件名     | 格式 1                   | 格式 2           |
| -------------- | ------------------------ | ---------------- |
| `php_别名.dll` | `extension=php_别名.dll` | `extension=别名` |

> 由于 xdebug 的驱动程序与其它官方自带扩展不同，我们建议将其写在 php.ini 最下方，写法如下：

```shell
[Xdebug]
zend_extension=xdebug
xdebug.profiler_append = 0
xdebug.profiler_enable = 1
xdebug.profiler_enable_trigger = 0
xdebug.profiler_output_dir ="C:\wamp\web\logs\xdebug"
xdebug.trace_output_dir ="C:\wamp\web\logs\xdebug"
xdebug.profiler_output_name = "cache.out.%t-%s"
xdebug.remote_enable = 1
xdebug.remote_autostart = 1
xdebug.remote_handler = "dbgp"
xdebug.remote_host = "127.0.0.1"
xdebug.idekey= PHPSTROM
```

### php 错误提示

php.ini 通过对 display_errors 的设置控制是否对 php 语法错误进行提示，默认开启错误提示

| 指令                 | 错误提示     |
| -------------------- | ------------ |
| `display_errors=On`  | 开启错误提示 |
| `display_errors=Off` | 关闭错误提示 |

### php 错误提示级别

php 通过 error_reporting 的设置控制错误提示级别，格式如下：

```shell
; php.ini配置文件内格式
error_reporting=错误级别别名

; .php扩展文件内格式
error_reporting(错误级别别名与位运算符组合);
```

### 错误级别

[错误级别一览表](http://php.net/manual/zh/errorfunc.constants.php)

| error-id | error-name          | 描述                                                          |
| -------- | ------------------- | ------------------------------------------------------------- |
| 1        | E_ERROR             | 致命的运行时错误                                              |
| 2        | E_WARNING           | 运行时警告                                                    |
| 4        | E_PARSE             | 编译时语法解析错误                                            |
| 8        | E_NOTICE            | 运行时通知                                                    |
| 16       | E_CORE_ERROR        | 在 PHP 初始化启动过程中发生的致命错误                         |
| 32       | E_CORE_WARNING      | PHP 初始化启动过程中发生的警告                                |
| 64       | E_COMPILE_ERROR     | 致命编译时错误。                                              |
| 128      | E_COMPILE_WARNING   | 编译时警告                                                    |
| 256      | E_USER_ERROR        | 用户产生的错误信息。                                          |
| 512      | E_USER_WARNING      | 用户产生的警告信息。                                          |
| 1024     | E_USER_NOTICE       | 用户产生的通知信息。                                          |
| 2048     | E_STRICT            | 启用 PHP 对代码的修改建议。                                   |
| 4096     | E_RECOVERABLE_ERROR | 可被捕捉的致命错误。                                          |
| 8192     | E_DEPRECATED        | 运行时通知                                                    |
| 16384    | E_USER_DEPRECATED   | 用户产少的警告信息。                                          |
| 30719    | E_ALL               | 支持的所有错误和警告，但 PHP 5.4.0 之前的级别 E_STRICT 除外。 |

可以使用 [php 位运算符规则](http://php.net/manual/zh/language.operators.bitwise.php) 来组合这些值或者屏蔽某些类型的错误

| command    | alias_name          | 结果                                                     |
| ---------- | ------------------- | -------------------------------------------------------- |
| `$a & $b`  | And（按位与）       | 将把 $a 和 $b 中都为 1 的位设为 1。                      |
| `$a 1 $b`  | Or（按位或）        | 将把 $a 和 $b 中任何一个为 1 的位设为 1。                |
| `$a ^ $b`  | Xor（按位异或）     | 将把 $a 和 $b 中一个为 1 另一个为 0 的位设为 1。         |
| `~ $a`     | Not（按位取反）     | 将 `$a` 中为 0 的位设为 1，反之亦然。                    |
| `$a << $b` | Shift left（左移）  | 将 $a 中的位向左移动 $b 次（每一次移动都表示"乘以 2"）。 |
| `$a >> $b` | Shift right（右移） | 将 $a 中的位向右移动 $b 次（每一次移动都表示"除以 2"）。 |

> 提示：在 php.ini 配置文件里，只支持 `|` `~` `!` `^` `&` 这 5 个位运算符

1.  php.ini 配置文件版

    说明：错误达到指定的错误级别才会提示错误报告，下面是案例：

    ```ini
    # 报告所有php错误
    error_reporting = E_ALL

    # 报告所有php错误，但是忽略：1）运行时通知；2）PHP对代码的修改建议
    E_ALL & ~E_DEPRECATED & ~E_STRICT
    ```

    > 注意：只能一个设置生效，所以 php.ini 文件里不要出现多个

2.  `.php`扩展文件内格式

    运用场景：一般是某个.php 扩展文件执行时遇到问题，针对当前文件开启调试功能，下面是案例：

    ```php
    // 关闭错误报告
    error_reporting(0);

    // 报告 runtime 错误
    error_reporting(E_ERROR | E_WARNING | E_PARSE);

    // 报告所有错误
    error_reporting(E_ALL);

    // 等同 error_reporting(E_ALL);
    ini_set("error_reporting", E_ALL);

    // 报告 E_NOTICE 之外的所有错误
    error_reporting(E_ALL & ~E_NOTICE);
    ```

    > 允许覆盖 php.ini 对应配置，只能一个设置生效，并且需要放在最靠近 `<?php` 的位置！

## `php.ini` 文件其它配置附录

> 文件上传相关配置列表：

| command                     | 描述                                                             |
| --------------------------- | ---------------------------------------------------------------- |
| `file_uploads = On`         | 允许 HTTP 文件上传                                               |
| `file_uploads = Off`        | 禁止 HTTP 文件上传                                               |
| `upload_tmp_dir = 指令目录` | 用于 HTTP 上载文件的临时目录（如果没有指定的话，将使用系统默认） |
| `upload_max_filesize = 2M`  | 上传文件的最大允许大小为 2M                                      |
| `max_file_uploads = 20`     | 可以通过单个请求上传的最大文件数量                               |
| `post_max_size = 8M`        | PHP 将接受的 POST 数据的最大大小                                 |

> php 执行脚本相关

| command                   | 描述                                                        |
| ------------------------- | ----------------------------------------------------------- |
| `max_execution_time = 30` | 每个脚本的最大执行时间，以秒为单位（30 秒）                 |
| `max_input_time = 60`     | 每个脚本可能花费解析请求数据的最长时间，以秒为单位（60 秒） |
| `memory_limit = 128M`     | 脚本可能消耗的最大内存数量（128 MB）                        |

## 删除 `php.ini` 多余的配置

> 主要就是删除 php.ini 文件下的备注行，详情见 [php.ini 文件](./source/php.ini)

## 备注

1.  php 所有扩展都已经备注，需自行去 php.ini 开启；
2.  php_xdebug 写在 php.ini 最底部，默认开启
3.  php_xdebug 扩展默认配置支持 phpstrom，如果使用其它 ide 开发项目，请自行配置 ide

## 安装 `php_imagick.dll` 扩展

`php_imagick.dll` 扩展安装需要下载两个软件包：

| 软件包                                                             | 描述               |
| ------------------------------------------------------------------ | ------------------ |
| [php_imagick](https://pecl.php.net/package/imagick)                | php 扩展           |
| [ImageMagick](https://imagemagick.org/script/download.php#windows) | ImageMagick 运行库 |

具体操作步骤如下：

| 步骤 | 描述                                                                     |
| ---- | ------------------------------------------------------------------------ |
| 01   | 将 php_imagick.dll 放入 ext 目录                                         |
| 02   | 将 php_imagick.dll 写入 php.ini 文件                                     |
| 03   | 安装 ImageMagick 运行库，并将其加入系统变量（安装时勾选第 2 个选项即可） |

> 提示：php_imagick.dll 的编译版本最好与 ImageMagick 运行库的版本号一致（一般只要运行库版本较高即可）！
