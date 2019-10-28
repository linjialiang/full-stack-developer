# httpd 日志

> httpd 服务器软件提供了非常全面和灵活的日志记录功能。

# httpd 日志分类

> httpd 将日志分为 `错误日志` 以及 `访问日志` 两类。

## 错误日志

> httpd 在处理请求时遇到的任何错误都会对此进行诊断，并将信息记录在错误日志里。

```text
- 服务器错误日志是最重要的日志文件；
- 其名称和位置由 ErrorLog 指令设置；
- 当启动服务器或服务器操作出现问题时，它是第一个查看的地方，因为它通常包含错误的详细信息以及如何修复它。
```

### 指令解释

> 错误日志主要包括下面 3 大指令：

| 所属模块 | 指令           | 描述                                                 |
| -------- | -------------- | ---------------------------------------------------- |
| core     | ErrorLog       | 记录错误日志的文件存放路径（支持绝对路径和相对路径） |
| core     | LogLevel       | 控制 ErrorLog 的详细程度（附录表格）                 |
| core     | ErrorLogFormat | 错误日志写入的格式（附录表格）                       |

1.  错误日志路径

    > ErrorLog 用于指定错误日志路径，最基本的用法：

    ```shell
    ErrorLog "${HTLOGS}/error/error.log"
    ```

    > 按大小截断：错误日志每超过 5M 大小截断一次，并且按截断时间来命名

    ```shell
    ErrorLog "|${SRVROOT}/bin/rotatelogs.exe -t ${HTLOGS}/error/error_log.%Y-%m-%d-%H_%M_%S 5M 480"
    ```

2.  错误日志级别

    > LogLevel 用于调整错误日志中记录的消息的详细程度，新手推荐如下设置（有经验的可酌情调整）：

    ```shell
    LogLevel warn
    ```

    > LogLevel 记录的消息的详细程度，按重要性递减顺序排序：

    | LogLevel 级别 | 描述                    |
    | ------------- | ----------------------- |
    | emerg         | 紧急情况 - 系统无法使用 |
    | alert         | 必须立即采取行动        |
    | crit          | 关键条件                |
    | error         | 错误条件                |
    | warn          | 警告条件                |
    | notice        | 正常但重要的情况        |
    | info          | 信息化                  |
    | debug         | 调试级消息              |
    | trace1        | 跟踪消息                |
    | trace2        | 跟踪消息                |
    | trace3        | 跟踪消息                |
    | trace4        | 跟踪消息                |
    | trace5        | 跟踪消息                |
    | trace6        | 跟踪消息                |
    | trace7        | 跟踪消息，转储大量数据  |
    | trace8        | 跟踪消息，转储大量数据  |

    ```text
    - 格式： LogLevel [模块标识符:]级别 [[模块标识符:级别] ...]
    - 至少需要指定一个全局的错误日志级别，如： LogLevel warn
    ```

