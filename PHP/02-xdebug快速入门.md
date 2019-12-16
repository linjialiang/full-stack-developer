# Xdebug 快速入门

虽然我使用了多年的 Xdebug，但尴尬的是我对 Xdebug 的认知几乎为零，基于此我特地写了这篇文章！

## Xdebug 简介

Xdebug 是 PHP 的扩展，用于协助调试和开发。它包括：

| 序号 | Xdebug 功能                                        |
| ---- | -------------------------------------------------- |
| 01   | 一个用于 IDE 的调试器                              |
| 02   | 升级了 PHP 的 `var_dump()` 函数                    |
| 03   | 为 `通知`、`警告`、`错误` 和 `异常` 添加了堆栈跟踪 |
| 04   | 具有记录每个函数调用和磁盘变量赋值的功能           |
| 05   | 包含一个分析器                                     |
| 06   | 提供了与 PHPUnit 一起使用的代码覆盖功能            |

> 注意：虽然是 php 必备工具，但不推荐在生产环境中使用 Xdebug，因为它太重了。

## 安装 Xdebug

Xdebug 支持多种安装方式：

1. Windows 下安装 Xdebug

   | 步骤 | 具体操作内容                                                       |
   | ---- | ------------------------------------------------------------------ |
   | 01   | 去[官网](https://xdebug.org)下载对应版本的 dll 文件                |
   | 02   | 将 dll 文件拷贝到 php 的 `ext` 目录下，并重命名为 `php_xdebug.dll` |
   | 03   | 在 `php.ini` 配置文件底部加入配置信息，具体内容如下：              |

   ```ini
   [Xdebug]
   zend_extension=xdebug
   ```

2. 源码包安装

   去[官网](https://xdebug.org)下载最新版本的包文件，解压成功后，接着执行如下操作：

   ```sh
   $ phpize
   $ mkdir xdebug_bulid
   $ cd xdebug_bulid
   $ ../configure
   $ make -j4
   $ make test
   $ make install
   ```

   > php.ini 配置文件内容与 Windows 方式类似

3. PECL 安装

   没有测试过，这里是从网上找到，权威性不足

   ```sh
   $ pecl install xdebug
   ```

   > php.ini 配置文件内容与 Windows 方式类似

4. Docker 安装

   没有测试过，这里是从网上找到，权威性不足

   ```sh
   $ RUN pecl install xdebug
   $ RUN echo 'zend_extension=xdebug.so' >> /usr/local/etc/php/conf.d/xdebug.ini
   ```

## Xdebug 配置

xdebug 的全部配置信息，请查看 https://xdebug.org/docs/all_settings

### 基本配置

一般情况下，基本配置你都只需了解,无需修改：

| 配置参数                     | 类型    | 默认值 | 描述                                                                                            |
| ---------------------------- | ------- | ------ | ----------------------------------------------------------------------------------------------- |
| xdebug.default_enable        | boolean | 1      | 堆栈跟踪,默认开启,是 xdebug 基础功能之一                                                        |
| xdebug.force_display_errors  | integer | 0      | 默认关闭,如果开启,那么无论 PHP 的 `display_errors` 设置为什么,都将始终显示错误。                |
| xdebug.force_error_reporting | integer | 0      | 默认关闭,如果开启,允许强制显示某些错误                                                          |
| xdebug.halt_level            | integer | 0      | 默认关闭,设置接收某些指定错误                                                                   |
| xdebug.max_nesting_level     | integer | 256    | 控制无限递归(死循环)的保护机制,默认是 256                                                       |
| xdebug.max_stack_frames      | integer | -1     | 控制有多少堆栈帧显示在堆栈跟踪中，在 PHP 错误堆栈跟踪的命令行中，以及在浏览器中显示 HTML 跟踪。 |
| xdebug.scream                | boolean | 0      | 默认关闭,如果该设置为 1，那么 Xdebug 将禁用@(关闭)操作符，以便不再隐藏通知、警告和错误。        |

> 具体内容请移步官网 https://xdebug.org/docs/basic

### 打印配置

Xdebug 将替换 PHP 的 var_dump()函数来显示变量。Xdebug 版本包含了不同类型的不同颜色，并对数组元素/对象属性的数量、最大深度和字符串长度进行了限制。还有一些其他函数也处理变量显示。

| 配置参数                        | 类型    | 默认值 | 描述                                  |
| ------------------------------- | ------- | ------ | ------------------------------------- |
| xdebug.cli_color                | integer | 0      | cli 模式下输入结果是否设置颜色        |
| xdebug.overload_var_dump        | boolean | 2      | 是否允许 xdebug 重载 var_dump 函数    |
| xdebug.var_display_max_children | integer | 128    | var_dump 对数组对象子级的显示层数限制 |
| xdebug.var_display_max_data     | integer | 512    | var_dump 对结果长度的限制             |
| xdebug.var_display_max_depth    | integer | 3      | var_dump 对默认显示嵌套的层数的限制   |

> 具体内容请移步官网 https://xdebug.org/docs/display

### 堆栈跟踪配置

当 Xdebug 被激活时，当 PHP 决定显示一个通知、警告、错误等时，它将显示一个堆栈跟踪。堆栈跟踪显示的信息以及它们的显示方式可以配置为适合您的需要。

| 配置参数                | 类型    | 默认值 | 描述                                                                                                                 |
| ----------------------- | ------- | ------ | -------------------------------------------------------------------------------------------------------------------- |
| xdebug.cli_color        | integer | 0      | cli 模式下输入结果是否设置颜色                                                                                       |
| xdebug.collect_includes | boolean | 1      | 控制 Xdebug 是否应该将 include()、include_once()、require()或 require_once()中的文件名写入跟踪文件                   |
| xdebug.collect_params   | integer | 0      | 该设置默认为 0，控制当函数跟踪或堆栈跟踪记录函数调用时，Xdebug 是否应该收集传递给函数的参数                          |
| xdebug.collect_vars     | boolean | 0      | 这个设置告诉 Xdebug 在特定范围内使用哪些变量。只有当您希望使用 xdebug_get_declared_vars()时，才需要启用此设置        |
| `xdebug.dump.*`         | string  | empty  | `*` 可以是 COOKIE、FILE、GET、POST、REQUEST、SERVER、SESSION。这七个设置控制在发生错误时显示来自超全局变量的哪些数据 |
| xdebug.dump_globals     | boolean | 1      | 当该设置设置为 true 时，Xdebug 将添加通过 `Xdebug.dump.*` 配置的超级全局变量的值 `*` 到屏幕上的堆栈跟踪和错误日志    |
| xdebug.dump_once        | boolean | 1      | 控制是否应该在所有错误情况(设置为 0)上转储超全局变量的值，或只在第一个错误情况下转储超全局变量的值(设置为 1)         |
| xdebug.dump_undefined   | boolean | 0      | 如果您想从超全局变量中转储未定义的值，您应该将该设置设置为 1，否则将其设置为 0。                                     |
| xdebug.file_link_format | string  |        | 文件链接格式                                                                                                         |

> 具体内容请移步官网 https://xdebug.org/docs/stack_trace

### 函数调试配置

Xdebug 允许记录所有函数调用，包括参数和以不同格式返回的值。

| 配置参数                   | 类型    | 默认值 | 描述                                                                                                               |
| -------------------------- | ------- | ------ | ------------------------------------------------------------------------------------------------------------------ |
| xdebug.auto_trace          | boolean | 0      | 当将此设置设置为 ture 时，将在脚本运行之前启用函数调用的跟踪                                                       |
| xdebug.collect_assignments | boolean | 0      | 该设置默认为 0，控制 Xdebug 是否应该向函数跟踪添加变量赋值。                                                       |
| xdebug.collect_includes    | boolean | 1      | 该设置默认为 1，控制 Xdebug 是否应该将 include()、include_once()、require()或 require_once()中的文件名写入跟踪文件 |
| xdebug.collect_params      | integer | 0      | 该设置默认为 0，控制当函数跟踪或堆栈跟踪记录函数调用时，Xdebug 是否应该收集传递给函数的参数。                      |
| xdebug.collect_return      | boolean | 0      | 该设置默认为 0，控制 Xdebug 是否应该将函数调用的返回值写入跟踪文件。                                               |
| xdebug.show_mem_delta      | integer | 0      | Xdebug 生成的跟踪文件将显示函数调用之间内存使用的差异                                                              |
| xdebug.trace_format        | integer | 0      | 跟踪文件的格式                                                                                                     |
| xdebug.trace_options       | integer | 0      | 当设置为“1”时，跟踪文件将被附加到后面的请求中，而不是被覆盖。                                                      |
| xdebug.trace_output_dir    | string  | /tmp   | 写入跟踪文件的目录，确保 PHP 运行的用户具有该目录的写权限。                                                        |

> 具体内容请移步官网 https://xdebug.org/docs/execution_trace

### 垃圾收集统计信息

Xdebug 的内置垃圾收集统计信息分析器允许您查明 PHP 内部垃圾收集器何时触发、它能够清理多少变量、它花费了多长时间以及实际释放了多少内存。

| 配置参数                    | 类型   | 默认值     | 描述                                                                                                                                                            |
| --------------------------- | ------ | ---------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| xdebug.gc_stats_enable      | bool   | false      | 如果启用此设置，则垃圾收集运行的统计信息将自动收集到使用 xdebug.gc_stats_output_dir 设置的给定目录中，并使用由 xdebug.gc_stats_output_name 配置的自动生成的名称 |
| xdebug.gc_stats_output_dir  | string | /tmp       | 将写入垃圾收集统计信息输出的目录，确保将运行 PHP 的用户具有对该目录的写入权限。无法使用 ini_set() 在脚本中设置此设置                                            |
| xdebug.gc_stats_output_name | string | gcstats.%p | 此设置确定用于将垃圾回收统计信息转储到的文件的名称。该设置使用格式说明符指定格式，与 sprintf() 和 strftime() 非常相似。有几种格式说明符可用于格式化文件名       |

> 具体内容请移步官网 https://xdebug.org/docs/garbage_collection

### 远程调试配置

Xdebug 为与运行 PHP 脚本交互的调试器客户机提供了一个接口。说白话就是：IDE 断点调试的功能，就是通过这个接口写出来的

| 配置参数                         | 类型    | 默认值    | 描述                                                                                                           |
| -------------------------------- | ------- | --------- | -------------------------------------------------------------------------------------------------------------- |
| ebug.extended_info               | integer | 1         | 控制 Xdebug 是否应该为 PHP 解析器强制执行 `extended_info` 模式;                                                |
| ebug.extended_info               | integer | 1         | 这允许 Xdebug 使用远程调试器执行 `文件/行` 断点。                                                              |
| ebug.extended_info               | integer | 1         | 在跟踪或分析脚本时，您通常希望关闭此选项，因为 PHP 生成的 oparray 将增加大约三分之一的大小，从而减慢脚本速度。 |
| ebug.extended_info               | integer | 1         | 无法使用 ini_set（）在脚本中设置此设置，但只能在 php.ini 中设置。                                              |
| xdebug.idekey                    | string  | complex   | 控制哪些 IDE Key Xdebug 应传递给 DBGp 调试器处理程序。则与客户端通信的 key                                     |
| xdebug.remote_addr_header        | string  | ""        | 该值将用作 `$SERVER` 超全局数组中的键，以确定用于查找用于“连接回”的 IP 地址或主机名的标头                      |
| xdebug.remote_autostart          | boolean | 0         | 您需要使用特定的 HTTP `GET/POST` 变量来启动远程调试                                                            |
| xdebug.remote_connect_back       | boolean | 0         | 如果你不设置 ip 地址，就只能靠 xdebug 自己找了，Xdebug 将尝试连接到发出 HTTP 请求的客户端。                    |
| xdebug.remote_cookie_expire_time | integer | 3600      | 设置 cookie 的生命周期                                                                                         |
| xdebug.remote_enable             | boolean | 0         | 是否开启远程调试                                                                                               |
| xdebug.remote_handler            | string  | dbgp      | 调试的通信协议，dbgp 是 xdebug 的唯一用于调试的通信协议                                                        |
| xdebug.remote_host               | string  | localhost | 调试的网络地址，开启了 remote_connect_back 后，当前配置就无效了                                                |
| xdebug.remote_log                | string  |           | 调试的日志                                                                                                     |
| xdebug.remote_port               | integer | 9000      | 调试的端口                                                                                                     |
| xdebug.remote_timeout            | integer | 200       | 调试的通信链接的等待时间                                                                                       |

> 具体内容请移步官网 https://xdebug.org/docs/remote

### 其他官方链接

| 名称     | 链接地址                              |
| -------- | ------------------------------------- |
| 全部配置 | https://xdebug.org/docs/all_settings  |
| 全部函数 | https://xdebug.org/docs/all_functions |

### Xdebug 配置项目案例

```ini
[Xdebug]
zend_extension=xdebug

xdebug.collect_params = 4
xdebug.dump.* = *
xdebug.dump_undefined = 1
xdebug.trace_output_dir = "C:\wamp\web\logs\xdebug"
xdebug.gc_stats_enable = 1
xdebug.gc_stats_output_dir = "C:\wamp\web\logs\xdebug"
xdebug.profiler_enable = 1
xdebug.profiler_output_dir = "C:\wamp\web\logs\xdebug"

xdebug.remote_enable = 1
xdebug.remote_autostart = 1
xdebug.idekey = qywl
xdebug.remote_host = localhost
xdebug.remote_port = 9000
```

## 配置 PHPSTORM 调试

网络上的配置 DEBUG 文章太杂太乱,在 PHPSTROM 跳来跳去的,实在让人心烦意乱,本章重新整理描述。

1. 首先浏览器安装 xdebug 插件

   | 浏览器  | 对应插件                  |
   | ------- | ------------------------- |
   | firefox | Xdebug Helper for Firefox |
   | chrome  | Xdebug Helper             |

2. phpstrom 配置 Debug

   | 步骤 | 具体操作                                                            |
   | ---- | ------------------------------------------------------------------- |
   | 01   | 菜单：`文件 > 设置 > 语言 & 框架 > PHP > Debug`                     |
   | 02   | 找到 `Pre-configuration` 标题下的第 3 条信息                        |
   | 03   | 点击 `Start Listening` ，当变为 `stop Listening`                    |
   | 04   | 找到 `Xdebug` 标题，勾选全部内容，端口设置为跟 php.ini 配置文件一致 |
   | 05   | php 文件做好断点后，在浏览器中输入对应的网址，即可开始断点查询      |

   > 如果不依赖浏览器插件，还需要：

   | 步骤 | 具体操作                                            |
   | ---- | --------------------------------------------------- |
   | 01   | 菜单：`文件 > 设置 > 语言 & 框架 > PHP`             |
   | 02   | 找到 `CLI Interpreter` ，并点击 `...` 增加 php 版本 |
   | 03   | 菜单： `运行 > 编辑配置`，选择 `+` 按需增加配置     |

## 参考来源

| 序号 | 参考来源地址                                       |
| ---- | -------------------------------------------------- |
| 01   | https://segmentfault.com/a/1190000016325041#item-4 |
| 02   | https://xdebug.org/docs/                           |
