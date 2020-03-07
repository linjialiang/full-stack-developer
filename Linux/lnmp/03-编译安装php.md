# 编译安装 PHP

PHP 是处理 php 脚本的解释器，服务器安装了 MariaDB 后就可以开始安装 PHP。

## 一、必备安装包准备

编译 PHP 需要的准备好的软件包：

| 必备           | 操作                                                  |
| -------------- | ----------------------------------------------------- |
| libxml2 依赖库 | libxml2-dev                                           |
| libonig 依赖库 | libonig-dev                                           |
| PHP 源码包     | [php-7.4.3.tar.gz](https://www.php.net/downloads.php) |

1. 安装 php 必备开发库

   ```sh
   $ apt install libxml2-dev libonig-dev
   ```

   > 提示：使用 `./configure` 指令构建时，会提示缺失的依赖包相关信息！

2. 创建 Nginx 构建目录

   ```sh
   $ mkdir /package/php-7.4.3/php_bulid
   ```

## 二、编译安装

1. 进入构建路径

   ```sh
   $ cd /package/php-7.4.3/php_bulid
   ```

2. php 构建选项：

   ```sh
   $ ../configure --prefix=/server/php \
   --enable-fpm \
   --enable-mbstring \
   --with-zlib \
   --with-pcre-jit \
   --enable-mysqlnd \
   --with-mysqli \
   --with-pdo-mysql \
   --with-mysql-sock=/server/run/mariadb/mysqld.sock \
   --without-sqlite3 \
   --without-pdo-sqlite
   ```

3. 构建选项说明

   | 构建选项             | 描述                                            |
   | -------------------- | ----------------------------------------------- |
   | --prefix=            | 指定 php 安装路径                               |
   | --enable-fpm         | 构建 php-fpm 服务                               |
   | --enable-mbstring    | 构建 mbstring 扩展                              |
   | --with-zlib          | 构建 zlib 扩展(允许 php 透明读写 gzip 压缩文件) |
   | --with-pcre-jit      | 正则支持 jit 编译器                             |
   | --enable-mysqlnd     | 构建 mysqlnd 扩展（php 官方写的 mysql 驱动）    |
   | --with-mysqli        | 指定 mysqli 扩展（默认使用 mysqlnd 驱动）       |
   | --with-pdo-mysql     | 构建 pdo-mysql 扩展（默认使用 mysqlnd 驱动）    |
   | --with-mysql-sock=   | 指定 MariaDB 的 socket 文件路径                 |
   | --without-sqlite3    | 禁止构建 sqlite3 数据库系统扩展                 |
   | --without-pdo-sqlite | 禁止构建 pdo-sqlite 数据库系统扩展              |

4. 编译 php 涉及的扩展说明

   编译 php 过程中安装的扩展我们称为静态扩展，效率上比较高，但不能禁用（动态扩展可以禁用）。

   | 静态扩展  | 扩展描述                                 | 扩展所属分类                       |
   | --------- | ---------------------------------------- | ---------------------------------- |
   | mbstring  | 让 php 支持处理多字节字符串              | 捆绑扩展，不需要其它依赖项         |
   | zlib      | 允许 php 透明读写 gzip 压缩文件的扩展    | 捆绑扩展，不需要其它依赖项         |
   | mysqlnd   | 为 php 写的 MySQL/MariaDB 连接器         | 外部扩展，不需要其它依赖项         |
   | mysqli    | php 处理 MySQL/MariaDB 最快的扩展        | 外部扩展，需要先安装 MySQL/MariaDB |
   | pdo-mysql | php 使用 PDO 来处理 MySQL/MariaDB 的扩展 | 外部扩展，需要先安装 MySQL/MariaDB |

5. 编译并安装

   ```sh
   $ make -j4
   $ make test
   $ make install
   ```

## 三、配置 PHP

### PHP 命令行工具

php-config 是一个简单的命令行脚本用于获取所安装的 PHP 配置的信息。

```sh
$ /server/php/bin/php-config -h
```

| 命令行选项          | 说明                                   |
| ------------------- | -------------------------------------- |
| --prefix            | PHP 所安装的路径前缀，例如 /server/php |
| --includes          | 列出用 -I 选项包含的所有文件           |
| --ldflags           | PHP 编译时所使用的 LD 标志             |
| --libs              | PHP 编译时所附加的库                   |
| --extension-dir     | 扩展库的默认路径                       |
| --include-dir       | 头文件的默认路径前缀                   |
| --php-binary        | PHP CLI 或者 CGI 可执行文件的完整路径  |
| --php-sapis         | 列出所有可用的 SAPI 模块               |
| --ini-path          | php.ini 文件的存放路径                 |
| --configure-options | 重现当前 PHP 在编译时的配置选项        |
| --version           | PHP 版本号                             |
| --vernum            | PHP 版本号，以整数表示                 |

> 在编译扩展时，如果安装有多个 PHP 版本，可以在配置时用 --with-php-config 选项来指定使用哪一个版本编译，该选项指定了相对应的 php-config 脚本的路径。

### 为 PHP 创建配置文件(php.ini)

虽然编译安装后默认没有 php.ini 配置文件，但是 php 源码包包自带了两个可选的 php.ini 模版文件：

| 配置文件模版 | 路径                                   |
| ------------ | -------------------------------------- |
| 开发环境推荐 | /package/php-7.4.3/php.ini-development |
| 部署环境推荐 | /package/php-7.4.3/php.ini-production  |

1. 查询 php 配置文件的存放路径

   | 可查询程序 | 查询指令                              |
   | ---------- | ------------------------------------- |
   | php        | /server/php/bin/php --ini             |
   | php-config | /server/php/bin/php-config --ini-path | . |

   推荐使用 php 可执行文件查询：

   ```sh
   $ /server/php/bin/php --ini
   Configuration File (php.ini) Path: /server/php/lib
   Loaded Configuration File:         (none)
   Scan for additional .ini files in: (none)
   Additional .ini files parsed:      (none)
   ```

   查询结果分析：

   | 序号 | 查询结果                           |
   | ---- | ---------------------------------- |
   | 01   | php.ini 存放目录是 /server/php/lib |
   | 02   | 当前没有加载到配置文件             |

2. 拷贝配置文件模版到 /server/php/lib 目录下：

   ```sh
   # 开发环境
   $ cp /package/php-7.4.3/php.ini-development /server/php/lib/php.ini
   # 部署环境
   $ cp /package/php-7.4.3/php.ini-production /server/php/lib/php.ini
   ```

3. 查询 php.ini 配置文件是否加载

   ```sh
   $ /server/php/bin/php --ini
   Configuration File (php.ini) Path: /server/php/lib
   Loaded Configuration File:         /server/php/lib/php.ini
   Scan for additional .ini files in: (none)
   Additional .ini files parsed:      (none)
   ```

   查询结果分析：

   | 序号 | 查询结果                               |
   | ---- | -------------------------------------- |
   | 01   | php.ini 存放目录是 /server/php/lib     |
   | 02   | 加载了配置文件 /server/php/lib/php.ini |

## 四、PHP 扩展库

PHP 扩展分为静态扩展和动态扩展两类：

| 扩展类型 | 扩展类型说明                     | 操作方式                              |
| -------- | -------------------------------- | ------------------------------------- |
| 静态扩展 | 编译安装 PHP 时，一起安装的扩展  | 只能通过重新编译 PHP 来禁用扩展       |
| 动态扩展 | php 编译成功后，再独立安装的扩展 | 通过 `php.ini` 配置文件来 `禁用/启用` |

> 提示：如果某个扩展既是 `静态扩展` 又启用了 `动态扩展`，以 `静态扩展` 方式优先!

### 1、安装动态扩展

PHP 动态扩展库的具体安装方法请查阅：

| 扩展分类  | 动态扩展安装说明                                   |
| --------- | -------------------------------------------------- |
| PECL 扩展 | [为 PHP 安装 PECL 扩展](./04-为php安装pecl扩展.md) |
| 捆绑扩展  | [为 PHP 安装捆绑扩展](./04-为php安装捆绑扩展.md)   |
| 外部扩展  | [为 PHP 安装外部扩展](./04-为php安装外部扩展.md)   |

### 2、启用 php 动态扩展

动态扩展由 php 配置文件来控制，php 配置文件一般指的就是 `php.ini`

| 操作       | 案例                                               |
| ---------- | -------------------------------------------------- |
| 开启动态库 | `php.ini` 文件里添加 `extension=<库名>`            |
| 禁用动态库 | `php.ini` 文件里删除指定的 `extension=<库名>` 内容 |

> 提示：有些动态库是依赖 `zend` 扩展的，这时候就需要使用 `zend_extension=<库名>` 才能生效，比如：`xdebug` 扩展！

### 3、phpize 程序说明

`phpize` 可以将 php 扩展源码构建为可用 `./configure` 编译的代码，使用 `phpize --help` 可以查看帮助。

### 4、配置环境变量

将 php 可执行程序目录的路径加入环境变量中，可以方便后续操作

1. 修改控制环境变量的文件

   ```sh
   $ cp /etc/profile{,.bak}
   $ vim /etc/profile
   ```

2. `/etc/profile` 底部增加一行内容：

   ```sh
   export PATH=$PATH:/server/php/bin:/server/php/sbin
   ```

3. 使用 `source` 指令重新激活文件：

   ```sh
   $ source /etc/profile
   ```

### 5、检查 PHP 配置文件是否正确加载

使用 phpize 前，需要先正确加载 PHP 配置文件（php.ini）

1. 如出现类似如下内容，则配置文件正确加载：

   ```sh
   $ php --ini
   Loaded Configuration File:         /server/php/lib/php.ini
   ```

2. 如出现类似如下内容，则配置文件未加载

   ```sh
   $ php --ini
   Loaded Configuration File: (none)
   ```

> 说明：加载 php 配置文件，请参考 [编译安装 php](./03-编译安装php.md)

## 五、配置 php-fpm 服务

像 Nginx 这类 web 服务，只能处理静态页面，如果想要处理 php 脚本，就必须借助类似 `php-fpm` 的服务！

### php-fpm 配置文件

php-fpm 的所有配置文件默认都在 /server/php/etc 下：

| 进程类型         | 对应配置文件       | 数量     |
| ---------------- | ------------------ | -------- |
| 主进程(master)   | php-fpm.conf       | 1        |
| 工作池进程(pool) | `php-fpm.d/*.conf` | 没有限制 |

### 配置文件默认模块：

| 进程类型   | 对应配置文件模块           |
| ---------- | -------------------------- |
| 主进程     | php-fpm.conf.default       |
| 工作池进程 | php-fpm.d/www.conf.default |

### 创建主进程配置文件

php-fpm 的主进程配置文件必须创建：

```sh
$ cd /server/php/etc
$ cp php-fpm.conf{.default,}
```

修改几个选项的值：

| 选项      | 选项值                       |
| --------- | ---------------------------- |
| pid       | /server/run/php/php-fpm.pid  |
| error_log | /server/logs/php/php-fpm.log |

创建 unix 套接字监听文件的存放目录：

```sh
$ mkdir /server/run/php
```

> 提示：具体配置信息请参考 [php-fpm.conf](./source/php/php-fpm.conf)

### 创建工作进程配置文件

php-fpm 的工作进程配置文件必须创建，允许多个：

```sh
$ cd /server/php/etc/php-fpm.d
$ cp www.conf.default default.conf
```

修改几个选项的值：

| 选项                                  | 说明                                            |
| ------------------------------------- | ----------------------------------------------- |
| [default]                             | 子进程名，通常与子进程配置文件命名相同          |
| listen = /server/run/php/php-fpm.sock | php-fpm 进程的 socket 文件                      |
| group = nogroup                       | 默认为 nobody，但 debian 默认并没有这个用户组名 |
| listen.owner = nobody                 | 监听用户，必须与 nginx 用户一致                 |
| listen.group = nogroup                | 监听用户组，建议与 nginx 用户组一致             |

> 提示：php-fpm 的监听用户，必须跟对应的 web 服务器的用户一致，这样才能实现监听

1. 创建工作进程用户

   这里直接使用 nobody 了，具体操作见 [lnmp 维护篇](./05-lnmp维护篇.md)

2. 创建 unix 套接字监听文件的存放目录：

   ```sh
   $ mkdir /var/run/php/
   ```

   > 提示：使用 [lnmp_dir](./source/lnmp_dir.sh) 脚本会自动创建该目录！

3. 创建 php-pfm 工作进程配置文件：

   ```sh
   $ vim /server/php/etc/php-fpm.d/default.conf
   ```

   > 提示：具体配置信息请参考 [default.conf](./source/php/default.conf)

## 六、管理 php-fpm 进程

php-fpm 自带了一套比较完善的进程管理指令，编译完成后还会在构建目录下生成 Unit 文件

### 简单管理 php-fpm 守护进程

| 管理类型     | 指令                                      |
| ------------ | ----------------------------------------- |
| 测试 php-fpm | /server/php/sbin/php-fpm -t               |
| 启动 php-fpm | /server/php/sbin/php-fpm                  |
| 关闭 php-fpm | kill -9 `cat /server/run/php/php-fpm.pid` |
| 关闭 php-fpm | pkill -9 php-fpm                          |
| php-fpm 帮助 | /server/php/sbin/php-fpm -h               |

### 使用 Systemd 管理 php-fpm 守护进程

php 在编译时如果选择安装 php-fpm(--enable-fpm 构建选项)，编译完成后会自动生成两个启动脚本，具体参考如下：

| 启动项      | 启动文件(与源码略有不同)                        |
| ----------- | ----------------------------------------------- |
| Unit 文件   | [php-fpm.service](./source/php/php-fpm.service) |
| init.d 文件 | init.d.php-fpm                                  |
| 脚本目录    | /package/php-7.4.3/php_bulid/sapi/fpm           |

> 说明：这里只讨论 Systemd 操作，init.d 脚本已经不再推荐使用

1. 将 nginx 的单元文件拷贝到 Systemd 的用户目录下：

   ```sh
   $ cd /package/php-7.4.3/php_bulid/sapi/fpm
   $ cp ./php-fpm.service /usr/lib/systemd/system/
   ```

   > 注意：修改 PIDFile 路径为 `/server/run/php/php-fpm.pid`

2. 重新载入 Systemd 服务配置

   ```sh
   $ systemctl daemon-reload
   ```

3. 开机自动激活 Nginx 单元

   ```sh
   $ systemctl enable php-fpm.service
   ```

## 七、附录说明

### 为什么 PHP 链接 MariaDB 不成功？

答：一般是因为 php 程序找不到 MariaDB 的 socket 文件。

1. 可能导致这种情况发生的事件：

   | 序号 | 事件描述                                               |
   | ---- | ------------------------------------------------------ |
   | 01   | 编译 php 时，没有添加 `--with-mysql-sock` 这个构建选项 |
   | 02   | socket 文件路径发生改变                                |

2. 解决方法：通过修改 php.ini 配置文件是最简单的方式：

   | 区块            | 具体要修改的参数                                         |
   | --------------- | -------------------------------------------------------- |
   | [Pdo_mysql]区块 | pdo_mysql.default_socket=/server/run/mariadb/mysqld.sock |
   | [MySQLi]区块    | mysqli.default_socket=/server/run/mariadb/mysqld.sock    |

   > 提示：当然你如果不嫌麻烦，完全可以重新安装，这或许是最佳的方式！

### 为单独的站点配置 php-fpm 工作进程

操作跟上述创建工作进程一致，配置文件修改为： [qyadmin.conf](./source/php/qyamdin.conf)

```text
- 单独站点的 php-fpm 工作进程，可以设置单独的用户，如：www
- 单独站点的 php-fpm 工作进程，可以设置单独的socket，如：php-fpm-qyadmin.sock
- php-fpm 工作进程默认情况下不支持root用户
```

### 允许 php-fpm 工作进程以 root 用户运行

如果某些站点需要更多的权限，比如：控制面板，就需要用到 root 权限

1. 启动 php-fpm 指令

   ```sh
   $ /server/php/sbin/php-fpm --allow-to-run-as-root
   ```

2. systemd 单元文件的 `ExecStart` 参数修改为：

   ```sh
   ExecStart=/server/php/sbin/php-fpm --allow-to-run-as-root --nodaemonize --fpm-config /server/php/etc/php-fpm.conf
   ```

3. 警告：

   ```text
   - 服务器在任何时候都不应该存在允许root用户运行的web服务；
   - 大家一定要清楚，所有使用控制面板来操作的服务器，随时都可能被别人恶意操作！
   ```