3.  指定错误日志格式

    > ErrorLogFormat 用于指定错误日志格式，通常我们使用默认的即可。

    ```text
    - 格式：ErrorLogFormat [connection|request] [格式1] [格式2] ...
    ```

    | 格式字符串            | 描述                                                                 |
    | --------------------- | -------------------------------------------------------------------- |
    | `%%`                  | 百分号                                                               |
    | `%a`                  | 客户端 IP 地址和请求的端口                                           |
    | `%{c}a`               | 底层对等 IP 地址和连接端口（参见 mod_remoteip 模块）                 |
    | `%A`                  | 本地 IP 地址和端口                                                   |
    | `%{name}e`            | 请求环境变量名称                                                     |
    | `%E`                  | APR / OS 错误状态代码和字符串                                        |
    | `%F`                  | 源文件名和日志调用的行号                                             |
    | `%{name}i`            | 请求标题名称                                                         |
    | `%k`                  | 此连接上的保持活动请求数                                             |
    | `%l`                  | Loglevel 的消息                                                      |
    | `%L`                  | 请求的日志 ID                                                        |
    | `%{c}L`               | 连接的日志 ID                                                        |
    | `%{C}L`               | 如果在连接范围中使用，则为连接的日志 ID，否则为空                    |
    | `%m`                  | 记录消息的模块的名称                                                 |
    | `%M`                  | 实际的日志消息                                                       |
    | `%{name}n`            | 请求备注名称                                                         |
    | `%P`                  | 当前进程的进程 ID                                                    |
    | `%T`                  | 当前线程的线程 ID                                                    |
    | `%{g}T`               | 当前线程的系统唯一线程 ID（与例如显示的 ID 相同 top;仅限当前 Linux） |
    | `%t`                  | 现在的时间                                                           |
    | `%{u}t`               | 当前时间包括微秒                                                     |
    | `%{cu}t`              | 紧凑型 ISO 8601 格式的当前时间，包括微秒                             |
    | `%v`                  | ServerName 当前服务器的规范。                                        |
    | `%V`                  | 根据 UseCanonicalName 设置提供请求的服务器的服务器名称 。            |
    | `\ (backslash space)` | 非字段分隔空间                                                       |
    | `% (percent space)`   | 字段分隔符（无输出）                                                 |


    > 官方手册例子：

    ```shell
    #Simple example
    ErrorLogFormat "[%t] [%l] [pid %P] %F: %E: [client %a] %M"
    ```

    ```shell
    #Example (default format for threaded MPMs)
    ErrorLogFormat "[%{u}t] [%-m:%l] [pid %P:tid %T] %7F: %E: [client\ %a] %M% ,\ referer\ %{Referer}i"
    ```

    ```shell
    #Example (similar to the 2.2.x format)
    ErrorLogFormat "[%t] [%l] %7F: %E: [client\ %a] %M% ,\ referer\ %{Referer}i"
    ```

    ```shell
    #Advanced example with request/connection log IDs
    ErrorLogFormat "[%{uc}t] [%-m:%-l] [R:%L] [C:%{C}L] %7F: %E: %M"
    ErrorLogFormat request "[%{uc}t] [R:%L] Request %k on C:%{c}L pid:%P tid:%T"
    ErrorLogFormat request "[%{uc}t] [R:%L] UA:'%+{User-Agent}i'"
    ErrorLogFormat request "[%{uc}t] [R:%L] Referer:'%+{Referer}i'"
    ErrorLogFormat connection "[%{uc}t] [C:%{c}L] local\ %a remote\ %A"
    ```

## 访问日志

> 服务器访问日志记录服务器处理的所有请求

```text
- 访问日志的位置和内容由 CustomLog 指令控制；
- LogFormat 指令可用于简化日志内容的输出。
```

| 所属模块       | 指令      | 描述                                               |
| -------------- | --------- | -------------------------------------------------- |
| mod_log_config | CustomLog | 控制访问日志的位置和内容（支持绝对路径和相对路径） |
| mod_setenvif   | LogFormat | 设置日志文件的文件名和格式                         |
| mod_setenvif   | SetEnvIf  | 根据请求的属性设置环境变量，用于限制日志输出内容   |

1. 典型配置

   > 访问日志的典型配置如下所示：

   ```shell
   LogFormat "%h %l %u %t \"%r\" %>s %b" common
   CustomLog ${BASE_ROOT}/logs/apache24/access/access_log common
   ```

2. 默认配置

   > 默认的访问日志配置代码

   ```shell
   <IfModule log_config_module>
       LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
       LogFormat "%h %l %u %t \"%r\" %>s %b" common

       <IfModule logio_module>
         LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\" %I %O" combinedio
       </IfModule>

       CustomLog "${BASE_ROOT}/logs/apache24/access/access_log" common
   </IfModule>
   ```

## 访问日志模版

> 下面的示例可以帮助我们更好的理解访问日志！

