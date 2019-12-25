# 编译安装 PHP

PHP 是处理 php 脚本的解释器，服务器安装了 MariaDB 后就可以开始安装 PHP。

## 一、必备安装包准备

编译 PHP 需要的准备好的软件包：

| 必备            | 操作                                                     |
| --------------- | -------------------------------------------------------- |
| libxml2 依赖库  | libxml2-dev                                              |
| libssl 依赖库   | libssl-dev                                               |
| libonig 依赖库  | libonig-dev                                              |
| libcurl4 依赖库 | libcurl4-openssl-dev                                     |
| PHP 源码包      | [php-7.4.1.tar.gz](https://www.php.net/downloads.php)    |
| openssl 依赖库  | [openssl-1.1.1d.tar.gz](https://www.openssl.org/source/) |
| curl 依赖库     | [curl-7.67.0.tar.gz](https://curl.haxx.se/download.html) |

1. 安装 Nginx 必备开发库

   ```sh
   $ apt install libxml2-dev libssl-dev libonig-dev libcurl4-openssl-dev
   ```

   > 提示：使用 `./configure` 指令构建时，会提示缺失的依赖包相关信息！

2. 创建 Nginx 构建目录

   ```sh
   $ mkdir /package/php-7.4.1/php_bulid
   ```

## 二、编译安装

1. 进入构建路径

   ```sh
   $ cd /package/php-7.4.1/php_bulid
   ```

2. php 构建选项：

   ```sh
   $ ../configure --prefix=/server/php \
   --enable-fpm \
   --enable-mbstring \
   --with-openssl=/package/pkg/openssl-1.1.1d \
   --with-pcre-jit \
   --enable-mysqlnd \
   --with-mysqli \
   --with-pdo-mysql \
   --with-mysql-sock=/server/run/mariadb/mysqld.sock \
   --with-curl=/package/pkg/curl-7.67.0 \
   --without-sqlite3 \
   --without-pdo-sqlite
   ```

3. 构建选项说明

   | 构建选项             | 描述                                         |
   | -------------------- | -------------------------------------------- |
   | --prefix=            | 指定 php 安装路径                            |
   | --enable-fpm         | 构建 php-fpm 服务                            |
   | --enable-mbstring    | 构建 mbstring 扩展                           |
   | --with-openssl=      | 构建 openssl 扩展                            |
   | --with-pcre-jit      | 正则支持 jit 编译器                          |
   | --enable-mysqlnd     | 构建 mysqlnd 扩展（php 官方写的 mysql 驱动） |
   | --with-mysqli        | 构建 mysqli 扩展（默认使用 mysqlnd 驱动）    |
   | --with-pdo-mysql     | 构建 pdo-mysql 扩展（默认使用 mysqlnd 驱动） |
   | --with-mysql-sock=   | 指定 MariaDB 的 socket 文件路径              |
   | --with-curl=         | 构建 curl 扩展                               |
   | --without-sqlite3    | 禁止构建 sqlite3 数据库系统扩展              |
   | --without-pdo-sqlite | 禁止构建 pdo-sqlite 数据库系统扩展           |

4. 编译并安装

   ```sh
   $ make -j4
   $ make test
   $ make install
   ```

## 三、PHP 命令行工具

`php-config` 是一个简单的命令行脚本用于获取所安装的 PHP 配置的信息。具体如下：

```sh
$ cd /server/php/bin/php-config
Usage: /server/php/bin/php-config [OPTION]
Options:
  --prefix            [/server/php]
  --includes          [-I/server/php/include/php -I/server/php/include/php/main -I/server/php/include/php/TSRM -I/server/php/include/php/Zend -I/server/php/include/php/ext -I/server/php/include/php/ext/date/lib]
  --ldflags           []
  --libs              [-lcrypt   -lresolv -lcrypt -lrt -lrt -lm -ldl  -lxml2 -lssl -lcrypto -lcurl -lxml2 -lonig -lxml2 -lcrypt -lxml2 -lxml2 -lxml2 -lz -lssl -lcrypto -lcrypt ]
  --extension-dir     [/server/php/lib/php/extensions/no-debug-non-zts-20190902]
  --include-dir       [/server/php/include/php]
  --man-dir           [/server/php/php/man]
  --php-binary        [/server/php/bin/php]
  --php-sapis         [ cli fpm phpdbg cgi]
  --ini-path          [/server/php/lib]
  --ini-dir           []
  --configure-options [--prefix=/server/php --enable-fpm --enable-mbstring --with-openssl=/package/pkg/openssl-1.1.1d --with-pcre-jit --enable-mysqlnd --with-pdo-mysql --with-curl=/package/pkg/curl-7.67.0 --without-cdb --without-sqlite3 --without-pdo-sqlite]
  --version           [7.4.1]
  --vernum            [70401]
```

> 注意：如果系统有多个 PHP 版本，在编译时可以使用 `--with-php-config` 选项来指定用于编译的 php 版本，该选项指定了 `php-config` 脚本的路径。

## 四、PHP 扩展库

PHP 扩展分为静态扩展和动态扩展两类：

| 扩展类型 | 扩展类型说明                       | 操作方式                    |
| -------- | ---------------------------------- | --------------------------- |
| 静态扩展 | 编译安装 PHP 时，一起安装的扩展    | 只能通过重新编译 PHP 来修改 |
| 动态扩展 | 使用 `phpize` 编译安装的 PECL 扩展 | 通过操作 `php.ini` 来控制   |

> 提示：php 源码自带的扩展库，支持静态安装和动态安装，如果两个都安装了，默认以静态扩展方式优先!

- 动态库操作：

  PHP 动态扩展库的具体安装方法请查阅[为 PHP 安装 PECL 扩展](./04-为php安装pecl扩展.md)

  | 操作       | 案例                                               |
  | ---------- | -------------------------------------------------- |
  | 开启动态库 | `php.ini` 文件里添加 `extension=<库名>`            |
  | 禁用动态库 | `php.ini` 文件里删除指定的 `extension=<库名>` 内容 |

  > 提示：有些动态库是 `zend` 扩展库，需要使用 `zend_extension=<库名>` 开启，才能生效！

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

php-fpm 的主进程配置文件必须创建，使用默认模版的即可：

```sh
$ cd /server/php/etc
$ cp php-fpm.conf{.default,}
```

### 创建工作进程配置文件

php-fpm 的工作进程配置文件必须创建，允许多个：

```sh
$ cd /server/php/etc/php-fpm.d
$ cp www.conf{.default,}
```

> 提示：默认的配置有些不满足要求，我们需要自己修改配置文件信息。

1. 创建工作进程用户

   用户一般与 nginx 主进程用户保持一致即可，具体操作见 [lnmp 维护篇](./05-lnmp维护篇.md)

2. 创建 unix 套接字监听文件的存放目录：

   ```sh
   $ mkdir /var/run/php/
   ```

   > 提示：使用 [lnmp_dir](./source/lnmp_dir.sh) 脚本会自动创建该目录！

3. 创建 php-pfm 工作进程配置文件：

   ```sh
   $ vim /server/php/etc/php-fpm.d/www.conf
   ```

   > 提示：具体配置信息请参考 [www.conf](./source/php/www.conf)

## 六、管理 php-fpm 进程

php-fpm 自带了一套比较完善的进程管理指令，编译完成后还会在构建目录下生成 Unit 文件

### 简单管理 php-fpm 守护进程

| 管理类型     | 指令                               |
| ------------ | ---------------------------------- |
| 测试 php-fpm | /server/php/sbin/php-fpm -t        |
| 启动 php-fpm | /server/php/sbin/php-fpm           |
| 关闭 php-fpm | kill -9 `cat /var/run/php-fpm.pid` |
| 关闭 php-fpm | pkill -9 php-fpm                   |
| php-fpm 帮助 | /server/php/sbin/php-fpm -h        |

### 使用 Systemd 管理 php-fpm 守护进程

php 在编译时如果选择安装 php-fpm(--enable-fpm 构建选项)，编译完成后会自动生成两个启动脚本，具体参考如下：

| 启动项      | 启动文件(与源码略有不同)                    |
| ----------- | ------------------------------------------- |
| Unit 文件   | [php-fpm.service](./source/php-fpm.service) |
| init.d 文件 | [init.d.php-fpm](./source/init.d.php-fpm)   |
| 脚本目录    | /package/php-7.4.1/php_bulid/sapi/fpm       |

> 说明：这里只讨论 Systemd 操作，init.d 脚本已经不再推荐使用

1. 将 nginx 的单元文件拷贝到 Systemd 的用户目录下：

   ```sh
   $ cd /package/php-7.4.1/php_bulid/sapi/fpm
   $ cp ./php-fpm.service /usr/lib/systemd/system/
   ```

2. 重新载入 Systemd 服务配置

   ```sh
   $ systemctl daemon-reload
   ```

3. 开机自动激活 Nginx 单元

   ```sh
   $ systemctl enable php-fpm.service
   ```
