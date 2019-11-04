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

php 想要开启 curl 扩展，就必须安装 CURL 软件包，这是 curl 扩展的编译库和运行库

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

   | 构建选项                   | 描述                                               |
   | -------------------------- | -------------------------------------------------- |
   | `--prefix=/server/php`     | 指定 php 安装路径                                  |
   | `--enable-fpm`             | 构建 php-fpm 服务                                  |
   | `--enable-mbstring`        | 构建 mbstring 扩展                                 |
   | `--with-openssl`           | 构建 openssl 扩展                                  |
   | `--with-pcre-jit`          | 正则支持 jit 编译器                                |
   | `--enable-mysqlnd`         | 构建 mysqlnd 扩展（php 官方写的 mysql 驱动）       |
   | `--with-pdo-mysql`         | 构建 pdo-mysql 扩展（默认使用 mysqlnd 驱动）       |
   | `--with-curl=/server/curl` | 构建 curl 扩展（指定路径好处：不必担心多版本冲突） |
   | `--without-cdb`            | 禁止构建 cdb 扩展（1 种数据库系统的扩展）          |
   | `--without-sqlite3`        | 禁止构建 sqlite3 扩展（1 种数据库系统的扩展）      |
   | `--without-pdo-sqlite`     | 禁止构建 pdo-sqlite 扩展（1 种数据库系统的扩展）   |

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

## 扩展库操作

PHP 动态扩展库的具体安装方法请查阅[为 PHP 安装 PECL 扩展](./04-为php安装pecl扩展.md)

1. PHP 扩展分类：

   | 扩展类型 | 扩展类型说明                       | 操作方式                    |
   | -------- | ---------------------------------- | --------------------------- |
   | 静态扩展 | 编译安装 PHP 时，一起安装的扩展    | 只能通过重新编译 PHP 来修改 |
   | 动态扩展 | 使用 `phpize` 编译安装的 PECL 扩展 | 通过操作 `php.ini` 来控制   |

   > 提示：php 源码自带的扩展库，支持静态安装和动态安装，如果两个都安装了，默认以静态扩展方式优先!

2. 动态库操作：

   | 操作       | 案例                                               |
   | ---------- | -------------------------------------------------- |
   | 开启动态库 | `php.ini` 文件里添加 `extension=<库名>`            |
   | 禁用动态库 | `php.ini` 文件里删除指定的 `extension=<库名>` 内容 |

   > 提示：有些动态库是 `zend` 扩展库，需要使用 `zend_extension=<库名>` 开启，才能生效！

## `php-fpm` 服务

想 Nginx 这类 web 服务，只能处理静态页面，如果想要处理 php 脚本，就必须借助类似 `php-fpm` 的服务！

1. 配置 php-fpm

   下面是 `php-fpm` 两个重要的配置文件：

   | 所属进程                    | 对应配置文件       | 数量     |
   | --------------------------- | ------------------ | -------- |
   | 主进程                      | `php-fpm.conf`     | 1        |
   | pool 进程（即：工作池进程） | `php-fpm.d/*.conf` | 没有限制 |

   配置文件默认模块：

   | 所属进程  | 对应配置文件模块             |
   | --------- | ---------------------------- |
   | 主进程    | `php-fpm.conf.default`       |
   | pool 进程 | `php-fpm.d/www.conf.default` |