1. 示例一、创建普通的访问日志模版

   > 新增访问日志格式模板，命名为 `newlogformat` 并调用该模板为访问日志输出格式

   ```shell
   <IfModule log_config_module>
       LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
       LogFormat "%h %l %u %t \"%r\" %>s %b" common
       LogFormat "%h-%v-%V %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" newlogformat

       <IfModule logio_module>
         LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\" %I %O" combinedio
       </IfModule>

       CustomLog "${BASE_ROOT}/logs/apache24/access/access_log" newlogformat
   </IfModule>
   ```

2. 只保留一天的文件日志

   > 如果我们仅需短时间内的访问日志信息，我们就可以只保留 24 小时甚至更断的访问日志信息

   ```text
   - 调用 newlogformat 模板为访问日志输出格式；
   - 创建 access_log 访问日志文件，每86400秒截断一次文件；
   - 提示：由于每次截断的文件名一致，因此永远只能保留一天的日志。
   ```

   ```shell
   <IfModule log_config_module>
       LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
       LogFormat "%h %l %u %t \"%r\" %>s %b" common
       LogFormat "%h-%v-%V %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" newlogformat

       <IfModule logio_module>
         LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\" %I %O" combinedio
       </IfModule>

       CustomLog "|${SRVROOT}/bin/rotatelogs.exe -t ${BASE_ROOT}/logs/apache24/access/access_log 86400 480" newlogformat
   </IfModule>
   ```

3. 按天截断访问日志文件

   > 单个日志过多不利于查看，因此需要将访问日志进行文件分割

   ```text
   - 调用 newlogformat 模板为访问日志输出格式；
   - 创建 access_log 访问日志文件，每86400秒截断一次文件；
   - 提示：由于文件名根据时间来创建，因此每天都有一个日志文件被保留。
   ```

   ```shell
   <IfModule log_config_module>
       LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
       LogFormat "%h %l %u %t \"%r\" %>s %b" common
       LogFormat "%h-%v-%V %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" newlogformat

       <IfModule logio_module>
         LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\" %I %O" combinedio
       </IfModule>

       CustomLog "|${SRVROOT}/bin/rotatelogs.exe -t ${BASE_ROOT}/logs/apache24/access/access_log.%Y-%m-%d 86400 480" newlogformat
   </IfModule>
   ```

4. 限制默写文件日志写入

   > 很多文件的访问信息可能无关紧要，这些我们就可以不记录到日志中

   ```text
   - 调用 `newlogformat` 模板为访问日志输出格式；
   - 创建 `access_log` 访问日志文件并每天截断一次文件;
   - 限制图片、js、css 等文件的访问信息写入日志；
   - 提示：由于文件名根据时间来创建，因此每天都有一个日志文件被保留。
   ```

   ```shell
   <IfModule log_config_module>
       LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
       LogFormat "%h %l %u %t \"%r\" %>s %b" common
       LogFormat "%h-%v-%V %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" newlogformat

       <IfModule logio_module>
         LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\" %I %O" combinedio
       </IfModule>

       SetEnvIf Request_URI "\.(ico|gif|jpg|png|bmp|swf|css|js)$" dontlog

       CustomLog "|${SRVROOT}/bin/rotatelogs.exe -t ${BASE_ROOT}/logs/apache24/access/access_log.%Y-%m-%d 86400 480" newlogformat env=!dontlog
   </IfModule>
   ```

5. 访问日志格式

