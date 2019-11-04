# 编译安装 PHP

PHP 是处理 php 脚本的解释器，服务器安装了 MariaDB 后就可以开始安装 PHP。

## 必备安装包准备

编译 PHP 需要的准备好的软件包：

| 必备           | 操作                                                                       |
| -------------- | -------------------------------------------------------------------------- |
| libxml2 开发库 | `apt install libxml2-dev`                                                  |
| libssl 开发库  | `apt install libssl-dev`                                                   |
| PHP 源码包     | [`php-7.3.11.tar.gz`](https://www.php.net/distributions/php-7.3.11.tar.gz) |
| CURL 源码包    | [`curl-7.66.0.tar.gz`](https://curl.haxx.se/download/curl-7.66.0.tar.gz)   |

软件包根目录为 `/package/lnmp` ，处理软件包过程如下指令：

| 过程 | 指令                 |
| ---- | -------------------- |
| 下载 | `$ wget <下载地址>`  |
| 解包 | `$ tar -xzvf <包名>` |

## 编译安装 CURL

CURL 是 php-curl 扩展的运行库，如果需要使用 php-curl 运行库就必须编译 CURL 软件包

### 编译 CURL 需要的目录

| 目录                  | 指令                                         |
| --------------------- | -------------------------------------------- |
| CURL 编译（安装）路径 | `mkdir /server/curl`                         |
| CURL 源码路径         | `cd /package/lnmp/curl-7.66.0`               |
| CURL 构建路径         | `mkdir /package/lnmp/curl-7.66.0/curl_bulid` |

### 开始构建

1. 进入 `CURL构建路径`

   ```sh
   $ cd /package/lnmp/curl-7.66.0/curl_bulid
   ```

2. 输入构建指令：

   ```sh
   $ ../configure --prefix=/server/curl
   ```

3. 编译并安装

```sh
$ make -j4
$ make install
```

## 编译安装 PHP

### 编译 CURL 需要的目录

| 目录                 | 指令                                       |
| -------------------- | ------------------------------------------ |
| PHP 编译（安装）路径 | `mkdir /server/php`                        |
| PHP 源码路径         | `/package/lnmp/php-7.3.11`                 |
| PHP 构建路径         | `mkdir /package/lnmp/php-7.3.11/php_bulid` |

### 开始构建

1. 进入构建路径

   ```sh
   $ cd /package/lnmp/php-7.3.11/php_build
   ```

2. 构建选项

   静态扩展只需要编译成功即可，动态扩展需要在 `php.ini` 文件里启用

   | 构建选项                   | 描述                                                           |
   | -------------------------- | -------------------------------------------------------------- |
   | `--prefix=/server/php`     | 指定 php 安装路径                                              |
   | `--enable-fpm`             | 构建 php-fpm 服务，`静态扩展`                                  |
   | `--enable-mbstring`        | 构建 mbstring 扩展，`动态扩展`                                 |
   | `--with-openssl`           | 构建 openssl 扩展，`动态扩展`                                  |
   | `--with-pcre-jit`          | 正则支持 jit 编译器，`静态扩展`                                |
   | `--enable-mysqlnd`         | 构建 mysqlnd 扩展（php 官方写的 mysql 驱动）                   |
   | `--with-pdo-mysql`         | 构建 pdo-mysql 扩展（默认使用 mysqlnd 驱动），`动态扩展`       |
   | `--with-curl=/server/curl` | 构建 curl 扩展（指定路径好处：不必担心多版本冲突），`静态扩展` |
   | `--without-cdb`            | 禁止构建 cdb 扩展（1 种数据库系统的扩展）                      |
   | `--without-sqlite3`        | 禁止构建 sqlite3 扩展（1 种数据库系统的扩展）                  |
   | `--without-pdo-sqlite`     | 禁止构建 pdo-sqlite 扩展（1 种数据库系统的扩展）               |

   具体指令如下：

   ```sh
   $ ../configure --prefix=/server/php \
   --enable-fpm \
   --enable-mbstring \
   --with-openssl \
   --with-pcre-jit \
   --enable-mysqlnd \
   --with-pdo-mysql \
   --with-curl=/server/curl \
   --without-cdb \
   --without-sqlite3 \
   --without-pdo-sqlite
   ```

3. `编译 & 测试 & 安装`

   ```sh
   $ make -j4
   $ make test
   $ make install
   ```

## PHP 命令行工具

`php-config` 是一个简单的命令行脚本用于获取所安装的 PHP 配置的信息。使用 -h 来查看：

```sh
$ cd /server/php/bin
./php-config -h
```

> 提示：在编译 php 扩展时，如果有多个 PHP 版本，可以使用 `--with-php-config` 选项来指定用于编译的 php 版本，该选项指定了 `php-config` 脚本的路径。

## 安装 PRCL 扩展

安装扩展的方式大同小异，下面是需要安装的两个 prcl 扩展

| PRCL 扩展                                          | 描述                    |
| -------------------------------------------------- | ----------------------- |
| [ImageMagic](https://pecl.php.net/package/imagick) | 处理图片的 PHP 扩展     |
| [xdebug](https://pecl.php.net/package/xdebug)      | 用于显示 PHP 错误的扩展 |

### phpize 程序

`phpize` 可以将 PECL 扩展源码构建为可用 `./configure` 编译的源码，使用 `phpize --help` 可以查看帮助。

1. 配置环境变量:

   将 php 二进制文件存放目录加入环境变量中，可以方便 `phpize` 操作

   > 修改控制环境变量的文件

   ```sh
   $ cp /etc/profile{,.bak}
   $ vim /etc/profile
   ```

   > `/etc/profile` 底部增加一行内容：

   ```sh
   export PATH=$PATH:/server/php/bin:/server/php/sbin
   ```

   > 使用 `source` 指令重新激活文件：

   ```sh
   $ source /etc/profile
   ```

2. 指定 php 配置文件

   使用 `phpize` 前，必须正确配置 `php.ini` 文件

   | 指令                                           | 描述                          |
   | ---------------------------------------------- | ----------------------------- |
   | `php --ini`                                    | 查询 php 配置文件信息         |
   | `/package/lnmp/php-7.3.11/php.ini-development` | php 配置文件模版 - 开发环境   |
   | `/package/lnmp/php-7.3.11/php.ini-production`  | php 配置文件模版 - 开部署环境 |

   > 具体操作如下：

   ```sh
   $ cp -p -r /package/lnmp/php-7.3.11/php.ini-development /server/php/lib/php.ini
   ```