| 格式字符串      | 描述                                                                                                     |
| --------------- | -------------------------------------------------------------------------------------------------------- |
| `%%`            | 百分号                                                                                                   |
| `%a`            | 请求的客户端 IP 地址（请参阅 mod_remoteip 模块）                                                         |
| `%{c}a`         | 连接的基础对等 IP 地址（请参阅 mod_remoteip 模块）                                                       |
| `%A`            | 本地 IP 地址                                                                                             |
| `%B`            | 响应大小（以字节为单位），不包括 HTTP 头                                                                 |
| `%b`            | 响应大小（以字节为单位），不包括 HTTP 头在 CLF 格式中，即-没有发送字节时 的' '而不是 0                   |
| `%{VARNAME}C`   | 发送到服务器的请求中的 cookie VARNAME 的内容仅完全支持版本 0 cookie                                      |
| `%D`            | 服务请求所需的时间，以微秒为单位                                                                         |
| `%{VARNAME}e`   | 环境变量 VARNAME 的内容                                                                                  |
| `%f`            | 文件名                                                                                                   |
| `%h`            | 远程主机名                                                                                               |
| `%H`            | 请求协议                                                                                                 |
| `%{VARNAME}i`   | VARNAME:发送到服务器的请求中标题行的内容。                                                               |
| `%k`            | 此连接上处理的 keepalive 请求数                                                                          |
| `%l`            | 远程日志名称                                                                                             |
| `%L`            | 来自错误日志的请求日志 id                                                                                |
| `%m`            | 请求方法                                                                                                 |
| `%{VARNAME}n`   | 来自另一个模块的 note VARNAME 的内容                                                                     |
| `%{VARNAME}o`   | VARNAME:回复中标题行的内容                                                                               |
| `%p`            | 服务请求的服务器的规范端口                                                                               |
| `%{format}p`    | 服务请求的服务器的规范端口，服务器的实际端口或客户端的实际端口有效的格式 canonical，local 或 remote      |
| `%P`            | 为请求提供服务的子进程 ID                                                                                |
| `%{format}P`    | 为请求提供服务的子进程 ID 或线程 ID 有效的格式是 pid，tid 和 hextid hextid 要求 APR 1.2.0 或更高         |
| `%q`            | 查询字符串（?如果查询字符串存在则前缀，否则为空字符串）                                                  |
| `%r`            | 第一行请求                                                                                               |
| `%R`            | 生成响应的处理程序（如果有）                                                                             |
| `%s`            | 状态对于已内部重定向的请求，这是原始请求的状态使用%>s 的最终状态                                         |
| `%t`            | 收到请求的时间的时区偏移量                                                                               |
| `%{format}t`    | 用“format”指定时间类型，以“begin:”开头则记录请求处理开始时的时间；以“end:”开头则记录写入日志条目时的时间 |
| `%T`            | 服务请求所需的时间，以秒为单位                                                                           |
| `%{UNIT}T`      | 服务请求所用的时间，用“UNIT”指定单位，有效单位 ms、us、s                                                 |
| `%u`            | 远程用户，如果请求已通过身份验证如果返回状态（%s）为 401（未经授权），则可能是伪造的                     |
| `%U`            | 请求的 URL 路径，不包括任何查询字符串                                                                    |
| `%v`            | ServerName 服务请求的服务器的规范                                                                        |
| `%V`            | 服务器名称根据 UseCanonicalName 设置                                                                     |
| `%X`            | 响应完成时的连接状态：                                                                                   |
| `%I`            | 收到的字节数，包括请求和标题不能为零您需要启用 mod_logio 此功能                                          |
| `%O`            | 发送的字节数，包括标题在极少数情况下可能为零，例如在发送响应之前请求被中止您需要启用 mod_logio 此功能    |
| `%S`            | 传输（接收和发送）的字节（包括请求和标头）不能为零这是％I 和％O 的组合您需要启用 mod_logio 此功能        |
| `%{VARNAME}^ti` | VARNAME:发送到服务器的请求中的预告片行的内容                                                             |
| `%{VARNAME}^to` | VARNAME:从服务器发送的响应中的预告片行的内容                                                            |

## 结束语

> 关于 httpd 的配置讲解到此就为止，想要深入学习，建议去[httpd 官网查看手册](https://httpd.apache.org/docs/2.4/)！
